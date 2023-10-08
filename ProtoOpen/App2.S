section .data
    RickRoll db "RICKROLL",0
    ThinkSmart db "THINKSMART",0
    Name db "TESTAPP",0
    UARTBuff db 100 dup(0)
    MHandle db 0xFF
    UARTSize dd 0
    MCLock db 0

section .text
global UserAPP2

UserAPP2:
    call MCSetUserProgramName
    mov eax, 2
    call MCSetProgramExecute

loop_start:
    call MHSerialAvailable
    test al, al
    jz loop_start

    call MHSerialRead
    mov [UARTBuff + eax], al
    inc dword [UARTSize]
    mov byte [MCLock], 1

    cmp dword [UARTSize], 7
    jne loop_start

    mov edi, offset RickRoll
    mov esi, offset UARTBuff
    mov ecx, 7
    repe cmpsb
    je play_rickroll

    mov edi, offset ThinkSmart
    mov esi, offset UARTBuff
    mov ecx, 10
    repe cmpsb
    je play_thinksmart

    jmp loop_start

play_rickroll:
    call MPPlayVideo
    mov edi, offset UARTBuff
    mov ecx, 100
    xor al, al
    rep stosb
    mov dword [UARTSize], 0
    jmp check_finish

play_thinksmart:
    call MPPlayVideo
    mov edi, offset UARTBuff
    mov ecx, 100
    xor al, al
    rep stosb
    mov dword [UARTSize], 0

check_finish:
    cmp byte [MHandle], 0xFF
    jz loop_start

    call MPIsFinished
    test al, al
    jz loop_start

    call MCRelease
    jmp loop_start
