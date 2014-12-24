

configuration TSLReadAppC
{


}


implementation
{

	components TSLReadC,MainC;	
	TSLReadC.Boot	->	MainC;

	components TSL2561C;
	TSLReadC.TSL2561	->	TSL2561C;

	components new TimerMilliC() as Timer;
	TSLReadC.Timer		->	Timer;


	components PrintfC,SerialStartC;

}
