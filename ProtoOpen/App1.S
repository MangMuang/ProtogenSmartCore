UserAPP1:
    DB 0x54, 0x45, 0x53, 0x54, 0x41, 0x50, 0x50, 0x00
    DB 100 DUP(0)
    MOV UARTSize, 0
    MOV MCLock, false
    LEA R0, Name
    CALL MCSetUserProgramName
    MOV R0, 3
    CALL MCSetProgramExecute

main_loop:
    CALL MHSerialAvailable
    CMP R0, true
    JNE no_data_received
    CALL MHSerialRead
    MOV R1, UARTSize
    ADD [UARTBuff+R1], R0
    INC UARTSize
    MOV MCLock, true

no_data_received:
    CMP MCLock, true
    JNE main_loop_end
    MOV R0, 0
    CALL MClearDisplayBuffer
    MOV R0, 0
    CALL MSelectWriteDisplayBuffer
    LEA R0, UARTBuff
    MOV R1, RIGHT
    MOV R2, 10
    MOV R3, 5
    MOV R4, UARTSize
    CALL MWriteText
    MOV R0, 0
    CALL MPushDisplayBuffer
    CALL MCHoldState
    CALL MCRelease
    MOV MCLock, false
    JMP main_loop

main_loop_end:
    JMP main_loop
