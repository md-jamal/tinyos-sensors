

interface SHT21 {

	command void I2Cinit();

	command void read(char addr, char *buffer, unsigned int size);
	command void write(char addr, char data);

}

