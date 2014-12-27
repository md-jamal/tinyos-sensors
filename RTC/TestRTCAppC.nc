

configuration TestRTCAppC
{


}

implementation
{

	components TestRTC,MainC;
	TestRTC.Boot	  -> MainC;

	components RTCC;
	TestRTC.RTC	  -> RTCC;

	components new TimerMilliC() as ReadTimer;
	TestRTC.ReadTimer -> ReadTimer;

	components PrintfC,SerialStartC;	

}
