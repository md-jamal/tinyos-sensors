#include "tls2671.h"

module TLS2671P
{
	provides{
		interface TLS2671;
	}
	uses{
		interface I2C;
		interface Leds;		
	}


}


implementation
{
	
	uint8_t buffer[2];


	error_t I2Cinit(){
	
		msp430_i2c_union_config_t msp430_i2c_tls2671_config = {{
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
		
		return call I2C.i2cInit(msp430_i2c_tls2671_config,
							TLS2671_I2C_ADDR);
	}


	error_t writeRegister(uint8_t reg,uint8_t value)
	{
		error_t error;		
		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			buffer[0]	= COMMAND_VALUE | reg;	
			error = call I2C.write(I2C_INIT | I2C_START,
				TLS2671_I2C_ADDR,1,buffer);	

			buffer[0] 	= value;

			error = call I2C.write(I2C_START |I2C_STOP,
				TLS2671_I2C_ADDR,1,buffer);	
	
			

		}	

		return error;


	}
	
	
	command error_t TLS2671.registerSetup()
	{

		error_t error;
		//Setting each register to default value
		error = writeRegister(ENABLE_REG,ENABLE_DEFAULT);
		error = writeRegister(PROXIMITY_TIME_REG,PROXIMITY_TIME_DEFAULT);
		error = writeRegister(WAIT_TIME_REG,WAIT_TIME_DEFAULT);
		error = writeRegister(PROXIMITY_CNT_REG,PROXIMITY_CNT_DEF);
		error = writeRegister(CONTROL_REG,CONTROL_DEFAULT);
		return error;

	}


	

	command error_t TLS2671.get()
	{
		
		error_t error;

		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			call Leds.led0Toggle();	
		}

		return SUCCESS;
	}


	command int8_t TLS2671.readRegister(uint8_t reg,uint8_t *value)
	{
		error_t error;

		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			buffer[0]	=  COMMAND_VALUE | reg;
			error	=      call I2C.write(I2C_INIT | I2C_START |I2C_STOP,
					TLS2671_I2C_ADDR,1,buffer);
			error=		call I2C.read(I2C_START | I2C_STOP, 
					TLS2671_I2C_ADDR,1, buffer);
			if(error == SUCCESS)
				*value = buffer[0];
			return error;
		}else
			return -1;
	}

	command error_t TLS2671.enablePower()
	{
		
		error_t error;
		volatile uint32_t i;
		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			error = call TLS2671.registerSetup();
			writeRegister(ENABLE_REG,(POWER_ON|PROXIMITY_ENABLE));
			for(i=0x61a8;i;i--);	//delay 2.5ms
			

		}	

		return error;
	}



}
