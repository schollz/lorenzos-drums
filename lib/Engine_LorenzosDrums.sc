Engine_LorenzosDrums : CroneEngine {

	var lorenzosDrums;

	alloc { 

		this.addCommand("init","", { arg msg;
			lorenzosDrums=LorenzosDrums.new(Server.default,"/home/we/dust/audio/lorenzos-drums/");
		});

		this.addCommand("bd", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playKick(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});

		this.addCommand("bd_mix", "fff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixKick(msg[1],msg[2],msg[3]);
			});
		});

		this.addCommand("bd_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpKick(msg[1]);
			});
		});

		this.addCommand("sd", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playSnare(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});

		this.addCommand("sd_mix", "fff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixSnare(msg[1],msg[2],msg[3]);
			});
		});

		this.addCommand("sd_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpSnare(msg[1]);
			});
		});

		this.addCommand("cs", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playCS(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});

		this.addCommand("cs_mix", "fff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixCS(msg[1],msg[2],msg[3]);
			});
		});

		this.addCommand("cs_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpCS(msg[1]);
			});
		});

		this.addCommand("rc", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playRide(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});
		
		this.addCommand("oh", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playOH(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});
		this.addCommand("ch", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playCH(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});
		this.addCommand("tom1", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playTom1(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});
		this.addCommand("tom2", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playTom2(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});
		this.addCommand("tom3", "fffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playTom3(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7]);
			});
		});

		this.addCommand("fx","sf",{ arg msg;
			if (lorenzosDrums.notNil,{ 
				lorenzosDrums.setFxParam(msg[1].asSymbol,msg[2]);
			});
		});

	}

	free {
		lorenzosDrums.free;
		Buffer.freeAll(Server.default);
	}

}