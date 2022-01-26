# lorenzo's drums

an electroacoustic drumset.

![image](/img/150214610-62e945ed-bae6-44cf-b62a-e2ec63daad93.png)


this is a norns script that allows you to manipulate a high-quality drumset composed of many meticulously captured samples from [Lorenzo Wood](https://www.lorenzowoodmusic.com/)  (shared through [www.pianobook.co.uk](https://www.pianobook.co.uk/packs/lorenzos-drums-v1/)). each drum hit is composed of ~6 samples which are mixed according to the current mic positions (up to three positions) and velocity (interpoalted between two velocities of up to eight layers).


## Requirements

- norns
- grid (optional)
- at least 200 MB of disk space (for downloaded samples)

## Documentation

**quickstart**

the first time you start you will have to wait for samples to download. once done you can run by pressing **K1+K3**.

**guide**

- E1 selects drum 
- K1+E1 selects parameter
- E2/E3 changes position in grid
- K2/K3 decreases/increases value
- K1+K2 sets length of sequence
- K1+K3 toggles playing

![image1](/img/150213784-14164b1e-f48f-47fe-903a-351484ec0def.png)

![image2](/img/150213789-cdaaab9c-9084-4c5d-857c-cb95744d9048.png)

at the heart of lorenzo's drums are nine drum pieces (kick, snare, crossstick, closed hat, open hat, ride, low tom, mid tom, and high tom). each drum set piece has parameters that can be modulated by individual step sequences - including velocity, pan, rate, reverse, probability. each of these parameters are modulated by increasing the value of a step in its step sequencer. 


**grid**

the grid works too. for example... (TODO) **🦗🦗🦗🦗** 

**midi**

midi output and input is supported. midi output is sent per channel, each instrument on its own channel (1-9). midi input by default is note based but can be changed in the settings. instrument triggers can also be midimapped so you can use a midi controller instead of a keyboard.

**recording**

you can record quantized notes onto any track. enter recording mode by toggling `PARAMS > record`, or by going into "ERASE/REC" mode on the grid by making the last two buttons dim.



## todo

- testing loading/saving of banks
- add mic placement parameters
- add send parameters

## Install

install using with

```
;install https://github.com/schollz/lorenzos-samples
```

