

configuration BMPReadAppC
{



}


implementation
{

	components MainC,BMPReadC;
	BMPReadC.Boot	-> 	MainC;

	components new TimerMilliC() as Timer;
	BMPReadC.Timer	->	Timer;

	components LedsC;
	BMPReadC.Leds	->	LedsC;
	

	components BMP180C;
	BMPReadC.BMP180  ->	BMP180C;
	

	components PrintfC,SerialStartC;

}
