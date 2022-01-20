Engine_LorenzosDrums : CroneEngine {

	var lorenzosDrums;

	alloc { 

		this.addCommand("init","", { arg msg;
			lorenzosDrums=LorenzosDrums.new(Server.default,"/home/we/dust/audio/lorenzos-drums/");
		});


		this.addCommand("bd", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playKick(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
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


		this.addCommand("sd", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playSnare(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
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


		this.addCommand("cs", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playCS(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
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


		this.addCommand("rc", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playRide(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
			});
		});

		this.addCommand("rc_mix", "fff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixRide(msg[1],msg[2],msg[3]);
			});
		});

		this.addCommand("rc_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpRide(msg[1]);
			});
		});
		

		this.addCommand("oh", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playOH(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
			});
		});

		this.addCommand("oh_mix", "ff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixOH(msg[1],msg[2]);
			});
		});

		this.addCommand("oh_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpOH(msg[1]);
			});
		});


		this.addCommand("ch", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playCH(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
			});
		});

		this.addCommand("ch_mix", "ff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixCH(msg[1],msg[2]);
			});
		});

		this.addCommand("ch_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpCH(msg[1]);
			});
		});


		this.addCommand("tom1", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playTom1(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
			});
		});

		this.addCommand("tom1_mix", "ff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixTom1(msg[1],msg[2]);
			});
		});

		this.addCommand("tom1_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpTom1(msg[1]);
			});
		});


		this.addCommand("tom2", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playTom2(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
			});
		});

		this.addCommand("tom2_mix", "ff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixTom2(msg[1],msg[2]);
			});
		});

		this.addCommand("tom2_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpTom2(msg[1]);
			});
		});


		this.addCommand("tom3", "ffffffff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.playTom3(msg[1],msg[2],msg[3],msg[4],msg[5],msg[6],msg[7],msg[8]);
			});
		});

		this.addCommand("tom3_mix", "ff", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setMixTom3(msg[1],msg[2]);
			});
		});

		this.addCommand("tom3_amp", "f", { arg msg;
			if (lorenzosDrums.notNil,{
				lorenzosDrums.setAmpTom3(msg[1]);
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