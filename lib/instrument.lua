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

  o.default_mappings={{0,30,90},-- velocity main
    {0,30,60},-- velocity add
    {0,0,-60},-- velocity sub
    {0,0,1},-- pan add
    {0,0,-1},-- pan sub
    {0,0,1},-- rate add
    {0,0,-1},-- rate sub
    {0,0,1,true},-- reversed
    {0,0,1} -- skip probability
  }
  o.ptn={}
  for _,m in ipairs(o.default_mappings) do
    table.insert(o.ptn,slist:new({
      default=m[1],
      mapping={m[2],m[3]},
    binary=m[4]==nil and false or m[4]}))
  end
  o.playing=false
  o.muted=false
  o.show=false
  o.banks={}
  o.save={"id","name","swing","division","banks"}
  return o
end

function Instrument:encode()
  local d={}
  for _,key in ipairs(self.save) do
    d[key]=self[key]
  end
  d.ptn=self:dump_patterns()
  return json.encode(d)
end

function Instrument:decode(s)
  local d=json.decode(s)
  if d~=nil then
    for _,k in ipairs(self.save) do
      self[k]=d[k]
    end
  end
  self:load_patterns(d.ptn)
end

function Instrument:bank_save(i)
  self.banks[i]=self:dump_patterns()
end

function Instrument:bank_load(i)
  if self.banks[i]==nil then
    do return false end
  end

  self:load_patterns(self.banks[i])
  return true
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

function Instrument:emit()
  self.playing=false
  for _,p in ipairs(self.ptn) do
    p:iterate()
  end
  local skip=math.random()<self.ptn[9]:val()
  if self.ptn[1]:raw_val()==0 or self.muted or skip then
    do
      return
    end
  end

  local velocity=self.ptn[1]:val()+self.ptn[2]:val()+self.ptn[3]:val()
  local velocity_min_max={util.clamp(velocity-7,0,127),util.clamp(velocity+7,0,127)}
  velocity=math.random()*(velocity_min_max[2]-velocity_min_max[1])+velocity_min_max[1]
  local amp=1 -- to be set in parameters
  local pan=util.clamp(params:get(self.name.."pan")+self.ptn[4]:val()+self.ptn[5]:val(),-1,1)
  local rate=params:get(self.name.."rate")+self.ptn[6]:val()+self.ptn[7]:val()
  local lpf=18000
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
  --print(self.name,velocity,amp,pan,rate,lpf,sendReverb,sendDelay,startPos)
  engine[self.name](velocity,amp,pan,rate,lpf,sendReverb,sendDelay,startPos)
end

return Instrument
