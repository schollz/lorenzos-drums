local Instrument={}

local slist=include("lorenzos-drums/lib/slist")

function Instrument:new(o)
  o=o or {}
  setmetatable(o,self)
  self.__index=self

  -- check user defaults
  o.id=o.id or 1
  o.name=o.name or "bd"
  o.swing=o.swing or 50
  o.division=o.division or 1/16

  local main_mapping={20,80}
  main_mapping=o.id==2 and {1,90} or main_mapping
  o.default_mappings={{0,main_mapping[1],main_mapping[2]},-- velocity main
    {0,0,60},-- velocity add
    {0,0,-60},-- velocity sub
    {0,0,1},-- pan add
    {0,0,-1},-- pan sub
    {0,0,1},-- rate add
    {0,0,-1},-- rate sub
    {0,0,1,true},-- reversed
    {0,0,1} -- skip probability
  }
  o.ptn={}
  for i,m in ipairs(o.default_mappings) do
    table.insert(o.ptn,slist:new({
      finish=16,
      default=m[1],
      mapping={m[2],m[3]},
    binary=m[4]==nil and false or m[4]}))
  end
  o.playing=false
  o.muted=false
  o.show=false
  o.banks={}
  o.save={"id","name","swing","division","banks"}
  o.bankseq=s{0}
  o.bankseq_current=0
  return o
end

function Instrument:bankseq_add(i)
  local seq={}
  if msg_startswith("ptn") then
    for _,v in ipairs(self.bankseq.data) do
      table.insert(seq,v)
    end
  end
  table.insert(seq,i)
  self.bankseq:settable(seq)
  msg("ptn: "..table.concat(seq,"-"))
end

function Instrument:encode()
  local d={}
  for _,key in ipairs(self.save) do
    d[key]=self[key]
  end
  d["bankseq"]=self.bankseq.data
  d.ptn=self:dump_patterns()
  return json.encode(d)
end

function Instrument:decode(s)
  local d=json.decode(s)
  if d~=nil then
    for _,k in ipairs(self.save) do
      if k=="bankseq" then
        self.bankseq:settable(d[k])
      else
        self[k]=d[k]
      end
    end
  end
  self:load_patterns(d.ptn)
end

function Instrument:bank_save(i)
  self.banks[i]=self:dump_patterns()
end

function Instrument:bank_exists(i)
  return self.banks[i]~=nil
end

function Instrument:bank_load(i)
  if self:bank_exists(i) then
    self:load_patterns(self.banks[i])
  end
end

function Instrument:dump_patterns()
  local ptn={}
  for _,p in ipairs(self.ptn) do
    table.insert(ptn,p:encode())
  end
  return ptn
end

function Instrument:load_patterns(d)
  for i,s in ipairs(d) do
    self.ptn[i]:decode(s)
  end
end

function Instrument:reset()
  for _,p in ipairs(self.ptn) do
    p:reset()
  end
end

function Instrument:emit(velocity,pan,rate,lpf)
  self.playing=false
  if velocity==nil then
    for i,p in ipairs(self.ptn) do
      local has_reset=p:iterate()
      if i==1 and has_reset then
        -- swap banks
        local bankseq_new=self.bankseq()
        if bankseq_new>0 and self.bankseq_current~=bankseq_new then
          print(self.name..": switching to bank "..bankseq_new)
          self.bankseq_current=bankseq_new
          self:bank_load(self.bankseq_current)
        end
      end
    end
  end
  local skip=math.random()<self.ptn[9]:val()
  local dontskip=math.random(1,3)*(math.random()<0.0 and 1 or 0)
  dontskip=velocity and 1 or dontskip
  if dontskip==0 then
    if self.ptn[1]:raw_val()==0 or self.muted or skip then
      do
        return
      end
    end
  end
  if velocity==nil then
    velocity=self.ptn[1]:val()+self.ptn[2]:val()+self.ptn[3]:val()
    velocity=velocity>0 and velocity or dontskip
  end
  local velocity_min_max={util.clamp(velocity-7,0,127),util.clamp(velocity+7,0,127)}
  velocity=math.random()*(velocity_min_max[2]-velocity_min_max[1])+velocity_min_max[1]
  local amp=1 -- to be set in parameters
  pan=util.clamp(params:get(self.name.."pan")+(pan or (self.ptn[4]:val()+self.ptn[5]:val())),-1,1)
  rate=params:get(self.name.."rate")+(rate or self.ptn[6]:val()+self.ptn[7]:val())
  lpf=lpf or 18000
  local sendReverb=params:get(self.name.."reverbSend")/100
  local sendDelay=params:get(self.name.."delaySend")/100
  local reversed=self.ptn[8]:val()>0
  local startPos=0
  if reversed then
    rate=math.abs(rate)*-1
    startPos=math.random()*0.2+0.1
  end
  -- TODO implement prob and reverse
  self.playing=true
  self.show=true

  if debounce_record[self.id] then
    debounce_record[self.id]=false
    do return end
  end
  --print(self.name,velocity,amp,pan,rate,lpf,sendReverb,sendDelay,startPos)
  engine[self.name](velocity,amp,pan,rate,lpf,sendReverb,sendDelay,startPos)
  if params:get("midi_out")>1 then
    local m=midi_devices[midi_device_list[params:get("midi_out")]]
    m:note_on(params:get(self.name.."_midi_note"),velocity,params:get(self.name.."_midi_chan"))
  end
end

return Instrument
