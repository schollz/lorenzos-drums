local drum_patterns={}
drum_patterns["a blank"]=[[]]
drum_patterns["weird fishes"]=[[
  bd x-----xx--
  rc --x--x--x-
  cs --x-x-x-x-
  cs --x--x--x-
  ch x-x-x-xxx-
]]

-- bd x--x--x--x----x-
-- sd ----x-----x-----
-- ch -x-x-x-xxx-xxx-x
-- oh ----------------

-- bd x--x-x--x-xx----
-- sd ----x----x--x--x
-- ch -xxx-xxx-x-x-xxx
-- oh ----------------

-- bd x--x-------x--x-
-- sd ----x-------x---
-- ch -xxx-xxxxxx-xxxx
-- oh ----------------

-- bd x--x-----x-x--x-
-- sd ----x--xx----x--
-- ch -xxx-xxxx-x-xxxx
-- oh ---------x-x----

-- bd x--x--x--x---x--
-- sd ----x-----x-----
-- ch -xx--x-xxxxxx-xx
-- oh ---------------- 

-- bd x--x----x-xx-x--
-- sd ----x--x-x--x---
-- ch -xx--x-xxxxxxx-- 
-- oh --------------x-  

-- bd x--x----x-x---x-
-- sd ----x--x-x--x---
-- ch -xx--x-xxxxxxx-- 
-- oh ---------------- 

-- bd x--x----x-xx-xx-
-- sd ----x--x-x--x--x
-- ch -xx--x-xxxxxxxxx
-- oh ---------------- 

-- bd x-x--x----x---x-
-- sd ------x-----x--x
-- ch -x--x-xxxx-xxx--
-- oh ---------------- 

-- bd x--x-x-xx-xx-x--
-- sd ----x----x--x---
-- ch -x--x-xxxx-xxx--
-- oh --------------x- 

drum_patterns["brand e"]=[[
  bd x--x--x--x----x-
  sd ----x-----x-----
  ch -x-x-x-xxx-xxx-x
  oh ----------------
  
  bd x--x-x--x-xx----
  sd ----x----x--x--x
  ch -xxx-xxx-x-x-xxx
  oh ----------------
  
  bd x--x-------x--x-
  sd ----x-------x---
  ch -xxx-xxxxxx-xxxx
  oh ----------------
  
  bd x--x-----x-x--x-
  sd ----x--xx----x--
  ch -xxx-xxxx-x-xxxx
  oh ---------x-x----

  bd x-x--x----x---x-
  sd ------x-----x--x
  ch -x--x-xxxx-xxx--
  oh ---------------- 

  bd x--x-x-xx-xx-x--
  sd ----x----x--x---
  ch -x--x-xxxx-xxx--
  oh --------------x- 
]]

drum_patterns["funky drummer"]=[[
  bd x-x---x---x--x--
  sd ----x--x-x-xx--x
  ch xxxxxxx-xxxxx-xx
  oh -------x-----x--
]]

drum_patterns["walk this way"]=[[
  bd x------xx-x-----
  sd ----x-------x---
  ch --x-x-x-x-x-x-x-
  oh x---------------
]]

drum_patterns["jungle"]=[[
  bd x-x-------x------xx-------x-----
  sd ----x--x-x----x--x--x--x-x----x-
  ch x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-
  oh x-------------------------------
]]

drum_patterns["amen brother"]=[[
  bd x-x-------xx----
  sd ----x--x-x--x--x
  rc x-x-x-x-x-x-x-x-
  oh ----------------
  hh ----------------
  t1 ----------------
  t2 ----------------
  t3 ----------------
 
  bd x-x-------xx----
  sd ----x--x-x--x--x
  rc x-x-x-x-x-x-x-x-
  oh ----------------
  hh ----------------
  t1 ----------------
  t2 ----------------
  t3 ----------------
 
  bd x-x-------x-----
  sd ----x--x-x-----x
  rc x-x-x-x-x-x-x-x-
  oh ----------------
  hh ----------------
  t1 ----------------
  t2 ----------------
  t3 ----------------
 
  bd --xx------x-----
  sd -x--x--x-x----x-
  rc x-x-x-x-x---x-x-
  oh ----------x-----
  hh -----------x----
  t1 ---------xx-----
  t2 -----------xx---
  t3 -------------xxx
]]

-- https://repositori.upf.edu/bitstream/handle/10230/44875/gomez_CMMR2017_drum.pdf?isAllowed=y&sequence=1

drum_patterns["deep house"]=[[
  oh --x---x---x---x-
  ch ----x-xx----x-xx
  bd x---x---x---x---
  sd ---x-------x----
]]

drum_patterns["funk break"]=[[
  oh ------x---x-----
  ch xxxxxx--xx--xxxx
  bd x--x--x-x---x---
  sd ----x----x--x---
]]

return drum_patterns
