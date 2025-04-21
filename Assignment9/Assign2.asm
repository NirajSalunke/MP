; Write X86 ALP to find, a) Number of Blank spaces b) Number of lines c) Occurrence of a
; particular character. Accept the data from the text file. The text file has to be accessed
; during Program_1 execution and write FAR PROCEDURES in Program_2 for the rest of the
; processing. Use of PUBLIC and EXTERN directives is mandatory.


; This file will contain following operations
;       1) SpaceCount Proc
;       2) NewLineCount Proc
;       3) OccurCharCount Proc

%macro IO 4
    mov rax , %1
    mov rdi , %2
    mov rsi , %3
    mov rdx , %4
    syscall
%endmacro

section .data
    extern msg6, len6, scount, ncount, chacount, new, new_len  ; globalised in other file

section .bss
    extern cnt, cnt2, cnt3, buffer

section text:
    global _start2
    
    _start2:
        global spaces, enters, occ

    spaces:
        mov rsi, buffer

        up:
            mov al, byte[rsi]
            cmp al, 20h

            je next3
            inc rsi
            dec byte[cnt]
            jnz up

            jmp next4

            next3:
                inc byte [scount]
                dec byte[cnt]
                jnz up

            next4:
                add byte[scount], 30h ; adding zero for ascii
                IO 1, 1, scount, 2
                IO 1, 1, new, new_len
                ret

    enters:
        mov rsi, buffer

        up_enters:
            mov al, byte[rsi]
            cmp al, 0Ah

            je next3_enters
            inc rsi
            dec byte[cnt2]
            jnz up_enters

            jmp next4_enters

            next3_enters:
                inc byte [ncount]
                dec byte[cnt2]
                jnz up_enters

            next4_enters:
                add byte[ncount], 30h 
                IO 1, 1, ncount, 2
                IO 1, 1, new,new_len
                ret

    occ:
        mov rsi,buffer
        up_occ:
            mov al, byte[rsi]
            cmp al,bl
            je next3_occ

            inc rsi
            dec byte[cnt3]
            jnz up_occ
            
            jmp next4_occ

            next3_occ:
                inc rsi
                inc byte[chacount]
                dec byte[cnt3]
                jnz up_occ

            next4_occ:
                add byte[chacount], 30h
                IO 1, 1, chacount, 1
                IO 1, 1, new, new_len
                ret




