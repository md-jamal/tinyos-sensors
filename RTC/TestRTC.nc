
#include "printf.h"
#include "rtc.h"


module TestRTC
{
	uses {
		interface Boot;
		interface RTC;
		interface Timer<TMilli> as ReadTimer;
	}


}


implementation
{
	event void Boot.booted()
	{
		struct rtc rtc_data;
		//26TH December 2014,11:50:00	
		call RTC.start();
		SET_RTC(rtc_data,26,DECEMBER,14,FRIDAY,14,0,0);
		call ReadTimer.startPeriodic(10*1024U);
	}

	event void ReadTimer.fired()
	{
		struct rtc rtc_reading;
		call RTC.get(&rtc_reading);

		printf("RTC Reading:%d:%s:%d:%s:%d:%d:%d\n",rtc_reading.date,
				getMonth(rtc_reading.month),rtc_reading.year,
				getDay(rtc_reading.day),rtc_reading.hour,
				rtc_reading.min,rtc_reading.sec);
		printfflush();	


	}

}
