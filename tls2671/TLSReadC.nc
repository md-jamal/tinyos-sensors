
#include "printf.h"
#include "tls2671.h"

module TLSReadC
{
	uses{
		interface Boot;
		interface TLS2671;
		interface Timer<TMilli> as Timer;
	}


}

implementation
{

	event void Boot.booted()
	{
		printf("Booted\n");
		call Timer.startPeriodic(4*1024);
		call TLS2671.enablePower();
		printfflush();
	}


	event void Timer.fired()
	{
		uint8_t value;
		printf("ret:%d\n",call TLS2671.readRegister(PROXIMITY_DATA_LOW,
								&value));
		printf("DATA_LOW:%x\n",value);
		printf("ret:%d\n",call TLS2671.readRegister(PROXIMITY_DATA_HIGH,
								&value));
		printf("DATA_HIGH:%x\n",value);
		printfflush();
	}


}
