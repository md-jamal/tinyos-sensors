

configuration TestAppC
{


}



implementation
{

	components TestC,MainC;
	TestC.Boot	->	MainC;

	components LC1025C;
	TestC.LC1025	->	LC1025C;

	components new TimerMilliC() as ReadTimer;
	TestC.ReadTimer ->	ReadTimer;

	components PrintfC,SerialStartC;

}
