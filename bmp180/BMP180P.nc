

/*
 *	@author:Md.Jamal Mohiuddin<mjmohiuddin@cdac.in>
 */

#include "printf.h"
#include "BMP180.h"
#include "math.h"
module BMP180P
{
	
	provides {
			interface BMP180;
	}
	uses {
			interface I2C;
			interface Leds;
			interface Timer<TMilli> as WaitTimer;
	}

}


implementation
{

	int16_t ac1,ac2,ac3;
	uint16_t ac4,ac5,ac6;	
	int16_t b1,b2;
	int16_t mb,mc,md;
	uint32_t tmp;
	uint8_t buffer[3];
	
	uint32_t compensated_temperature,compensated_pressure;
	uint32_t uncompensated_temperature;
	uint32_t uncompensated_pressure;	
	
	uint8_t oversampling_select = OVERSAMPLING_ULTRA_LOW;

	uint8_t state;

	uint8_t user_state;

	bool eeprom_read = FALSE;

	uint32_t sea_level_pressure;

	error_t checkCommunication()
	{
	
		buffer[0] = CHIPID_REG;	

		call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);


		call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 1, buffer);

		if(buffer[0] == CHIPID_VALUE)
			return SUCCESS;
		return FAIL;

	}

	error_t I2Cinit()
	{
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
		return call I2C.i2cInit(msp430_i2c_sht21_config,
					BMP180_I2CSLAVE_ADDR);
	}

	uint16_t byte2Int(uint8_t msb,uint8_t lsb)
	{
		uint16_t res;	
		res = msb;
		res <<= 8;
		res |= lsb;
		return res;
	}

	/*
	 * Read the Calibration Data present in the EEPROM
	 * Every sensor module has individual coefficients
	*/


	error_t readEEPROM()
	{
		error_t error;
		error = checkCommunication();
		if(error == SUCCESS) {
		if(!eeprom_read) {
			buffer[0] = AC1;
		
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
					BMP180_I2CSLAVE_ADDR , 1 , buffer);

			call I2C.read(I2C_START | I2C_STOP,
				   BMP180_I2CSLAVE_ADDR, 2, buffer);
		
			ac1 = byte2Int(buffer[0],buffer[1]);

			//Without delay i2c is getting busy

			//for(i=0xff;i;i--);

			buffer[0] = AC2;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
			ac2 = byte2Int(buffer[0],buffer[1]);	
	
			
			//for(i=0xff;i;i--);

			buffer[0] = AC3;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
			
			ac3 = byte2Int(buffer[0],buffer[1]);
	
			//for(i=0xff;i;i--);
			
			buffer[0] = AC4;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
			
			ac4 = byte2Int(buffer[0],buffer[1]);

			//for(i=0xff;i;i--);

			buffer[0] = AC5;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			ac5 = byte2Int(buffer[0],buffer[1]);

		
			//for(i=0xff;i;i--);
				
			
			buffer[0] = AC6;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			ac6 = byte2Int(buffer[0],buffer[1]);

			//for(i=0xff;i;i--);
					
			buffer[0] = B1;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			b1 = byte2Int(buffer[0],buffer[1]);
			
			//for(i=0xff;i;i--);
		
			buffer[0] = B2;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			b2 = byte2Int(buffer[0],buffer[1]);

			//for(i=0xff;i;i--);

			buffer[0] = MB;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			mb = byte2Int(buffer[0],buffer[1]);
			
			//for(i=0xff;i;i--);

			buffer[0] = MC;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			mc = byte2Int(buffer[0],buffer[1]);
	
			//for(i=0xff;i;i--);

			buffer[0] = MD;
			
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
	
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			md = byte2Int(buffer[0],buffer[1]);
			
			eeprom_read = TRUE;
	
		}
		}
		return FAIL;

	}



	uint32_t calculateTemperature()	
	{
		int32_t B5;
		double temp;
		int32_t X1 = (uncompensated_temperature - (int32_t)ac6) * ((int32_t)ac5) >> 15;
  		int32_t X2 = ((int32_t)mc << 11) / (X1+(int32_t)md);
		B5  = X1+X2;
		temp   = (B5+8)>>4;
		compensated_temperature = temp/10;
		return compensated_temperature;

	}


	int32_t calculatePressure()
	{
		int32_t B3, B5, B6, X1, X2, X3, p;
		int32_t X_1 = (uncompensated_temperature - (int32_t)ac6) * ((int32_t)ac5) >> 15;
  		int32_t X_2 = ((int32_t)mc << 11) / (X_1+(int32_t)md);
		uint32_t B4, B7;
	
		B5  = X_1+X_2;	
		B6  = B5 - 4000;
		

		X1 = ((int32_t)b2 * ( (B6 * B6)>>12 )) >> 11;
  		X2 = ((int32_t)ac2 * B6) >> 11;
  		X3 = X1 + X2;
  		B3 = ((((int32_t)ac1*4 + X3) << oversampling_select) + 2) / 4;

		X1 = ((int32_t)ac3 * B6) >> 13;
  		X2 = ((int32_t)b1 * ((B6 * B6) >> 12)) >> 16;
  		X3 = ((X1 + X2) + 2) >> 2;
  		B4 = ((uint32_t)ac4 * (uint32_t)(X3 + 32768U)) >> 15;
  		B7 = ((uint32_t)uncompensated_pressure - B3) * 
			(uint32_t)( 50000UL >> oversampling_select );



		if (B7 < 0x80000000) {
    			p = (B7 * 2) / B4;
		} else {
		    	p = (B7 / B4) * 2;
  		}
		X1 = (p >> 8) * (p >> 8);
		X1 = (X1 * 3038) >> 16;
		X2 = (-7357 * p) >> 16;
		
		compensated_pressure = p + ((X1 + X2 + (int32_t)3791)>>4);

		compensated_pressure /= 100;

		return compensated_pressure;

	}

	void calculateAltitude()
	{
		
		uint32_t altitude;

		float calculate = (float)compensated_pressure/sea_level_pressure;


		altitude = 44330U * (1- powf(calculate,0.1903));

		printf("Altitude is %ld\n",altitude);
		printfflush();
	
		state &= ~ALTITUDE_MEASURE;

		signal BMP180.readDoneAltitude(SUCCESS,altitude);

	}


	error_t readTemperature()
	{
		/*
		 *	Write 0x2e into 0xf4 and wait 4.5ms
		 */
		error_t error;
		error = checkCommunication();
		if(error == SUCCESS) {
			buffer[0] = WRITE_REG;
			buffer[1] = TEMPERATURE_VALUE;
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 2 , buffer);

			state = TEMPERATURE_MEASURE;
			call WaitTimer.startOneShot(WAIT_PERIOD);
		}
		return error;


	}

	void readPressure()
	{
	
		/*
		 *	Write 0x34 + (oss<<6) into register 0xF4 and wait 4.5 ms
		 */

		buffer[0] = WRITE_REG;
		buffer[1] = HUMIDITY_VALUE + (oversampling_select << 6);

		call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 2 , buffer);

		state = PRESSURE_MEASURE;
		call WaitTimer.startOneShot(WAIT_PERIOD);
		
	}

	
	

	command error_t BMP180.readPressure()
	{
		error_t error;
		
		error = I2Cinit();

		//user_state = PRESSURE;

		if(error == SLAVE_PRESENT)
		{	
			/*
			*Step1 : Read the calibration Data from the EEPROM
			*(MSB First)
			*/
			readEEPROM();	
	
			/*
			 * Step 2 : Read Uncompensated Temperature value
  			 */

			readTemperature();

		}
		return error;		
	}

	command error_t BMP180.readAltitude(uint32_t sealevel_pressure)
	{
		
		sea_level_pressure = sealevel_pressure;

		user_state = ALTITUDE;

		return call BMP180.readPressure();
	}



	event void WaitTimer.fired()
	{
	
				
		buffer[0] =READ_REG;
		call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);

		if(state == TEMPERATURE_MEASURE) {
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
	
			uncompensated_temperature = ((buffer[0]<<8) | buffer[1]);	
	
			/*
			 * Step3 : Read Uncompensated Pressure Value
			 */
			calculateTemperature();
			readPressure();
		}else if(state == PRESSURE_MEASURE) {
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 2, buffer);
			uncompensated_pressure = buffer[0];
			uncompensated_pressure <<= 8;
			uncompensated_pressure |= buffer[1];
			uncompensated_pressure <<= 8;
			buffer[0] = READ_REG + 0x02; 
			call I2C.write(I2C_INIT | I2C_START | I2C_STOP,
						BMP180_I2CSLAVE_ADDR , 1 , buffer);
		
			call I2C.read(I2C_START | I2C_STOP,
					   BMP180_I2CSLAVE_ADDR, 1, buffer);
			
			uncompensated_pressure |= buffer[0];
			uncompensated_pressure >>= 8;

					

			if(!(user_state & ALTITUDE))	
			signal BMP180.readDone(SUCCESS,compensated_temperature,
							calculatePressure());	
			else{
				calculatePressure();
				calculateAltitude();
			}
		}
	}

	

}
