

/*
 *@author:Mohammad Jamal Mohiuddin <mjmohiuddin@cdac.in>
 */
#include "lc1025.h"
module LC1025P
{
	provides interface LC1025;
	
	uses{
		interface I2C;
	}
}


implementation
{

	
	uint8_t buffer[3];
	uint8_t slave_addr;

	error_t I2Cinit(){
	
		msp430_i2c_union_config_t msp430_i2c_24lc1025_config = {{
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
		
		return call I2C.i2cInit(msp430_i2c_24lc1025_config,
							slave_addr);
	}

	error_t writeByte(uint16_t address,uint8_t byte,
				bool higher_segment)
	{
		error_t error;		

		slave_addr = LC1025_I2C_LOWER_ADDR;
		if(higher_segment)
			slave_addr = LC1025_I2C_HIGHER_ADDR;
			
		error = I2Cinit();
		
		

		if(error == SLAVE_PRESENT)
		{
			//Write the Address:First MSB then LSB and data
			buffer[0] = (address>>8)&0xff;
			buffer[1] = address&0xff;
			buffer[2] = byte;
			
			error = call I2C.write(I2C_INIT | I2C_START|I2C_STOP,
				slave_addr,3,buffer);	
		}
		return error;
	}


	error_t readByte(uint16_t address,uint8_t *byte,
				bool higher_segment)
	{

		error_t error;		

		slave_addr = LC1025_I2C_LOWER_ADDR;
		if(higher_segment)
			slave_addr = LC1025_I2C_HIGHER_ADDR;
			
		error = I2Cinit();
		if(error == SLAVE_PRESENT)
		{

			buffer[0] = (address>>8)&0xff;
			buffer[1] = address&0xff;

			error = call I2C.write(I2C_INIT | I2C_START,
				slave_addr,2,buffer);

			error=	call I2C.read(I2C_START | I2C_STOP, 
					slave_addr,1, byte);

		}
		return error;
	}


	error_t writePage(uint16_t address,uint8_t *byte,
				uint8_t len,bool higher_segment)
	{

		error_t error;		

		slave_addr = LC1025_I2C_LOWER_ADDR;
		if(higher_segment)
			slave_addr = LC1025_I2C_HIGHER_ADDR;
			
		error = I2Cinit();
		if(error == SLAVE_PRESENT)
		{
			buffer[0] = (address>>8)&0xff;
			buffer[1] = address&0xff;
			
			error = call I2C.write(I2C_INIT | I2C_START,
				slave_addr,2,buffer);

			error = call I2C.write(I2C_STOP,
				slave_addr,len,byte);	
		}
		return error;
	}


	error_t readPage(uint16_t address,uint8_t *byte,
				uint8_t len,bool higher_segment)
	{

		error_t error;		

		slave_addr = LC1025_I2C_LOWER_ADDR;
		if(higher_segment)
			slave_addr = LC1025_I2C_HIGHER_ADDR;
			
		error = I2Cinit();
		if(error == SLAVE_PRESENT)
		{
			buffer[0] = (address>>8)&0xff;
			buffer[1] = address&0xff;
			
			error = call I2C.write(I2C_INIT | I2C_START,
				slave_addr,2,buffer);

			error=	call I2C.read(I2C_START | I2C_STOP, 
					slave_addr,len, byte);
		}
		return error;
	}

	command error_t LC1025.start()
	{

		error_t error;		
		error = I2Cinit();

		if(error == SLAVE_PRESENT)
		{
			
		}
		return error;

	}


	/*
	 * Arguments:
	 * address:16-bit Address to you want to write
         * byte :  one byte data you want to write to that address
	 * higher_segment : set it to TRUE when you want to access the upper 512K
         */

	command error_t LC1025.writeByte(uint16_t address,uint8_t byte,
						bool higher_segment)
	{
		return writeByte(address,byte,higher_segment);
	}


	/*
	 * Arguments:
	 * address:16-bit Address to you want to write
         * byte :  Pointer to the page
	 * len  : Number of bytes you want to write
	 * higher_segment : set it to TRUE when you want to access the upper 512K
         */	


	command error_t LC1025.writePage(uint16_t address,uint8_t *byte,
					uint8_t len,bool higher_segment)
	{
		if(len > MAX_PAGE_LEN)
			return FAIL;
		return writePage(address,byte,len,higher_segment);
					
	}



	/*
	 * Arguments:
	 * address:16-bit Address to you want to write
         * byte :  pointer to store one byte data you  read from that address
	 * higher_segment : set it to TRUE when you want to access the upper 512K
         */

	command error_t LC1025.readByte(uint16_t address,uint8_t *byte,
					bool higher_segment)
	{
		return readByte(address,byte,higher_segment);		
	}


	/*
	 * Arguments:
	 * address:16-bit Address to you want to write
         * byte :  pointer to store data you read from that address 
	 * higher_segment : set it to TRUE when you want to access the upper 512K
         */

	command error_t LC1025.readPage(uint16_t address,uint8_t *byte,
					uint8_t len,bool higher_segment)
	{
		if(len > MAX_PAGE_LEN)
			return FAIL;

		return readPage(address,byte,len,higher_segment);

	}




}
