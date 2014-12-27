

#ifndef RTC_DRIVER_H
#define RTC_DRIVER_H


enum{
	RTC_SLAVE_ADDR = 0x68,
	OSC_ON	       = 0x00,
	OSC_OFF	       = 0x80,
	ONE_SEC_MASK   = 0x0f,
	TEN_SEC_MASK   = 0x70,
	TEN_SEC_SHIFT  = 4,
	ONE_MIN_MASK   = 0x0f,
	TEN_MIN_MASK   = 0x70,
	TEN_MIN_SHIFT  = 4,
	ONE_HOUR_MASK  = 0x0f,
	TEN_HOUR_MASK  = 0x30,
	TEN_HOUR_SHIFT = 4,
	DAY_MASK       = 0x07,
	ONE_DATE_MASK  = 0x0f,
	TEN_DATE_MASK  = 0x30, 
	TEN_DATE_SHIFT = 4,
	ONE_MONTH_MASK = 0x0f,
	TEN_MONTH_MASK = 0x10,
	TEN_MONTH_SHIFT= 4, 
	ONE_YEAR_MASK  = 0x0f,
	TEN_YEAR_MASK  = 0xf0,	
	TEN_YEAR_SHIFT = 4,	
};

//Registers

enum{
	SECOND_REG		= 0x00,
	MINUTE_REG		= 0x01,
	HOUR_REG		= 0x02,
	DAY_REG			= 0x03,
	DATE_REG		= 0x04,
	MONTH_REG		= 0x05,
	YEAR_REG		= 0x06,
	CONFIG1_REG		= 0x07,
	TRICKLE_REG		= 0x08,
	CONFIG2_REG		= 0x09,	
};


//Special Function Registers

enum{
	SPECIAL_FUNC_KEY1	= 0x20,
	SPECIAL_FUNC_KEY2	= 0x21,
	SPECIAL_FUNC_REG	= 0x22,
};

//Days
enum{
	SUNDAY			= 0x01,
	MONDAY			= 0x02,
	TUESDAY			= 0x03,
	WEDNESDAY		= 0x04,
	THURSDAY		= 0x05,
	FRIDAY			= 0x06,
	SATURDAY		= 0x07,
};
//Months

enum{
	JANUARY			= 0x00,
	FEBRUARY		= 0x01,
	MARCH			= 0x02,
	APRIL			= 0x03,
	MAY			= 0x04,
	JUNE			= 0x05,
	JULY			= 0x06,
	AUGUST			= 0x07,
	SEPTEMBER		= 0x08,
	OCTOBER			= 0x09,
	NOVEMBER		= 0x0a,
	DECEMBER		= 0x0b,
};


//rtc structure

struct rtc {
	uint8_t sec;
	uint8_t min;
	uint8_t hour;
	uint8_t day;
	uint8_t date;
	uint8_t month;
	uint8_t year;
};

inline char * getMonth(uint8_t month)
{
	switch(month) {
		
		case 0:  return "JANUARY";
		case 1:  return "FEBRUARY";
		case 2:  return "MARCH";
		case 3:  return "APRIL";
		case 4:  return "MAY";
		case 5:  return "JUNE";
		case 6:  return "JULY";
		case 7:  return "AUGUST";
		case 8:  return "SEPTEMBER";
		case 9:  return "OCTOBER";
		case 10: return "NOVEMBER";
		case 11: return "DECEMBER";
		default: return "UNDEF";
	}
}

inline char * getDay(uint8_t day)
{
	switch(day) {
		case 1: return "SUNDAY";
		case 2: return "MONDAY";
		case 3: return "TUESDAY";
		case 4: return "WEDNESDAY";
		case 5: return "THURSDAY";
		case 6: return "FRIDAY";
		case 7: return "SATURDAY";
		default: return "UNDEF";
	}
}



#define SET_RTC(rtc,val1,val2,val3,val4,val5,val6,val7)  do{\
	rtc.date  = val1;				  \
	rtc.month = val2;				  \
	rtc.year  = val3;				  \
	rtc.day   = val4;				  \
	rtc.hour  = val5;			 	  \
	rtc.min   = val6;				  \
	rtc.sec	  = val7;				  \
	call RTC.set(&rtc);				  \
	}while(0)


#endif
