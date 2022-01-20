-- lorenzo's drums
if not string.find(package.cpath,"/home/we/dust/code/lorenzos-drums/lib/") then
  package.cpath=package.cpath..";/home/we/dust/code/lorenzos-drums/lib/?.so"
end
json=require("cjson")
lattice_=require("lattice")
instrument_=include("lorenzos-drums/lib/instrument")
ggrid=include("lorenzos-drums/lib/ggrid")
engine.name="LorenzosDrums"
local cursor={1,1,false}
local shift=false
local message_text=""
local message_count=0

function init()
  if not util.file_exists(_path.audio.."lorenzos-drums") then
    msg("downloading samples...",1000)
    norns.system_cmd("cd ~/dust/audio && wget -q https://github.com/schollz/lorenzos-drums/releases/download/samples/lorenzos-drums.tar && tar -xvf lorenzos-drums.tar && rm lorenzos-drums.tar",function(x)
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
  drm={}
  props={"velocity","accent +","accent -","pan right","pan left","rate up","rate down","reverse","skip %"}
  instruments={"bd","sd","ch","oh","rc","tom1","tom2","tom3"}
  for i,name in ipairs(instruments) do
    table.insert(drm,instrument_:new({
      id=i,
      name=name
    }))
  end

  -- initialize grid
  g_=ggrid:new()

  -- initialize lattice
  lattice=lattice_:new()
  lattice_pattern={}
  for i,instrument in ipairs(drm) do
    lattice_pattern[i]=lattice:new_pattern{
      action=function()
        instrument_action(i)
      end,
      division=1/16
    }
  end

  -- demo
  local part=1
  local d=1
  local ptn={1,3,11,12}
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=6-i
  end
  local part=2
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=5-i
  end
  ptn={1,3,11}
  local part=3
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=5-i
  end
  local part=4
  ptn={3,4,11}
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=7-i
  end
  drm[d].ptn[1].finish=16*4
  drm[d].ptn[1]:update()

  part=1
  d=2
  ptn={5,8,10,13,16}
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=3+i/2
  end
  local part=2
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=3+i/3
  end
  ptn={5,8,10,15}
  local part=3
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=3+i/4
  end
  local part=4
  ptn={2,5,8,10,12,13,14,15,16}
  for i,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=3+i
  end
  drm[d].ptn[1].finish=16*4
  drm[d].ptn[1]:update()

  part=1
  d=5
  ptn={1}
  for _,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=3
  end
  drm[d].ptn[1].finish=2
  drm[d].ptn[1]:update()

  part=1
  d=4
  ptn={16*3+15}
  for _,p in ipairs(ptn) do
    drm[d].ptn[1].data[p+(part-1)*16]=3
  end
  drm[d].ptn[1].finish=16*4
  drm[d].ptn[1]:update()

  for d=6,8 do
    ptn={math.random(32,64),math.random(32,64),math.random(32,64),math.random(20,64)}
    for _,p in ipairs(ptn) do
      drm[d].ptn[1].data[p]=math.random(1,3)
    end
    drm[d].ptn[1].finish=16*4-math.random(1,20)
    drm[d].ptn[1]:update()
  end

  -- setup the redrawing
  show_grid=0
  clock.run(function()
    while true do
      clock.sleep(1/10)
      redraw()
      if show_grid>0 then
        show_grid=show_grid-1
      end
    end
  end)

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
  elseif path=="load" then
    loaded_num=loaded_num+1
    msg("loaded "..math.floor(loaded_num/220*100).."% samples...")
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
      g_sel_drm=util.clamp(g_sel_drm+d,1,8)
    end
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

function toggle_playing()
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
  screen.text_right(instruments[g_sel_drm].." / "..props[g_sel_ptn])

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
      for j,s in ipairs(sticks[i]) do
        if s~=nil then
          sticking[j]=s
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

  for i,d in ipairs(drm) do
    local v=d.name..(d.show and "2" or "1")
    if d.name=="oh" and not d.playing then
    else
      screen.display_png("/home/we/dust/code/lorenzos-drums/img/"..v..".png",0,0)
      if g_sel_drm==i or (g_sel_drm==3 and i==4) then
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
