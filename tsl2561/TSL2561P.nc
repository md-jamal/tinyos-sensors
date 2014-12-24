
/*
 * @author : Md.Jamal Mohiuddin<mjmohiuddin@cdac.in>
 */


#include "tsl2561.h"

module TSL2561P
{
	provides{
		interface TSL2561;
	}
	uses{
		interface I2C;
		interface Leds;		
	}


}


implementation
{
	
	uint8_t buffer[2];

	void delay_14ms()
	{
		volatile uint16_t x;
		
		for(x=14000;x;x--);

	}

	uint32_t calculateLux(uint16_t ch0,uint16_t ch1)
	{
		unsigned long chScale;
  		unsigned long channel1,channel0;
		unsigned long ratio1,ratio;
		unsigned int b, m;
		unsigned long temp;
		uint32_t lux;
		chScale = TSL2561_LUX_CHSCALE_TINT0;	//As integration time is 13ms
		
		 // scale the channel values
  		channel0 = (ch0 * chScale) >> TSL2561_LUX_CHSCALE;
  		channel1 = (ch1 * chScale) >> TSL2561_LUX_CHSCALE;

		// find the ratio of the channel values (Channel1/Channel0)
		ratio1 = 0;
		if (channel0 != 0) ratio1 = (channel1 << (TSL2561_LUX_RATIOSCALE+1))
						 / channel0;

		 // round the ratio value
  		ratio = (ratio1 + 1) >> 1;

		#ifdef TSL2561_PACKAGE_CS
 		if ((ratio >= 0) && (ratio <= TSL2561_LUX_K1C))
		    {b=TSL2561_LUX_B1C; m=TSL2561_LUX_M1C;}
		else if (ratio <= TSL2561_LUX_K2C)
		    {b=TSL2561_LUX_B2C; m=TSL2561_LUX_M2C;}
		else if (ratio <= TSL2561_LUX_K3C)
		    {b=TSL2561_LUX_B3C; m=TSL2561_LUX_M3C;}
		else if (ratio <= TSL2561_LUX_K4C)
		    {b=TSL2561_LUX_B4C; m=TSL2561_LUX_M4C;}
		else if (ratio <= TSL2561_LUX_K5C)
		    {b=TSL2561_LUX_B5C; m=TSL2561_LUX_M5C;}
		else if (ratio <= TSL2561_LUX_K6C)
		    {b=TSL2561_LUX_B6C; m=TSL2561_LUX_M6C;}
		else if (ratio <= TSL2561_LUX_K7C)
		    {b=TSL2561_LUX_B7C; m=TSL2561_LUX_M7C;}
		else if (ratio > TSL2561_LUX_K8C)
		    {b=TSL2561_LUX_B8C; m=TSL2561_LUX_M8C;}
		#else
		if ((ratio >= 0) && (ratio <= TSL2561_LUX_K1T))
		    {b=TSL2561_LUX_B1T; m=TSL2561_LUX_M1T;}
		else if (ratio <= TSL2561_LUX_K2T)
		    {b=TSL2561_LUX_B2T; m=TSL2561_LUX_M2T;}
		else if (ratio <= TSL2561_LUX_K3T)
		    {b=TSL2561_LUX_B3T; m=TSL2561_LUX_M3T;}
		else if (ratio <= TSL2561_LUX_K4T)
		    {b=TSL2561_LUX_B4T; m=TSL2561_LUX_M4T;}
		else if (ratio <= TSL2561_LUX_K5T)
		    {b=TSL2561_LUX_B5T; m=TSL2561_LUX_M5T;}
		else if (ratio <= TSL2561_LUX_K6T)
		    {b=TSL2561_LUX_B6T; m=TSL2561_LUX_M6T;}
		else if (ratio <= TSL2561_LUX_K7T)
		    {b=TSL2561_LUX_B7T; m=TSL2561_LUX_M7T;}
		else if (ratio > TSL2561_LUX_K8T)
		    {b=TSL2561_LUX_B8T; m=TSL2561_LUX_M8T;}
		#endif


		 temp = ((channel0 * b) - (channel1 * m));
  		 // do not allow negative lux value
		 if (temp < 0) temp = 0;
		
		// round lsb (2^(LUX_SCALE-1))
  		temp += (1 << (TSL2561_LUX_LUXSCALE-1));

		 // strip off fractional portion
		lux = temp >> TSL2561_LUX_LUXSCALE;

		return lux;

	}


	error_t I2Cinit(){
	
		msp430_i2c_union_config_t msp430_i2c_tsl2561_config = {{
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
		
		return call I2C.i2cInit(msp430_i2c_tsl2561_config,
							TSL2561_I2C_ADDR);
	}


	error_t writeRegister(uint8_t reg,uint8_t value)
	{
		error_t error;		
		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			buffer[0]	= COMMAND_VALUE | reg;	
			error = call I2C.write(I2C_INIT | I2C_START,
				TSL2561_I2C_ADDR,1,buffer);	

			buffer[0] 	= value;

			error = call I2C.write(I2C_START |I2C_STOP,
				TSL2561_I2C_ADDR,1,buffer);	
		}	

		return error;
	}
	
	


	command error_t TSL2561.getLux(uint32_t *lux)
	{
		
		error_t error;
		uint16_t low_data_val,high_data_val;//low_data_val=channel0
						      //high_data_val = channel1
		uint32_t full_value;
		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			error=call TSL2561.readDataRegisters(&low_data_val,
								&high_data_val);
	
			full_value = high_data_val;
			full_value <<= 16;

			full_value  |= low_data_val;
	
			if(error == SUCCESS)
			{
				*lux = calculateLux(full_value,high_data_val);
			}
		}

		return error;
	}


	command error_t TSL2561.enablePower()
	{
		
		error_t error;

		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			error = writeRegister(CONTROL_REG,POWER_ON);
		}

		return error;

	}


	command error_t TSL2561.readDataRegisters(uint16_t *ir_value,
							uint16_t *fullspectrum_value)
	{

		error_t error;

		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{

			//Enable the device
			error 		= call 	TSL2561.enablePower();
			//requires a delay of 14ms
			delay_14ms();
			
			buffer[0]	=  COMMAND_VALUE | DATA0_LOW_REG | READ_WORD;
			error	=      call I2C.write(I2C_INIT | I2C_START |I2C_STOP,
					TSL2561_I2C_ADDR,1,buffer);

			error=		call I2C.read(I2C_START | I2C_STOP, 
					TSL2561_I2C_ADDR,2, buffer);

			*ir_value = 256*buffer[1]+ buffer[0];
		

			
			buffer[0]	=  COMMAND_VALUE | DATA0_LOW_REG | READ_WORD;
			error	=      call I2C.write(I2C_INIT | I2C_START |I2C_STOP,
					TSL2561_I2C_ADDR,1,buffer);

			error=		call I2C.read(I2C_START | I2C_STOP, 
					TSL2561_I2C_ADDR,2, buffer);

			*fullspectrum_value = 256*buffer[1]+ buffer[0];


		}

		return error;		
	}


	command error_t TSL2561.disablePower()
	{
	
		error_t error;

		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			error = writeRegister(CONTROL_REG,POWER_OFF);
		}

		return error;	
		
	
	}


}
