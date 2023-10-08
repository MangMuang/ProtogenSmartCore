void UserAPP2(void){
	// Name = TESTAPP
	const unsigned char* RickRoll = "RICKROLL";
	const unsigned char* ThinkSmart = "THINKSMART";
    unsigned char Name[] = {0x54, 0x45, 0x53, 0x54, 0x41, 0x50, 0x50, 0x00};
	unsigned char UARTBuff[100] = {0};
	unsigned char MHandle = 0xFF;
	unsigned int UARTSize = 0;
	unsigned char MCLock = false;
    MCSetUserProgramName(&Name[0]);     // Set this app name
    MCSetProgramExecute(2);             // Allow to run from CommandPort
	while(1){
		while(MHSerialAvailable() == true){
			*(UARTBuff+UARTSize) = MHSerialRead();
			UARTSize++;
			MCLock = true;
		}
		if(MCLock == true){
			if(memcmp(&RickRoll[0], &UARTBuff[0], UARTSize) == 0){
				MHandle = MPPlayVideo("Video/RickRoll.mp4", LEFT, 0, 0);
				memset(&UARTBuff[0], 0x00, 100);
				UARTSize = 0;
			}else if(memcmp(&ThinkSmart[0], &UARTBuff[0], UARTSize) == 0){
				MHandle = MPPlayVideo("Video/ThinkSmartV.mp4", LEFT, 0, 0);
				memset(&UARTBuff[0], 0x00, 100);
				UARTSize = 0;
			}
			if(MHandle != 0xFF){
				if(MPIsFinished(MHandle) == true){
					MCRelease();
				}
			}
		}
	}
}
