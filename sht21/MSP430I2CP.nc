
/*
 * @author:Md.Jamal Mohiuddin<mjmohiuddin@cdac.in>
*/

#include <I2C.h>

module MSP430I2CP
{

	provides interface I2C;
	uses {
		interface HplMsp430UsciB as UsciB;	
		interface HplMsp430UsciInterrupts as Interrupts;
	}
}


implementation
{
	enum {
		TIMEOUT=1200,
	};

	msp430_i2c_union_config_t i2c_config;

	void setModeI2C()
	{
		call UsciB.setModeI2C(&i2c_config);
	}

	command void I2C.i2cInit(msp430_i2c_union_config_t config)
	{
		i2c_config  = config;
		
	}

	


	command error_t I2C.write(i2c_flags_t flags,
					unsigned char slave_address,
					uint8_t len,uint8_t *buf)
	{
		uint16_t i=0, index=0;
		setModeI2C();
		
		call UsciB.setTransmitMode();
		call UsciB.setSlaveAddress(slave_address);
		
		if(flags & I2C_START) {
			while(call UsciB.getStopBit()) {
				if(i>=TIMEOUT)
					return EBUSY;
				i++;
			}
			i=0;
			call UsciB.setTXStart();
		}		
		while(!call UsciB.isTxIntrPending()) {
			if(i>=TIMEOUT)
				return EBUSY;
			i++;
		}
		i=0;
		while(len--) {
			call UsciB.tx(buf[index++]);
			while(!call UsciB.isTxIntrPending()) {		
				if(i>=TIMEOUT)
					return EBUSY;
				i++;
			}
		}
		i=0;
		if(flags & I2C_STOP) {
			while (call UsciB.getStartBit()) {
				if(i>=TIMEOUT)
					return EBUSY;
				i++;
			}
			call UsciB.setTXStop();	
		}
		
		return SUCCESS;

	}


	command error_t I2C.read(i2c_flags_t flags,
					   uint16_t slave_address, uint8_t len, 
					   uint8_t* buffer)
	{
		uint16_t i=0, index=0;
		
		call UsciB.setReceiveMode();
		call UsciB.setSlaveAddress(slave_address);
		
		if(flags & I2C_START) {
			while(call UsciB.getStopBit()) {
				if(i>=TIMEOUT)
					return EBUSY;
				i++;
			}
			i=0;
			call UsciB.setTXStart();
		}

		while(len--) {
			while(!(call UsciB.isRxIntrPending())) {
				if(i>=TIMEOUT)
					return EBUSY;
				i++;
			}
			i=0;
			buffer[index++] = call UsciB.rx();
			call UsciB.clrRxIntr();
		}
		if(flags & I2C_STOP) {
			while (call UsciB.getStartBit()) {
				if(i>=TIMEOUT)
					return EBUSY;
				i++;
			}
			call UsciB.setTXStop();	
		}
		return SUCCESS;
	}


	async event void Interrupts.txDone(){
  
  	}

  	async event void Interrupts.rxDone(uint8_t data){
   
  	}


}
