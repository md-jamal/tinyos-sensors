configuration SHT21C {
  provides {
		interface Read<uint16_t> as ReadTemperature;
		interface Read<uint16_t> as ReadHumidity;
	  }

}
implementation {
  components SHT21P;

  ReadTemperature = SHT21P.ReadTemperature;
  ReadHumidity	  = SHT21P.ReadHumidity;

  components MSP430I2CP,HplMsp430UsciB0C;
  SHT21P.I2C	-> MSP430I2CP;
  MSP430I2CP.UsciB -> HplMsp430UsciB0C;
  MSP430I2CP.Interrupts -> HplMsp430UsciB0C;

  components new TimerMilliC() as WaitTimer;
  SHT21P.WaitTimer	-> WaitTimer;

}
