
#include "printf.h"

module BMPReadC
{
	
	uses{
		interface Boot;
		interface Timer<TMilli> as Timer;
		interface BMP180;
		interface Leds;
	}


}


implementation
{
	event void Boot.booted()
	{
		call Timer.startPeriodic(4096);
	}

	event void Timer.fired()
	{
		if(call BMP180.readAltitude(1013) != SUCCESS) {
			call Leds.led0On();
			call Leds.led1On();
			call Leds.led2On();
		}
	}
	

	event void BMP180.readDone(error_t error,uint16_t temperature,
					uint16_t pressure)
	{
		printf("Temperature is %dC\n",temperature);
		printf("Pressure is %dhpa\n",pressure);
		printfflush();
	}

	event void BMP180.readDoneAltitude(error_t error,uint32_t altitude)
	{
		printf("Altitude is %ld metres\n",altitude);
		printfflush();		
	}

}
