void UserAPP1(void){
	// Name = TESTAPP
    unsigned char Name[] = {0x54, 0x45, 0x53, 0x54, 0x41, 0x50, 0x50, 0x00};
	unsigned char UARTBuff[100] = {0};
	unsigned int UARTSize = 0;
	unsigned char MCLock = false;
    MCSetUserProgramName(&Name[0]);     // Set this app name
    MCSetProgramExecute(3);             // Allow to run from UI and CommandPort
	while(1){
		while(MHSerialAvailable() == true){
			*(UARTBuff+UARTSize) = MHSerialRead();
			UARTSize++;
			MCLock = true;
		}
		if(MCLock == true){
			MClearDisplayBuffer(0);			// Clear matrix buffer0
			MSelectWriteDisplayBuffer(0);	// Select buffer 0 to write
			MWriteText(&UARTBuff[0], RIGHT, 10, 5, UARTSize);
			MPushDisplayBuffer(0);
			MCHoldState();
			MCRelease();
		}
	}
}
