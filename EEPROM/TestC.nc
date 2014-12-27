
#include "printf.h"
#include "lc1025.h"

module TestC
{

	uses{
		interface Boot;
		interface LC1025;
		interface Timer<TMilli> as ReadTimer;
	}

}


implementation
{

	uint8_t address = 0x0000;

	uint8_t array[] = {0x08,0x07,0x06,0x05,0x04,0x03,0x02,0x01};

	uint8_t read_array[8];
	
	event void Boot.booted()
	{
	
		printf("Booted:%d\n",call LC1025.writePage(0x00,array,
						    sizeof(array),LOWER_SEGMENT));
		printfflush();
		call ReadTimer.startOneShot(4*1024);		
	}


	event void ReadTimer.fired()
	{
		uint8_t i;
		memset(&read_array,0,sizeof(read_array));
		printf("ret:%d\n",call LC1025.readPage(address,read_array,
						sizeof(read_array),LOWER_SEGMENT));
		for(i=0;i<sizeof(read_array);i++) {
			printf("Address:%x\tValue:%x\n",address,read_array[i]);
			printfflush();
			address++;
		}

		
	}

	


}
