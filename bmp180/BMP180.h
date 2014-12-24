
#ifndef BMP180_DRIVER_H
#define BMP180_DRIVER_H

	
enum {

	BMP180_I2CSLAVE_ADDR = 0x77,
	AC1		     = 0xaa,
	AC2		     = 0xac,
	AC3		     = 0xae,
	AC4		     = 0xb0,
	AC5		     = 0xb2,
	AC6		     = 0xb4,
	B1		     = 0xb6,
	B2		     = 0xb8,
	MB		     = 0xba,
	MC		     = 0xbc,
	MD		     = 0xbe,
	
	CHIPID_REG	     = 0xd0,
	CHIPID_VALUE	     = 0x55,
	WRITE_REG= 0xF4,
	READ_REG = 0xF6,
	TEMPERATURE_VALUE    = 0x2e,
	HUMIDITY_VALUE	     = 0x34,
	WAIT_PERIOD	     = 0x5,	//4.5ms
};


enum {
	OVERSAMPLING_ULTRA_LOW	= 0x00,	//Number of samples:1
	OVERSAMPLING_STANDARD	= 0x01,	//Number of Samples:2
	OVERSAMPLING_HIGH_RES	= 0x02, //Number of Samples:4
	OVERSAMPLING_ULTRA_HIGH_RES = 0x03,//Number of Samples:8


};

enum {
	TEMPERATURE_MEASURE=0x01,
	PRESSURE_MEASURE=0x02,
	ALTITUDE_MEASURE=0x04,

	PRESSURE	= 0x08,
	ALTITUDE	= 0x10,
};


#endif
