

configuration TLSReadAppC
{


}


implementation
{

	components TLSReadC,MainC;	
	TLSReadC.Boot	->	MainC;

	components TLS2671C;
	TLSReadC.TLS2671	->	TLS2671C;

	components new TimerMilliC() as Timer;
	TLSReadC.Timer		->	Timer;


	components PrintfC,SerialStartC;

}
