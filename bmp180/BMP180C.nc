

configuration BMP180C
{
	provides{
			interface BMP180;
		}

}


implementation
{

	components BMP180P;
	BMP180  =  BMP180P;

	components LedsC;
	BMP180P.Leds	-> 	LedsC;

	components MSP430I2CP,HplMsp430UsciB0C;
	BMP180P.I2C	-> MSP430I2CP;
	MSP430I2CP.UsciB -> HplMsp430UsciB0C;
	MSP430I2CP.Interrupts -> HplMsp430UsciB0C;
	MSP430I2CP.Leds	->	LedsC;

	

	components new TimerMilliC() as WaitTimer;
	BMP180P.WaitTimer ->	WaitTimer;


}
