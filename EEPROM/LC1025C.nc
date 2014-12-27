

/*
 *@author:Mohammad Jamal Mohiuddin <mjmohiuddin@cdac.in>
 */

configuration LC1025C
{
	provides interface LC1025;

}


implementation
{
	components LC1025P;

	LC1025 = LC1025P;

	components MSP430I2CP,HplMsp430UsciB0C;
	LC1025P.I2C	      -> MSP430I2CP;
	MSP430I2CP.UsciB      -> HplMsp430UsciB0C;
	MSP430I2CP.Interrupts -> HplMsp430UsciB0C;



}
