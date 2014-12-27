

/*
 *@author:Mohammad Jamal Mohiuddin <mjmohiuddin@cdac.in>
 */

#include "rtc.h"

module RTCP
{
	provides{
		interface RTC;
	}uses{
		interface I2C;
		interface Leds;
	}
}

implementation
{
	
	uint8_t buffer[2];
	
	error_t I2Cinit(){
	
		msp430_i2c_union_config_t msp430_i2c_rtc_config = {{
			ubr     : 72,			/* smclk/72 */
    			ucmode  : 3,			/* i2c mode */
    			ucmst   : 1,			/* master */
   			ucmm    : 0,			/* single master */
			ucsla10 : 0,			/* 7 bit slave */
			uca10   : 0,			/* 10 bit us */
			uctr    : 0,			/* tx mode to start */
			ucssel  : 2,			/* smclk */
			i2coa   : 1,			/* our address is 1 */
			ucgcen  : 0,			/* respond to general call */
		}};
		
		return call I2C.i2cInit(msp430_i2c_rtc_config,
							RTC_SLAVE_ADDR);
	}

	error_t writeRegister(uint8_t reg,uint8_t value)
	{
		error_t error;		
		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{	
			buffer[0] = reg;
			buffer[1] = value;
			error = call I2C.write(I2C_INIT | I2C_START| I2C_STOP,
				RTC_SLAVE_ADDR,2,buffer);
		}
		return error;
	}

	error_t readRegister(uint8_t reg,uint8_t *value)
	{
		error_t error;		
		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			buffer[0] = reg;
			error = call I2C.write(I2C_INIT | I2C_START,
				RTC_SLAVE_ADDR,1,buffer);
			error=	call I2C.read(I2C_START | I2C_STOP, 
					RTC_SLAVE_ADDR,1, buffer);
			*value = buffer[0];
		}
		return error;
	}

	
	command error_t RTC.start()
	{
		return writeRegister(SECOND_REG,OSC_ON);
	}

	command error_t RTC.stop()
	{
		return writeRegister(SECOND_REG,OSC_OFF);
	}


	command error_t RTC.getSeconds(uint8_t *sec)
	{
		uint8_t tmp;
		error_t error =readRegister(SECOND_REG,&tmp);
		*sec  = ((tmp & TEN_SEC_MASK) >> TEN_SEC_SHIFT ) * 10;
		*sec += (tmp & ONE_SEC_MASK); 
		return error;
	}


	command error_t RTC.getMinutes(uint8_t *min)
	{
		uint8_t tmp;
		error_t error = readRegister(MINUTE_REG,&tmp);
		*min  = ((tmp & TEN_MIN_MASK) >> TEN_MIN_SHIFT) * 10;
		*min += (tmp & ONE_MIN_MASK); 
		return error;
	}


	command error_t RTC.getHours(uint8_t *hour)
	{
		uint8_t tmp;
		error_t error = readRegister(HOUR_REG,&tmp);
		*hour  = ((tmp & TEN_HOUR_MASK) >> TEN_HOUR_SHIFT) * 10;
		*hour += (tmp & ONE_HOUR_MASK); 
		return error;
	}


	command error_t RTC.getDay(uint8_t *day)
	{
		uint8_t tmp;
		error_t error = readRegister(DAY_REG,&tmp);
		*day  = tmp & DAY_MASK;
		return error;
	}


	command error_t RTC.getDate(uint8_t *date)
	{
		uint8_t tmp;
		error_t error =  readRegister(DATE_REG,&tmp);
		*date  = ((tmp & TEN_DATE_MASK) >> TEN_DATE_SHIFT) * 10;
		*date += (tmp & ONE_DATE_MASK);
		return error;
	}

	command error_t RTC.getMonth(uint8_t *month)
	{
		uint8_t tmp;
		error_t error =  readRegister(MONTH_REG,&tmp);
		*month  = ((tmp & TEN_MONTH_MASK) >> TEN_MONTH_SHIFT) * 10;
		*month += (tmp & ONE_MONTH_MASK);
		return error;
	}


	command error_t RTC.getYear(uint8_t *year)
	{
		uint8_t tmp;
		error_t error =  readRegister(YEAR_REG,&tmp);
		*year  = ((tmp & TEN_YEAR_MASK) >> TEN_YEAR_SHIFT)* 10;
		*year += (tmp & ONE_YEAR_MASK);
		return error;
	}


	command error_t RTC.get(struct rtc *data)
	{
		error_t error;
		error =  call RTC.getSeconds(&data->sec);
		error |= call RTC.getMinutes(&data->min);
		error |= call RTC.getHours(&data->hour);
		error |= call RTC.getDay(&data->day);
		error |= call RTC.getDate(&data->date);
		error |= call RTC.getMonth(&data->month);
		error |= call RTC.getYear(&data->year);
		return error;	
	}


	command error_t RTC.setSeconds(uint8_t sec)
	{
		uint8_t ONE_SEC = sec%10;
		uint8_t TEN_SEC = sec/10;
		uint8_t value = TEN_SEC << TEN_SEC_SHIFT;
		value |= ONE_SEC;
		return writeRegister(SECOND_REG,value);
	}


	command error_t RTC.setMinutes(uint8_t min)
	{
		uint8_t ONE_MIN = min%10;
		uint8_t TEN_MIN = min/10;
		uint8_t value = TEN_MIN << TEN_MIN_SHIFT;
		value |= ONE_MIN;
		return writeRegister(MINUTE_REG,value);
	}	


	command error_t RTC.setHours(uint8_t hour)
	{
		uint8_t ONE_HOUR = hour%10;
		uint8_t TEN_HOUR = hour/10;
		uint8_t value = TEN_HOUR << TEN_HOUR_SHIFT;
		value |= ONE_HOUR;
		return writeRegister(HOUR_REG,value);
	}


	command error_t RTC.setDay(uint8_t day)
	{
		return writeRegister(DAY_REG,day);
	}

	command error_t RTC.setDate(uint8_t date)
	{
		uint8_t ONE_DATE = date%10;
		uint8_t TEN_DATE = date/10;
		uint8_t value = TEN_DATE << TEN_DATE_SHIFT;
		value |= ONE_DATE;
		return writeRegister(DATE_REG,value);
	}


	command error_t RTC.setMonth(uint8_t month)
	{
		uint8_t ONE_MONTH = month%10;
		uint8_t TEN_MONTH = month/10;
		uint8_t value = TEN_MONTH << TEN_MONTH_SHIFT;
		value |= ONE_MONTH;
		return writeRegister(MONTH_REG,value);
	}


	command error_t RTC.setYear(uint8_t year)
	{
		uint8_t ONE_YEAR = year%10;
		uint8_t TEN_YEAR = year/10;
		uint8_t value = TEN_YEAR << TEN_YEAR_SHIFT;
		value |= ONE_YEAR;
		return writeRegister(YEAR_REG,value);
	}



	command error_t RTC.set(struct rtc *data)
	{
		error_t error;
		error =  call RTC.setSeconds(data->sec);
		error |= call RTC.setMinutes(data->min);
		error |= call RTC.setHours(data->hour);
		error |= call RTC.setDay(data->day);
		error |= call RTC.setDate(data->date);
		error |= call RTC.setMonth(data->month);
		error |= call RTC.setYear(data->year);
		return error;	
	}

	


}

