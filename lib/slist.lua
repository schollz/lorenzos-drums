local Slist={}
local s=require("sequins")

function Slist:new(o)
  o=o or {}
  setmetatable(o,self)
  self.__index=self
  -- check user defaults
  o.binary=o.binary or false
  o.mapping=o.mapping or {0,1}
  o.default=o.default or 0
  o.max=o.max or 96
  o.max_val=13
  o.start=o.start or 1
  o.finish=o.finish or 16
  -- initialize
  o.data={}
  for i=1,o.max do
    table.insert(o.data,o.default)
  end
  local foo={}
  for i=o.start,o.finish do
    table.insert(foo,i)
  end
  o.seq=s(foo)
  o.cur=1
  o.save={"binary","mapping","default","max","max_val","start","finish","data"}
  return o
end

function Slist:encode()
  local d={}
  for _,key in ipairs(self.save) do
    d[key]=self[key]
  end
  return json.encode(d)
end

function Slist:decode(s)
  local start=self.start
  local finnish=self.fiish
  local d=json.decode(s)
  if d~=nil then
    for k,v in pairs(d) do
      self[k]=v
    end
  end
  if self.start~=start or self.finish~=finish then
    self:update()
  end
end

function Slist:set_finish(n)
  if n>self.max then
    do
      return
    end
  end
  if self.start>n then
    self.start=n
  end
  self.finish=n
  self:update()
end

function Slist:set_start_finish(n1,n2)
  if n1>self.max or n2>self.max then
    do
      return
    end
  end
  if n1<n2 then
    self.start=n1
    self.finish=n2
  else
    self.start=n2
    self.finish=n1
  end
  self:update()
end

function Slist:update()
  local foo={}
  for i=self.start,self.finish do
    table.insert(foo,i)
  end
  self.seq:settable(foo)
end

function Slist:reset()
  print("resetting")
  self.cur=self.start
  self.seq:reset()
end

function Slist:iterate()
  self.cur=self.seq()
end

function Slist:val()
  return util.linlin(0,self.max_val,self.mapping[1],self.mapping[2],self.data[self.cur])
end

function Slist:raw_val()
  return self.data[self.cur]
end

function Slist:gdelta(row,col,d)
  local i=(row-1)*16+col
  self:delta(i,d)
end

function Slist:delta(i,d)
  if self.binary then
    self.data[i]=self.max_val-self.data[i]
  else
    self.data[i]=util.clamp(self.data[i]+d,0,self.max_val)
  end
end

function Slist:gerase(row,col)
  local i=(row-1)*16+col
  self:erase(i)
end

function Slist:erase(i)
  self.data[i]=self.default
end

return Slist
