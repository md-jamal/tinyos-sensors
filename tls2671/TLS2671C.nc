


configuration TLS2671C
{
	provides{
			interface TLS2671;
	}

}


implementation
{

	components TLS2671P;
	TLS2671	=	TLS2671P;
	
	components MSP430I2CP,HplMsp430UsciB0C;
  	TLS2671P.I2C	-> MSP430I2CP;
	MSP430I2CP.UsciB -> HplMsp430UsciB0C;
	MSP430I2CP.Interrupts -> HplMsp430UsciB0C;

	components LedsC;
	TLS2671P.Leds	->	LedsC;


}
