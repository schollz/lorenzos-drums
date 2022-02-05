-- lorenzo's drums v0.1.0
-- an electroacoustic drumset.
--
-- llllllll.co/t/lorenzos-drums
--
--
--
--    ▼ instructions below ▼
--
-- E1 selects drum
-- K1+E1 selects parameter
-- E2/E3 changes position
-- K2/K3 decreases/increases
-- K1+K2 sets sequence length
-- K1+K3 toggles playing

if not string.find(package.cpath,"/home/we/dust/code/lorenzos-drums/lib/") then
  package.cpath=package.cpath..";/home/we/dust/code/lorenzos-drums/lib/?.so"
end
json=require("cjson")
lattice_=require("lattice")
instrument_=include("lorenzos-drums/lib/instrument")
ggrid=include("lorenzos-drums/lib/ggrid")
drum_patterns=include("lorenzos-drums/lib/patterns")
engine.name="LorenzosDrums"
local cursor={1,1,false}
local shift=false
local message_text=""
local message_count=0
drm={}
props={"velocity","accent +","accent -","pan right","pan left","rate up","rate down","reverse","skip %"}
instruments={"bd","sd","cs","ch","oh","rc","ht","mt","lt"}
disable_transport=false
debounce_record={false,false,false,false,false,false,false,false,false}
division_options_={"1/32","1/24","1/16","1/12","1/10","1/8","1/6","1/4","1/3","1/2","1","3/2","2"}
division_options={1/32,1/24,1/16,1/12,1/10,1/8,1/6,1/4,1/3,1/2,1,3/2,2}

function init()
  if not util.file_exists(_path.audio.."lorenzos-drums") then
    msg("downloading samples...",1000)
    norns.system_cmd("cd ~/dust/audio && wget -q https://github.com/schollz/lorenzos-drums/releases/download/samples/lorenzos-drums.tar.gz && tar -xzvf lorenzos-drums.tar.gz && rm lorenzos-drums.tar.gz",function(x)
      msg("downloaded samples.",10)
      engine.init()
    end)
  else
    msg("loading samples...",100)
    engine.init()
  end

  -- initialize selections
  g_sel_drm=1
  g_sel_ptn=1

  -- initialize drm / ptn
  reset_instruments()

  -- initialize grid
  g_=ggrid:new()

  -- initialize lattice
  lattice=lattice_:new()
  lattice_pattern={}
  lattice_last_beat=clock.get_beats()
  for i,instrument in ipairs(drm) do
    lattice_pattern[i]=lattice:new_pattern{
      action=function()
        instrument_action(i)
        if i==1 then
          lattice_last_beat=clock.get_beats()
        end
      end,
      division=1/16,
    }
  end

  -- setup the redrawing
  show_grid=0
  local counter=metro.init()
  counter.time=1/10
  counter.count=-1
  counter.event=function()
    redraw()
    if show_grid>0 then
      show_grid=show_grid-1
    end
  end
  counter:start()

  -- setup saving and loading
  params.action_write=function(filename,name)
    print("write",filename,name)
    local data={}
    for _,d in ipairs(drm) do
      table.insert(data,d:encode())
    end
    local fname=filename..".json"
    local file=io.open(fname,"w+")
    io.output(file)
    io.write(json.encode(data))
    io.close(file)
  end

  params.action_read=function(filename,silent)
    print("read",filename,silent)
    local fname=filename..".json"
    local f=io.open(fname,"rb")
    local content=f:read("*all")
    f:close()
    local data=json.decode(content)
    for i,s in ipairs(data) do
      drm[i]:decode(s)
    end
  end

  -- setup parameters
  local drum_pattern_options={}
  for k,_ in pairs(drum_patterns) do
    table.insert(drum_pattern_options,k)
  end
  table.sort(drum_pattern_options)
  params:add_option("choose pattern","choose pattern",drum_pattern_options)
  params:add{type="binary",name="load pattern",id="load pattern",behavior="trigger",
    action=function(v)
      print("uploading beat!")
      upload_beat(drum_patterns[drum_pattern_options[params:get("choose pattern")]])
    end
  }
  params:add{type="binary",name="record",id="record",behavior="toggle"}

  -- TODO: add midi in/out
  -- setup midi
  midi_devices={}
  midi_device_list={"none"}
  for _,dev in pairs(midi.devices) do
    table.insert(midi_device_list,dev.name)
    midi_devices[dev.name]=midi.connect(dev.port)
    midi_devices[dev.name].event=function(data)
      if dev.name~=midi_device_list[params:get("midi_in")] then
        do return end
      end
      local msg=midi.to_msg(data)
      if msg.type=="clock" then
        do return end
      end
      if msg.type=="continue" then
        toggle_playing(true)
      elseif msg.type=="stop" then
        toggle_playing(false)
      end
      if msg.type=="note_on" then
        if msg.ch<=9 and instruments[msg.ch]~=nil then
          engine[instruments[msg.ch]](msg.vel,0.5,0,1,18000,0,0,0)
        end
      end
    end
  end
  params:add_group("midi",2+(9*2))
  params:add_option("midi_in","midi in",midi_device_list,1)
  params:add_option("midi_out","midi out",midi_device_list,1)
  local DEFAULT_NOTES={
    -- General MIDI standard
    36,-- Kick
    38,-- Snare
    37,-- Rim
    42,-- Closed hi-hat
    46,-- Open hi-hat
    51,-- ride
    50,-- hi tom
    48,-- mid tom
    45,-- low tom
  }
  for i,track in ipairs(instruments) do
    local note_param_id=track.."_midi_note"
    params:add_number(note_param_id,track..": midi note",0,127,DEFAULT_NOTES[i])
    local chan_param_id=track.."_midi_chan"
    params:add_number(chan_param_id,track..": midi chan",1,16,1)
  end

  params:add_group("mixer",#instruments)
  for _,ins in ipairs(instruments) do
    params:add{type="control",id=ins.."vol",name=ins,controlspec=controlspec.new(-96,36,'lin',0.1,0,'',0.1/(36+96)),formatter=function(v)
      local val=math.floor(util.linlin(0,1,v.controlspec.minval,v.controlspec.maxval,v.raw)*10)/10
      return ((val<0) and "" or "+")..val.." dB"
    end}
    params:set_action(ins.."vol",function(x)
      engine[ins.."_amp"](util.dbamp(x))
    end)
  end

  params:add_group("effects",4)
  local defaults={18000,60}
  for i,filt in ipairs({"lpf","hpf"}) do
    params:add{type="control",id=filt,name=filt.." freq",controlspec=controlspec.new(10,18000,'exp',10,defaults[i],'Hz',10/18000),action=function(x)
      engine.fx(filt,x)
    end}
    params:add{type="control",id=filt.."rq",name=filt.." rq",controlspec=controlspec.new(0.05,1,'lin',0.05,0.65,'',0.05/1),action=function(x)
      engine.fx(filt.."rq",x)
    end}
  end

  local mics={
    bd=3,
    sd=3,
    cs=3,
    rc=3,
    oh=2,
    ch=2,
    ht=2,
    mt=2,
    lt=2,
  }
  local mic_names={"hat","snare","kick"}
  for ins_i,ins in ipairs(instruments) do
    local mic_num=mics[ins]
    params:add_group(ins,mic_num+7)
    params:add_option(ins.."division","clock division",division_options_,3)
    params:set_action(ins.."division",function(x)
      drm[ins_i].division=division_options[x]
    end)
    params:add_control(ins.."swing","swing",controlspec.new(0,100,"lin",1,50,"%",1/100))
    params:set_action(ins.."swing",function(x)
      drm[ins_i].swing=math.floor(x)
    end)
    for i=1,mic_num do
      params:add{type="control",id=ins.."mic"..i,name=mic_names[i].." mic",controlspec=controlspec.new(-96,36,'lin',0.1,-9,'',0.1/(36+96)),formatter=function(v)
        local val=math.floor(util.linlin(0,1,v.controlspec.minval,v.controlspec.maxval,v.raw)*10)/10
        return ((val<0) and "" or "+")..val.." dB"
      end}
      params:set_action(ins.."mic"..i,function(x)
        if mic_num==2 then
          engine[ins.."_mix"](util.dbamp(params:get(ins.."mic1")),util.dbamp(params:get(ins.."mic2")))
        else
          engine[ins.."_mix"](util.dbamp(params:get(ins.."mic1")),util.dbamp(params:get(ins.."mic2")),util.dbamp(params:get(ins.."mic3")))
        end
      end)
    end
    params:add_control(ins.."pan","pan",controlspec.new(-1,1,"lin",0.01,0,"",0.01/2))
    params:add_control(ins.."rate","rate",controlspec.new(-2,2,"lin",0.01,1,"x",0.01/2))
    params:add_control(ins.."reverbSend","reverb send",controlspec.new(0,100,"lin",1,0,"%",1/100))
    params:add_control(ins.."delaySend","delay send",controlspec.new(0,100,"lin",1,0,"%",1/100))
    params:add{type="binary",name="trigger",id=ins.."trigger",behavior="trigger",
      action=function(v)
        trigger_ins(ins_i)
      end
    }
  end
end

function trigger_ins(i)
  print("triggering "..i)
  if params:get("record")==1 then
    local ix=drm[i].ptn[1].seq.ix
    local pos_current=drm[i].ptn[1].seq.data[ix]
    local pos_next=pos_current+1
    if ix==drm[i].ptn[1].seq.length then
      pos_next=drm[i].ptn[1].seq.data[1]
    end
    local pos=pos_current
    if clock.get_beats()-lattice_last_beat>clock.get_beat_sec()*drm[i].division*2 then
      -- use next beat
      pos=pos_next
    end
    if drm[i].ptn[1].data[pos]==0 then
      drm[i].ptn[1].data[pos]=math.random(4,7)
    else
      drm[i].ptn[1].data[pos]=util.clamp(drm[i].ptn[1].data[pos]+math.random(1,2),0,15)
    end
  end
  local velocity=math.random(30,60)
  local pan=0
  local rate=0
  local lpf=18000
  local sendReverb=0
  local sendDelay=0
  local reversed=false
  drm[i]:emit(velocity,pan,rate,lpf)
  if params:get("record")==1 then
    debounce_record[i]=true
  end
end

function reset_instruments()
  local foo={}
  for i,name in ipairs(instruments) do
    table.insert(foo,instrument_:new({
      id=i,
      name=name
    }))
  end
  drm=foo
end

function upload_beat(s)
  reset_instruments()

  local beat=collect_beat(s)
  local ins_alias={bd=1,sd=2,cs=3,hh=4,ch=4,oh=5,rc=6,ht=7,t1=7,mt=8,t2=8,lt=9,t3=9}

  for _,v in ipairs(beat) do
    local i=ins_alias[v.name]
    if i~=nil then
      drm[i].ptn[1].finish=v.len
      drm[i].ptn[1]:update()
      local row=1
      for _,pos in ipairs(v.pos) do
        drm[i].ptn[1].data[pos]=7
      end
    end
  end
end

function collect_beat(s)
  local tabs={}
  for line in string.gmatch(s,'[^\r\n]+') do
    local words={}
    for w in line:gmatch("%S+") do
      table.insert(words,w)
    end
    if words[1]~=nil then
      if tabs[words[1]]==nil then
        tabs[words[1]]=""
      end
      tabs[words[1]]=tabs[words[1]]..words[2]
    end
  end

  local hits={}
  for k,v in pairs(tabs) do
    local hit={}
    for i=1,#v do
      local c=v:sub(i,i)
      if c~="-" then
        table.insert(hit,i)
      end
    end
    table.insert(hits,{name=k,pos=hit,len=#v})
  end
  return hits
end

function msg(s,t)
  message_text=s
  message_count=t or 20
end

function instrument_action(i)
  drm[i]:emit()
  if lattice_pattern[i].swing~=drm[i].swing then
    lattice_pattern[i]:set_swing(drm[i].swing)
  end
  if lattice_pattern[i].division~=drm[i].division then
    lattice_pattern[i]:set_division(drm[i].division)
  end
end

local loaded_num=0

function osc.event(path,args,from)
  if path=="done" then
    msg("samples loaded.",10)
    upload_beat(drum_patterns["a blank"])
    -- toggle_playing()
    for i=1,9 do
      drm[i]:bank_save(1)
    end
  elseif path=="load" then
    loaded_num=loaded_num+1
    msg("loaded "..math.floor(loaded_num/265*100).."% samples...")
  end
end

function enc(k,d)
  if k>1 then
    if k==2 then
      cursor[3-(k-1)]=util.clamp(cursor[3-(k-1)]+d,1,k==2 and 16 or 7)
    else
      cursor[3-(k-1)]=util.clamp(cursor[3-(k-1)]-d,1,k==2 and 16 or 7)
    end
    show_grid=30
  else
    d=d>=0 and 1 or-1
    if shift then
      g_sel_ptn=util.clamp(g_sel_ptn+d,1,9)
    else
      g_sel_drm=util.clamp(g_sel_drm+d,1,9)
    end
  end
  if show_grid>0 then
    show_grid=30
  end
end

function key(k,z)
  if k==1 then
    shift=z==1
  elseif k>=2 and z==1 then
    if shift and k==3 then
      toggle_playing()
    elseif shift then
      drm[g_sel_drm].ptn[g_sel_ptn]:set_finish((cursor[1]-1)*16+cursor[2])
      show_grid=30
    else
      drm[g_sel_drm].ptn[g_sel_ptn]:gdelta(cursor[1],cursor[2],k==2 and-1 or 1)
      show_grid=30
    end
  end
end

function clock.transport.start()
  if disable_transport then
    do return end
  end
  print("transport start")
  toggle_playing(true)
end

function clock.transport.stop()
  if disable_transport then
    do return end
  end
  print("transport stop")
  toggle_playing(false)
end

function toggle_playing(on)
  disable_transport=true
  clock.run(function()
    clock.sleep(1)
    disable_transport=false
  end)
  if on~=nil then
    if on then
      lattice:hard_restart()
    else
      lattice:stop()
    end
    do return end
  end
  if lattice.enabled then
    lattice:stop()
    for _,d in ipairs(drm) do
      d:reset()
    end
  else
    lattice:hard_restart()
  end
end

local sticks={}
sticks[1]={{54,14,62,24},{76,16,67,23}}
sticks[2]={{84,32,71,19},{89,30,81,18}}
sticks[3]={nil,{77,32,94,22}}
sticks[4]={nil,{80,27,95,14}}
sticks[5]={{38,14,67,20},nil}
sticks[6]={{40,34,51,20},nil}
sticks[7]={{56,21,66,15},nil}
sticks[8]={{70,18,83,20},nil}

-- TODO: add method to clear current

function redraw()
  screen.clear()
  if show_grid>0 then
    draw_pattern()
  else
    draw_drums()
  end
  screen.level(15)
  screen.move(120,7)
  screen.text_right(instruments[g_sel_drm].." / "..props[g_sel_ptn].."  "..(lattice.enabled and ">" or "||"))

  if message_count>0 then
    message_count=message_count-1
    screen.level(0)
    x=64
    y=28
    w=string.len(message_text)*6
    screen.rect(x-w/2,y,w,10)
    screen.fill()
    screen.level(15)
    screen.rect(x-w/2,y,w,10)
    screen.stroke()
    screen.move(x,y+7)
    screen.text_center(message_text)
  end

  screen.update()
end

function draw_pattern()
  screen.aa(0)
  screen.line_width(1)

  local x=2
  local y=6
  local size=7
  for row=1,7 do
    for col=1,16 do
      screen.level(7)
      screen.rect(x+col*size,y+row*size,size,size)
      screen.stroke()
      local val=g_.visual[row][col]
      if val>0 then
        fill_cell(x,y,row,col,size,val)
      end
    end
  end
  screen.level(15)
  screen.rect(x+cursor[2]*size,y+cursor[1]*size,size,size)
  screen.stroke()
end

function fill_cell(x,y,row,col,size,l)
  screen.level(l or 15)
  screen.rect(x+col*(size)+1,y+row*(size)+1,size-3,size-3)
  screen.fill()
end

function draw_drums()
  screen.blend_mode(0)
  screen.level(0)
  screen.rect(0,0,129,65)
  screen.fill()

  local sticking={sticks[1][1],sticks[1][2]}

  for i,d in ipairs(drm) do
    if d.show and math.random()<0.5 then
      if sticks[i]~=nil then
        for j,s in ipairs(sticks[i]) do
          if s~=nil then
            sticking[j]=s
          end
        end
      end
    end
  end
  for _,stick in ipairs(sticking) do
    screen.level(15)
    screen.line_width(2)
    screen.line_cap("round")
    screen.move(stick[1],stick[2])
    screen.line(stick[3],stick[4])
    screen.stroke()
  end

  for i=#drm,1,-1 do
    local d=drm[i]
    local v=d.name..(d.show and "2" or "1")
    if d.name=="oh" and not d.playing then
    elseif d.name=="sd" and not d.playing then
    else
      screen.display_png("/home/we/dust/code/lorenzos-drums/img/"..v..".png",0,0)
      if g_sel_drm==i or (g_sel_drm==4 and i==5) or (g_sel_drm==2 and i==3) then
        for j=1,2 do
          screen.update()
          screen.blend_mode(2)
          screen.display_png("/home/we/dust/code/lorenzos-drums/img/"..v..".png",0,0)
          screen.blend_mode(0)
        end
      end
    end
    d.show=false
  end

end

function rand(a,b)
  return function()
    return math.random(a,b)
  end
end
