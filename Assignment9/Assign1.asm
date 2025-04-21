; Write X86 ALP to find, a) Number of Blank spaces b) Number of lines c) Occurrence of a
; particular character. Accept the data from the text file. The text file has to be accessed
; during Program_1 execution and write FAR PROCEDURES in Program_2 for the rest of the
; processing. Use of PUBLIC and EXTERN directives is mandatory.


; This file will contain following operations
;       1) Handling File Opening
;       2) Globalising count vars to be used in Far Procs
;       3) Calling Far procs here....
;       4) This is like Main Function.


%macro IO 4
    mov rax , %1
    mov rdi , %2
    mov rsi , %3
    mov rdx , %4
    syscall
%endmacro

section .data

    global msg6,len6,scount,ncount,chacount,new,new_len
    filename db 'input.txt', 0

    msg: db "File opened successfully", 10, 13
    len: equ $-msg

    msg1: db "File closed successfully", 10, 13
    len1: equ $-msg1

    msg2: db "Error in file opening", 10, 13
    len2: equ $-msg2

    msg3: db "Space:- ", 10
    len3: equ $-msg3

    msg4: db "New Lines:- ", 10
    len4: equ $-msg4

    msg5: db "Enter Character:- ", 10
    len5: equ $-msg5

    msg6: db "Number of Occurences:- ", 10
    len6: equ $-msg6

    new: db "", 10
    new_len: equ $-new

    scount: db 0                                
    ncount: db 0                                
    ccount: db 0                                
    chacount: db 0

section .bss

    global cnt,cnt2,cnt3,buffer

    fd: resb 17
    buffer: resb 256
    buf_len resb 17

    cnt: resb 2
    cnt2: resb 2
    cnt3: resb 2

    cha: resb 2

section .text

    global _start

    _start:

    ; Open file in read-only mode

    IO 2, fname, 2, 0777

    mov qword[fd], rax

    BT fd, 63 ; MSB is 1 if its negative else 0 ; MSB is 0 if its positive
    jc next

    IO 1, 1, msg, len
    jmp next2

    next:
        IO 1, 1, msg2, len2
        jmp exit

    next2:
        IO 0, [fd], buffer, 200
        mov qword[buf_len], rax

        mov qword[cnt]  , rax
        mov qword[cnt2] , rax
        mov qword[cnt3] , rax

        IO 1, 1, msg3, len3

        call spaces

        IO 1, 1, msg4, len4

        call enters

        IO 1, 1, msg5, len5
        IO 0, 1, cha , 2

        mov bl , byte[cha]
        IO 1,1,msg6,len6
        
        call occ

        jmp exit

    exit:
        mov rax , 60
        mov rsi , 0
        syscall