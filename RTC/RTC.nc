
/*
 *@author:Mohammad Jamal Mohiuddin <mjmohiuddin@cdac.in>
 */
#include "rtc.h"

interface RTC
{

	command error_t getSeconds(uint8_t *sec);

	command error_t getMinutes(uint8_t *min);

	command error_t getHours(uint8_t *hour);

	command error_t getDay(uint8_t *day);

	command error_t getDate(uint8_t *date);

	command error_t getMonth(uint8_t *month);

	command error_t getYear(uint8_t *year);

	command error_t get(struct rtc *data);

	command error_t setSeconds(uint8_t sec);

	command error_t setMinutes(uint8_t min);

	command error_t setHours(uint8_t hour);

	command error_t setDay(uint8_t day);

	command error_t setDate(uint8_t date);

	command error_t setMonth(uint8_t month);

	command error_t setYear(uint8_t year);

	command error_t set(struct rtc *data);

	command error_t stop();

	command error_t start();	

}
