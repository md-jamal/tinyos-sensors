
/*
 * @author : Md.Jamal Mohiuddin<mjmohiuddin@cdac.in>
 */


configuration TSL2561C
{
	provides{
			interface TSL2561;
	}

}


implementation
{

	components TSL2561P;
	TSL2561	=	TSL2561P;
	
	components MSP430I2CP,HplMsp430UsciB0C;
  	TSL2561P.I2C	-> MSP430I2CP;
	MSP430I2CP.UsciB -> HplMsp430UsciB0C;
	MSP430I2CP.Interrupts -> HplMsp430UsciB0C;

	components LedsC;
	TSL2561P.Leds	->	LedsC;


}
