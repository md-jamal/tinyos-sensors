

configuration ShtReadAppC
{


}


implementation
{

	components MainC,ShtReadC;
	ShtReadC.Boot	->	MainC;

	components new TimerMilliC() as Timer;
	ShtReadC.Timer	->	Timer;

	components SHT21C;
	ShtReadC.ReadTemperature	->	SHT21C.ReadTemperature;
	ShtReadC.ReadHumidity		->	SHT21C.ReadHumidity;



	components PrintfC,SerialStartC;
}
