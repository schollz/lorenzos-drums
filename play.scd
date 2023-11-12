(
s.waitForBoot({
	l = LorenzosDrums(Server.default,"/home/zns/Documents/lorenzos-drums/lorenzos-drums");
	x=Routine {
		var bpm = 188;
		1.sleep;
		inf.do({ arg i;
			i = i.mod(96*3);
			if (10.rand==0,{
				i = i+96;
				bpm=bpm+((5.rand-2)/10);
			});
			i.postln;
			// kick
			if ((i.mod(16)==0)&&(100.rand<70),{
				l.playKick(80+40.rand,1,0,1,20000,0,0,0,1,0);
			});
			if (i.mod(38)==0,{
				l.playKick(40+60.rand,1,0,1,20000,0,0,0,1,0);
			});
			if ((10.rand==0)&&(i.mod(30)==0),{
				l.playKick(30+30.rand,1,0,1,20000,0,0,0,1,0);
			});
			if ((10.rand>7)&&(i.mod(8)==0),{
				l.playKick(90+30.rand,1,0,1,20000,0,0,0,1,0);
			});
			// snare
			if ((i.mod(24)==0)&&(3.rand==0),{
				l.playSnare(20+100.rand,2,0,1,20000,0.1,0.2,0);
			});

			if (i.mod(96)==0,{
				l.playSnare(20+100.rand,1,0,1,20000,0,0,0);
			});

			if (i.mod(94)==0,{
				l.playSnare(60+20.rand,1,0,1,20000,0,0,0);
			});

			if (i.mod(92)==0,{
				l.playSnare(60+10.rand,1,0,1,20000,0,0,0);
			});

			if (i.mod(90)==0,{
				l.playSnare(50+20.rand,1,0,1,20000,0,0,0);
			});

			if (i.mod(88)==0,{
				l.playSnare(40+20.rand,1,0,1,20000,0,0,0);
			});

			if (i.mod(86)==0,{
				l.playSnare(40+10.rand,1,0,1,20000,0,0,0);
			});


			if ((i.mod(16)==0)&&(3.rand==0),{
				l.playSnare(40+80.rand,1,0,1,20000,0,0,0);
			});
			if ((i.mod(44)==0)&&(3.rand==0),{
				l.playSnare(20+80.rand,1,0,1,20000,0,0,0);
			});
			if (i.mod(44)==0,{
				l.playSnare(30+40.rand,1,0,1,20000,0,0,0);
			});
			if (i.mod((24+2)*3)==0,{
				l.playSnare(30+40.rand,2.rand,0,1,20000,0,0,0);
			});
			// ride
			if ((i.mod(8)==0)&&(30.rand>1),{
				l.playRide(60+60.rand,1,0,1,20000,0,0,0);
			});
			if ((i.mod(30)==0)&&(30.rand==0),{
				l.playRide(100+20.rand,1,0,1,20000,0,0,0);
			});
			// ch
			if (i.mod(24)==0,{
				l.playCH(60+60.rand,1,0,1,20000,0,0,0);
			});
			if (i.mod(4)==0,{
				l.playCH(100+20.rand,4.rand,0,1,20000,0,0,0);
			});
			// oh
			if (i.mod(60)==0,{
				l.playOH(60+60.rand,1,0,1,20000,0,0,0);
			});

			(60/bpm/16).sleep;
		});
	}.play;
});
)
x.stop
l.playRide(120,1,0,1,20000,0,0,0)
l.playOH(120,1,0,1,20000,0,0,0)
l.playCH(120,4,0,1,20000,0,0,0);


l.setMixSnare((20.rand)/100,0.1,(50+50.rand)/100);


l.playRide(120,1,0,1,20000,0,0,0);

l.playKick(120,1,0,1,20000,0,0,0,1,0);
l.setMixKick(0,0.5,0.2);
l.setMixRide(1,1,1);
l.setMixSnare(0.25,0.5,0)
l.playKick(120,1,0,1,20000,0,0,0);
l.playOH(120,1,0,1,20000,0,0,0)
l.playCH(120,1,0,1,20000,0,0,0);
// start the sequence
(

)

l.playRide(80+40.rand,1,0,1,20000,0,0,0);

// stop the sequence
(
x.stop
)
