

/*
 * @author:Md.Jamal Mohiuddin<mjmohiuddin@cdac.in>
*/

#include <I2C.h>

interface I2C
{

	
	command void i2cInit(msp430_i2c_union_config_t i2c_config);


	command error_t write(i2c_flags_t flags,
					unsigned char slave_address,
					uint8_t len,uint8_t *buf);

	command error_t read(i2c_flags_t flags,
					   uint16_t addr, uint8_t len, 
					   uint8_t* buf);

}
