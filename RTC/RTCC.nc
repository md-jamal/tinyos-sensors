

/*
 *@author:Mohammad Jamal Mohiuddin <mjmohiuddin@cdac.in>
 */


configuration RTCC
{
	provides interface RTC;
}

implementation
{

	components RTCP;
	RTC	=	RTCP;
	
	components MSP430I2CP,HplMsp430UsciB0C;
	RTCP.I2C	      -> MSP430I2CP;
	MSP430I2CP.UsciB      -> HplMsp430UsciB0C;
	MSP430I2CP.Interrupts -> HplMsp430UsciB0C;

	components LedsC;
	RTCP.Leds	      -> LedsC;

}





