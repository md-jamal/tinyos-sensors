#include "printf.h"
#include "sht21.h"
#include "msp430usci.h"
#include <I2C.h>
module SHT21P @safe() {
  provides {
    interface Read<uint16_t> as ReadTemperature;
    interface Read<uint16_t> as ReadHumidity;
  }
  uses {
    interface I2C;
    interface Timer<TMilli> as WaitTimer;
  }
}
implementation {
	
	uint8_t buffer[2]={0,0};
	uint16_t result;
	uint16_t temperature,humidity;
	uint8_t state ;

	enum {
		TEMPERATURE,
		HUMIDITY,
	};

	task void signalDone()
	{
		result = buffer[0]<<8|buffer[1];
		if(state == TEMPERATURE) 
		{
			temperature = -46.85+0.002681*result;			
			signal ReadTemperature.readDone(SUCCESS,temperature);
		}
		else if(state == HUMIDITY)
		{
			humidity = -6 + 0.00190 * result;			
			signal ReadHumidity.readDone(SUCCESS,humidity);
		}
	}

	void I2Cinit(){
		msp430_i2c_union_config_t msp430_i2c_sht21_config = {{
			ubr     : 72,			/* smclk/72 */
    			ucmode  : 3,			/* i2c mode */
    			ucmst   : 1,			/* master */
   			ucmm    : 0,			/* single master */
			ucsla10 : 0,			/* 7 bit slave */
			uca10   : 0,			/* 10 bit us */
			uctr    : 0,			/* tx mode to start */
			ucssel  : 2,			/* smclk */
			i2coa   : 1,			/* our address is 1 */
			ucgcen  : 1,			/* respond to general call */
		}};
		call I2C.i2cInit(msp430_i2c_sht21_config);
	}
	



	command error_t ReadTemperature.read()
	{
		buffer[0] = SHT21_TEMP;
		state	  = TEMPERATURE;		

		I2Cinit();	    

		call I2C.write(I2C_START | I2C_STOP,SHT21_I2CSLAVEADDR,
				1,buffer);	      	
		
		call WaitTimer.startOneShot(SHT21_WAIT);

		return SUCCESS;
	}


	command error_t ReadHumidity.read()
	{
		buffer[0] = SHT21_HUMID;
		state	  = HUMIDITY;

		I2Cinit();	    
		call I2C.write(I2C_START | I2C_STOP,SHT21_I2CSLAVEADDR,
				1,buffer);	      	
		
		call WaitTimer.startOneShot(SHT21_WAIT);
		return SUCCESS;
	}


	event void WaitTimer.fired()
	{
		call I2C.read(I2C_START | I2C_STOP, SHT21_I2CSLAVEADDR,
				    2, buffer);
		post signalDone();
	}

	

}
