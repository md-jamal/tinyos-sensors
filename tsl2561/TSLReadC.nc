
/*
 * @author : Md.Jamal Mohiuddin<mjmohiuddin@cdac.in>
 */


#include "printf.h"
#include "tsl2561.h"

module TSLReadC
{
	uses{
		interface Boot;
		interface TSL2561;
		interface Timer<TMilli> as Timer;
	}


}

implementation
{

	event void Boot.booted()
	{
		printf("Booted\n");
		call Timer.startPeriodic(4*1024);
		call TSL2561.enablePower();
	}


	event void Timer.fired()
	{
		uint16_t low,high;
		uint32_t lux;
		error_t ret=call TSL2561.readDataRegisters(&low,&high);
		ret = call TSL2561.getLux(&lux);
		printf("Lux:%lu Lumens\n",lux);
		printfflush();
	}


}
