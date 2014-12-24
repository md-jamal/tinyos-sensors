

interface BMP180
{

	command error_t readPressure();
	
	//standard value : 1013

	command error_t readAltitude(uint32_t sealevel_pressure);

	
	event void readDoneAltitude(error_t error,uint32_t altitude);

	
	event void readDone(error_t error,uint16_t temperature,
				uint16_t pressure);



}
