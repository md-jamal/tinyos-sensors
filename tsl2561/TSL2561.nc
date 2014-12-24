
/*
 * @author : Md.Jamal Mohiuddin<mjmohiuddin@cdac.in>
 */

interface TSL2561
{

	command error_t getLux(uint32_t *lux);

	command error_t enablePower();


	command error_t readDataRegisters(uint16_t *low_value,
						uint16_t *high_value);
	

	command error_t disablePower();


}
