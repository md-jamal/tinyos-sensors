

/*
 *@author:Mohammad Jamal Mohiuddin <mjmohiuddin@cdac.in>
 */

interface LC1025
{


	command error_t start();
	
	
	command error_t writeByte(uint16_t address,uint8_t byte,
					bool higher_segment);

	command error_t writePage(uint16_t address,uint8_t *byte,
					uint8_t len,bool higher_segment);

	command error_t readByte(uint16_t address,uint8_t *byte,
					bool higher_segment);


	command error_t readPage(uint16_t address,uint8_t *byte,
					uint8_t len,bool higher_segment);
}
