

interface TLS2671
{


	command error_t get();

	command int8_t readRegister(uint8_t reg,uint8_t *value);

	command error_t enablePower();

	command error_t registerSetup();


}
