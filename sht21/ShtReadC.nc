
#include "printf.h"

module ShtReadC
{
	uses{
		interface Boot;
		interface Timer<TMilli>;
		interface Read<uint16_t> as ReadTemperature;
		interface Read<uint16_t> as ReadHumidity;	
	}

}


implementation
{
	char buffer[2];
	event void Boot.booted()
	{
		call Timer.startOneShot(4*1024);	//4 Sec
	}

	event void Timer.fired()
	{
		call ReadTemperature.read();
	}

	event void ReadTemperature.readDone(error_t error,uint16_t temperature)
	{
		printf("Temperature is %dC\n",temperature);
		printfflush();		
		call ReadHumidity.read();
	}


	event void ReadHumidity.readDone(error_t error,uint16_t humidity)
	{
		printf("Humidity is %d %%\n",humidity);
		printfflush();
		call Timer.startOneShot(4*1024);	//4 Sec
	}



	





}
