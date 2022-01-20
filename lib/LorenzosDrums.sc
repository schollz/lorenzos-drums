// https://www.pianobook.co.uk/packs/lorenzos-drums-v1/
LorenzosDrums {
	
	var server;
	var effects;
	var busReverb;
	var busDelay;

	// the kick
	var mixKick;
	var namesKick;
	var bufKick;
	var synKick;
	var ampKick;
	var namesMicKick;

	// the snare
	var mixSnare;
	var namesSnare;
	var bufSnare;
	var synSnare;
	var ampSnare;
	var namesMicSnare;
	
	// the closedhat
	var mixCH;
	var namesCH;
	var bufCH;
	var <synCH;
	var ampCH;
	var namesMicCH;
	
	// the openhat
	var mixOH;
	var namesOH;
	var bufOH;
	var <synOH;
	var ampOH;
	var namesMicOH;
	
	// the Tom1
	var mixTom1;
	var namesTom1;
	var bufTom1;
	var <synTom1;
	var ampTom1;
	var namesMicTom1;
	
	// the Tom2
	var mixTom2;
	var namesTom2;
	var bufTom2;
	var <synTom2;
	var ampTom2;
	var namesMicTom2;
	
	
	// the Tom3
	var mixTom3;
	var namesTom3;
	var bufTom3;
	var <synTom3;
	var ampTom3;
	var namesMicTom3;
	
	// the Ride
	var mixRide;
	var namesRide;
	var bufRide;
	var <synRide;
	var ampRide;
	var namesMicRide;
	var fileLoadCount=0;
	
	// the crossstick CS
	var mixCS;
	var namesCS;
	var bufCS;
	var <synCS;
	var ampCS;
	var namesMicCS;
	
	*new {
		arg serverName,folderToSamples;
		^super.new.init(serverName,folderToSamples);
	}

	loadCheck {
		fileLoadCount=fileLoadCount+1;
		fileLoadCount.postln;
	}
	
	init {
		arg serverName,folderToSamples;
		
		server=serverName;
		
		busReverb=Bus.audio(server,2);
		busDelay=Bus.audio(server,2);
		effects=LDEffects.new(server,busReverb,busDelay);

		Routine {
			"loading lorenzo's drumset...".postln;
			
			"loading kick".postln;
			namesMicKick=["hat","snare","kick"];
			namesKick=[
				["Kick pp RR2","Kick pp RR1"],
				["Kick p RR2","Kick p RR3","Kick p RR1"],
				["Kick mf RR2","Kick mf RR3","Kick mf RR1"],
				["Kick f RR2","Kick f RR3","Kick f RR1"],
				["Kick ff RR2","Kick ff RR3","Kick ff RR1"],
			];
			bufKick=Array.fill(namesMicKick.size,{arg h;
				Array.fill(namesKick.size,{ arg i;
					Array.fill(namesKick[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicKick[h]++Platform.pathSeparator++namesKick[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampKick=1.0;
			mixKick=Array.fill(3,{1/3});
			
			"loading snare".postln;
			namesMicSnare=["hat","snare","kick"];
			namesSnare=[
				["Snare pp RR2","Snare pp RR1"],
				["Snare p RR4","Snare p RR3","Snare p RR2","Snare p RR1"],
				["Snare mp RR4","Snare mp RR3","Snare mp RR2","Snare mp RR1"],
				["Snare mf RR4","Snare mf RR3","Snare mf RR2","Snare mf RR1"],
				["Snare f RR4","Snare f RR3","Snare f RR2","Snare f RR1"],
				["Snare ff RR4","Snare ff RR3","Snare ff RR2","Snare ff RR1"],
			];
			bufSnare=Array.fill(namesMicSnare.size,{arg h;
				Array.fill(namesSnare.size,{ arg i;
					Array.fill(namesSnare[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicSnare[h]++Platform.pathSeparator++namesSnare[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampSnare=1.0;
			mixSnare=Array.fill(3,{1/3});
			
			
			
			"loading hat".postln;
			namesMicCH=["hat","snare"];
			namesCH=[
				["Hat p RR1","Hat p RR2","Hat p RR3","Hat p RR4"],
				["Hat mp RR1","Hat mp RR2","Hat mp RR3","Hat mp RR4"],
				["Hat mf RR1","Hat mf RR2","Hat mf RR3","Hat mf RR4"],
				["Hat f RR1","Hat f RR2","Hat f RR3","Hat f RR4"],
				["Hat ff RR1","Hat ff RR2","Hat ff RR3","Hat ff RR4"],
			];
			bufCH=Array.fill(namesMicCH.size,{arg h;
				Array.fill(namesCH.size,{ arg i;
					Array.fill(namesCH[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicCH[h]++Platform.pathSeparator++namesCH[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampCH=1.0;
			mixCH=Array.fill(namesMicCH.size,{1/namesMicCH.size});
			
			
			"loading open hat".postln;
			namesMicOH=["hat","snare"];
			namesOH=[
				["Hat o1"],
				["Hat o2"],
				["Hat o3"],
				["Hat o4"],
				["Hat o5"],
				["Hat Open mp RR1","Hat Open mp RR2"],
				["Hat Open f RR1","Hat Open f RR2"],
				["Hat Open ff RR1","Hat Open ff RR2"],
			];
			bufOH=Array.fill(namesMicOH.size,{arg h;
				Array.fill(namesOH.size,{ arg i;
					Array.fill(namesOH[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicOH[h]++Platform.pathSeparator++namesOH[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampOH=1.0;
			mixOH=Array.fill(namesMicOH.size,{1/namesMicOH.size});
			
			// Tom1
			"loading tom1".postln;
			namesMicTom1=["hat","snare"];
			namesTom1=[
				["Tom1 p"],
				["Tom1 mf"],
				["Tom1 f RR1","Tom1 f RR2"],
				["Tom1 ff"],
			];
			bufTom1=Array.fill(namesMicTom1.size,{arg h;
				Array.fill(namesTom1.size,{ arg i;
					Array.fill(namesTom1[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicTom1[h]++Platform.pathSeparator++namesTom1[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampTom1=1.0;
			mixTom1=Array.fill(namesMicTom1.size,{1/namesMicTom1.size});
			
			
			// Tom2
			namesMicTom2=["hat","snare"];
			namesTom2=[
				["Tom2 pp"],
				["Tom2 p"],
				["Tom2 mp"],
				["Tom2 mf"],
				["Tom2 f RR1","Tom2 f RR2"],
			];
			bufTom2=Array.fill(namesMicTom2.size,{arg h;
				Array.fill(namesTom2.size,{ arg i;
					Array.fill(namesTom2[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicTom2[h]++Platform.pathSeparator++namesTom2[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampTom2=1.0;
			mixTom2=Array.fill(namesMicTom2.size,{1/namesMicTom2.size});
			
			
			
			
			// Tom3
			namesMicTom3=["hat","snare"];
			namesTom3=[
				["Tom3 p"],
				["Tom3 mf RR1","Tom3 mf RR2"],
				["Tom3 f RR1","Tom3 f RR2"],
			];
			bufTom3=Array.fill(namesMicTom3.size,{arg h;
				Array.fill(namesTom3.size,{ arg i;
					Array.fill(namesTom3[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicTom3[h]++Platform.pathSeparator++namesTom3[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampTom3=1.0;
			mixTom3=Array.fill(namesMicTom3.size,{1/namesMicTom3.size});
			
			
						
			// Ride
			namesMicRide=["hat","snare","kick"];
			namesRide=[
				["Ride p RR1","Ride p RR2"],
				["Ride mf RR1","Ride mf RR2"],
				["Ride ff RR1","Ride ff RR2"],
			];
			bufRide=Array.fill(namesMicRide.size,{arg h;
				Array.fill(namesRide.size,{ arg i;
					Array.fill(namesRide[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicRide[h]++Platform.pathSeparator++namesRide[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampRide=1.0;
			mixRide=Array.fill(namesMicRide.size,{1/namesMicRide.size});
			
			// CS
			namesMicCS=["hat","snare","kick"];
			namesCS=[
				["cs1","cs2","cs3"],
				["cs4","cs5","cs6"],
				["cs7","cs8","cs9"],
				["cs10","cs11","cs12"],
				["cs13","cs14","cs15"],
			];
			bufCS=Array.fill(namesMicCS.size,{arg h;
				Array.fill(namesCS.size,{ arg i;
					Array.fill(namesCS[i].size,{ arg j;
						server.sync; Buffer.read(server,folderToSamples++Platform.pathSeparator++namesMicCS[h]++Platform.pathSeparator++namesCS[i][j]++".wav",action:{arg fname; NetAddr("127.0.0.1",10111).sendMsg("load",1);});
					});
				});
				
			});
			ampCS=1.0;
			mixCS=Array.fill(namesMicCS.size,{1/namesMicCS.size});



			server.sync;
			"samples loaded!".postln;
			NetAddr("127.0.0.1", 10111).sendMsg("done",1);   
		}.play;

		
		// basic players
		
		SynthDef("playx2",{
			arg out=0,pan=0,amp=1.0,reverbOut,reverbSend=0,buf,t_trig=1,rate=1,fade_trig=0,fade_time=0.1,startPos=0,
			lpf=18000,busReverb,busDelay,sendReverb=0,sendDelay=0;
			var snd;
			snd=PlayBuf.ar(2,buf,rate,t_trig,startPos:startPos*BufFrames.ir(buf),doneAction:2);
			DetectSilence.ar(snd,0.0001,doneAction:2);
			snd=snd*EnvGen.ar(Env.new([1,0],[fade_time]),fade_trig,doneAction:2);
			snd=Balance2.ar(snd[0],snd[1],pan,amp);
			Out.ar(out,snd);
			Out.ar(busReverb,snd*sendReverb);
			Out.ar(busDelay,snd*sendDelay);
		}).send(server);
		
		SynthDef("playx1",{
			arg out=0,pan=0,amp=1.0,reverbOut,reverbSend=0,buf,t_trig=1,rate=1,fade_trig=0,fade_time=0.1,startPos=0,
			lpf=18000,busReverb,busDelay,sendReverb=0,sendDelay=0;
			var snd;
			snd=PlayBuf.ar(1,buf,rate,t_trig,startPos:startPos*BufFrames.ir(buf),doneAction:2);
			DetectSilence.ar(snd,0.0001,doneAction:2);
			snd=snd*EnvGen.ar(Env.new([1,0],[fade_time]),fade_trig,doneAction:2);
			snd=Pan2.ar(snd,pan,amp);
			Out.ar(out,snd);
			Out.ar(busReverb,snd*sendReverb);
			Out.ar(busDelay,snd*sendDelay);
		}).send(server);
		
		"done loading.".postln;
	}
	

	// set an effect parameter
	setFxParam {
		arg key, value;
		effects.setParam(key, value);
	}


	setMixKick {
		arg hat,snare,kick;
		mixKick[0]=hat;
		mixKick[1]=snare;
		mixKick[2]=kick;
	}
	
	setAmpKick {
		arg amp;
		ampKick=amp;
	}
	
	
	playKick {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		// <assignSamples>
		var names=namesKick;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all
		synKick.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1);
			});
		});
		synKick=Array.new(namesMicKick.size*2);
		namesMicKick.do({ arg name,i;
			var buffer1=bufKick[i][buf1][bufKick[i][buf1].size.rand];
			var buffer2=bufKick[i][buf2][bufKick[i][buf2].size.rand];
			if (buffer1.numChannels.notNil,{
				synKick.add(Synth.head(server,"playx"++buffer1.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixKick[i]*ampKick,\buf,buffer1
				]));
			});
			if (buffer2.numChannels.notNil,{
				synKick.add(Synth.head(server,"playx"++buffer2.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixKick[i]*ampKick,\buf,buffer2
				]));
			});
		});
		synKick.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}
	
	setMixSnare {
		arg hat,snare,kick;
		mixSnare[0]=hat;
		mixSnare[1]=snare;
		mixSnare[2]=kick;
	}
	
	setAmpSnare {
		arg amp;
		ampSnare=amp;
	}
	
	playSnare {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		// <assignSamples>
		var names=namesSnare;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all
		synSnare.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1,\rate,-1);
			});
		});
		synSnare=Array.new(namesMicSnare.size*2);
		namesMicSnare.do({ arg name,i;
			var buffer1=bufSnare[i][buf1][bufSnare[i][buf1].size.rand];
			var buffer2=bufSnare[i][buf2][bufSnare[i][buf2].size.rand];
			if (buffer1.numChannels.notNil,{
				synSnare.add(Synth.head(server,"playx"++buffer1.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixSnare[i]*ampSnare,\buf,buffer1
				]));
			});
			if (buffer2.numChannels.notNil,{
				synSnare.add(Synth.head(server,"playx"++buffer2.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixSnare[i]*ampSnare,\buf,buffer2
				]));
			});
		});
		synSnare.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}
	
	
	// CH
	
	setMixCH {
		arg hat,snare;
		mixCH[0]=hat;
		mixCH[1]=snare;
	}
	
	setAmpCH {
		arg amp;
		ampCH=amp;
	}
	
	
	playCH {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		var isrunning=false;
		// <assignSamples>
		var names=namesCH;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all the open hats
		synOH.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1,\rate,1.neg);
			});
		});
		
		// stop all
		synCH.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1);
			});
		});
		synCH=Array.new(namesMicCH.size*2);
		namesMicCH.do({ arg name,i;
			var buffer1=bufCH[i][buf1][bufCH[i][buf1].size.rand];
			var buffer2=bufCH[i][buf2][bufCH[i][buf2].size.rand];
			if (buffer1.numChannels.notNil,{
				synCH.add(Synth.head(server,"playx"++buffer1.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixCH[i]*ampCH,\buf,buffer1
				]));
			});
			if (buffer2.numChannels.notNil,{
				synCH.add(Synth.head(server,"playx"++buffer2.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixCH[i]*ampCH,\buf,buffer2
				]));
			});
		});
		synCH.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}
	
	
	
	// OH
	
	setMixOH {
		arg hat,snare;
		mixOH[0]=hat;
		mixOH[1]=snare;
	}
	
	setAmpOH {
		arg amp;
		ampOH=amp;
	}
	
	
	playOH {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		var isrunning=false;
		// <assignSamples>
		var names=namesOH;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all the closedhats
		synCH.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1);
			});
		});
		
		synOH.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1);
			});
		});
		synOH=Array.new(namesMicOH.size*2);
		namesMicOH.do({ arg name,i;
			var buffer1=bufOH[i][buf1][bufOH[i][buf1].size.rand];
			var buffer2=bufOH[i][buf2][bufOH[i][buf2].size.rand];
			if (buffer1.numChannels.notNil,{
				synOH.add(Synth.head(server,"playx"++buffer1.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixOH[i]*ampOH,\buf,buffer1
				]));
			});
			if (buffer2.numChannels.notNil,{
				synOH.add(Synth.head(server,"playx"++buffer2.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixOH[i]*ampOH,\buf,buffer2
				]));
			});
		});
		synOH.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
		
	}
	
	
	setMixTom1 {
		arg hat,snare;
		mixTom1[0]=hat;
		mixTom1[1]=snare;
	}
	
	setAmpTom1 {
		arg amp;
		ampTom1=amp;
	}
	
	playTom1 {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		// <assignSamples>
		var names=namesTom1;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all
		synTom1.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1);
			});
		});
		synTom1=Array.new(namesMicTom1.size*2);
		namesMicTom1.do({ arg name,i;
			var buffer1=bufTom1[i][buf1][bufTom1[i][buf1].size.rand];
			var buffer2=bufTom1[i][buf2][bufTom1[i][buf2].size.rand];
			if (buffer1.numChannels.notNil,{
				synTom1.add(Synth.head(server,"playx"++buffer1.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixTom1[i]*ampTom1,\buf,buffer1
				]));
			});
			if (buffer2.numChannels.notNil,{
				synTom1.add(Synth.head(server,"playx"++buffer2.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixTom1[i]*ampTom1,\buf,buffer2
				]));
			});
		});
		synTom1.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}
	
	setMixTom2 {
		arg hat,snare;
		mixTom2[0]=hat;
		mixTom2[1]=snare;
	}
	
	setAmpTom2 {
		arg amp;
		ampTom2=amp;
	}
	
	playTom2 {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		// <assignSamples>
		var names=namesTom2;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all
		synTom2.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1);
			});
		});
		synTom2=Array.new(namesMicTom2.size*2);
		namesMicTom2.do({ arg name,i;
			var buffer1=bufTom2[i][buf1][bufTom2[i][buf1].size.rand];
			var buffer2=bufTom2[i][buf2][bufTom2[i][buf2].size.rand];
			if (buffer1.numChannels.notNil,{
				synTom2.add(Synth.head(server,"playx"++buffer1.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixTom2[i]*ampTom2,\buf,buffer1
				]));
			});
			if (buffer2.numChannels.notNil,{
				synTom2.add(Synth.head(server,"playx"++buffer2.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixTom2[i]*ampTom2,\buf,buffer2
				]));
			});
		});
		synTom2.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}
	
	
	
	setMixTom3 {
		arg hat,snare;
		mixTom3[0]=hat;
		mixTom3[1]=snare;
	}
	
	setAmpTom3 {
		arg amp;
		ampTom3=amp;
	}
	
	playTom3 {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		// <assignSamples>
		var names=namesTom3;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all
		synTom3.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1);
			});
		});
		synTom3=Array.new(namesMicTom3.size*2);
		namesMicTom3.do({ arg name,i;
			var buffer1=bufTom3[i][buf1][bufTom3[i][buf1].size.rand];
			var buffer2=bufTom3[i][buf2][bufTom3[i][buf2].size.rand];
			if (buffer1.numChannels.notNil,{
				synTom3.add(Synth.head(server,"playx"++buffer1.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixTom3[i]*ampTom3,\buf,buffer1
				]));
			});
			if (buffer2.numChannels.notNil,{
				synTom3.add(Synth.head(server,"playx"++buffer2.numChannels,[
					\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixTom3[i]*ampTom3,\buf,buffer2
				]));
			});
		});
		synTom3.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}
	
	
	
	
	setMixRide {
		arg hat,snare,kick;
		mixRide[0]=hat;
		mixRide[1]=snare;
		mixRide[2]=kick;
	}
	
	setAmpRide {
		arg amp;
		ampRide=amp;
	}
	
	playRide {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		// <assignSamples>
		var names=namesRide;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all
		synRide.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1,\rate,-1);
			});
		});
		synRide=Array.new(namesMicRide.size*2);
		namesMicRide.do({ arg name,i;
			var buffer1=bufRide[i][buf1][bufRide[i][buf1].size.rand];
			var buffer2=bufRide[i][buf2][bufRide[i][buf2].size.rand];
			if (buffer2.numChannels.notNil,{
				synRide.add(Synth.head(server,"playx"++buffer1.numChannels,[
				\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixRide[i]*ampRide,\buf,buffer1
			]));
			});
			if (buffer2.numChannels.notNil,{
			synRide.add(Synth.head(server,"playx"++buffer2.numChannels,[
				\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixRide[i]*ampRide,\buf,buffer2
			]));
			});
		});
		synRide.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}






	
	
	setMixCS {
		arg hat,snare,kick;
		mixCS[0]=hat;
		mixCS[1]=snare;
		mixCS[2]=kick;
	}
	
	setAmpCS {
		arg amp;
		ampCS=amp;
	}
	
	playCS {
		arg velocity, amp, pan, rate, lpf, sendReverb, sendDelay, startPos;
		var triggered=false;
		// <assignSamples>
		var names=namesCS;
		var buf1,buf2,buf1Amp,buf2Amp;
		var availableVelocities=Array.fill(names.size-2,{arg i;
			(i+1)/(names.size-1)*128
		});
		availableVelocities=availableVelocities.add(128);
		availableVelocities=availableVelocities.addFirst(-1);
		buf1=availableVelocities.indexOfGreaterThan(velocity)-1;
		buf1Amp=(availableVelocities[buf1+1]-velocity)/(availableVelocities[buf1+1]-availableVelocities[buf1]);
		buf2Amp=1-buf1Amp;
		buf2=buf1+1;
		// </assignSamples>
		
		// stop all
		synCS.do({ arg syn,i;
			if (syn.isRunning,{
				syn.set(\fade_trig,1,\rate,-1);
			});
		});
		synCS=Array.new(namesMicCS.size*2);
		namesMicCS.do({ arg name,i;
			var buffer1=bufCS[i][buf1][bufCS[i][buf1].size.rand];
			var buffer2=bufCS[i][buf2][bufCS[i][buf2].size.rand];
			if (buffer2.numChannels.notNil,{
				synCS.add(Synth.head(server,"playx"++buffer1.numChannels,[
				\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf1Amp*mixCS[i]*ampCS,\buf,buffer1
			]));
			});
			if (buffer2.numChannels.notNil,{
			synCS.add(Synth.head(server,"playx"++buffer2.numChannels,[
				\t_trig,1,\startPos,startPos,\busReverb,busReverb,\sendReverb,sendReverb,\busDelay,busDelay,\sendDelay,sendDelay,\pan,pan,\rate,rate,\lpf,lpf,\amp,amp*buf2Amp*mixCS[i]*ampCS,\buf,buffer2
			]));
			});
		});
		synCS.do({ arg syn,i;
			NodeWatcher.register(syn);
		});
	}
	
	
	free {
		effects.free;
		server.sync;
		synKick.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synSnare.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synCH.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synOH.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synTom1.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synTom2.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synTom3.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synRide.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		server.sync;
		synCS.do({ arg syn,i;
			if (syn.isRunning,{
				syn.free;
			});
		});
		
		server.sync;
		bufKick.do({ arg v1,i1;
			bufKick[i1].do({ arg v2, i2;
				bufKick[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufSnare.do({ arg v1,i1;
			bufSnare[i1].do({ arg v2, i2;
				bufSnare[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufCH.do({ arg v1,i1;
			bufCH[i1].do({ arg v2, i2;
				bufCH[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufOH.do({ arg v1,i1;
			bufOH[i1].do({ arg v2, i2;
				bufOH[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufTom1.do({ arg v1,i1;
			bufTom1[i1].do({ arg v2, i2;
				bufTom1[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufTom2.do({ arg v1,i1;
			bufTom2[i1].do({ arg v2, i2;
				bufTom2[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufTom3.do({ arg v1,i1;
			bufTom3[i1].do({ arg v2, i2;
				bufTom3[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufRide.do({ arg v1,i1;
			bufRide[i1].do({ arg v2, i2;
				bufRide[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
		server.sync;
		bufCS.do({ arg v1,i1;
			bufCS[i1].do({ arg v2, i2;
				bufCS[i1][i2].do({ arg v3, i3;
					v3.free;
				});
			});
		});
	}
}




LDEffects {
	var synth;
	*new {
		arg server, busReverb,busDelay;
		^super.new.init(server, busReverb, busDelay);
	}

	init { arg server, busReverb, busDelay;

		synth = {
			arg bus,busReverb,busDelay,
			secondsPerBeat=0.125,delayBeats=4,delayFeedback=0.2;

			var snd,snd2;
			snd = In.ar(busDelay,2);
			snd = CombC.ar(
				snd,
				2,
				secondsPerBeat*delayBeats,
				secondsPerBeat*delayBeats*LinLin.kr(delayFeedback,0,1,2,128),// delayFeedback should vary between 2 and 128
			); 
			Out.ar(bus,snd);

			// reverb
			snd2 = In.ar(busReverb,2);
			snd2 = DelayN.ar(snd2, 0.03, 0.03);
			snd2 = CombN.ar(snd2, 0.1, {Rand(0.01,0.099)}!32, 4);
			snd2 = SplayAz.ar(2, snd2);
			snd2 = LPF.ar(snd2, 1500);
			5.do{snd2 = AllpassN.ar(snd2, 0.1, {Rand(0.01,0.099)}!2, 3)};
			snd2 = LPF.ar(snd2, 1500);
			snd2 = LeakDC.ar(snd2);
			Out.ar(bus,snd2);
		}.play(target:server, args:[\bus,0,\busReverb,busReverb.index,\busDelay,busDelay.index], addAction:\addToTail);
	}

	setParam {
		arg key, value;
		synth.set(key, value);
	}

	free {
		synth.free;
	}
}
