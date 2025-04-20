; Write x86 ALP to find the factorial of a given integer number on a command line by using
; recursion. Explicit stack manipulation is expected in the code.

%macro IO 4
  mov rax , %1
  mov rdi , %2
  mov rsi , %3
  mov rdx , %4
  syscall
%endmacro

section .data

  one db 0x0A, "Factorial is 00000001", 0x0A
  onelen equ $ - one
  
  msg1 db "Your number is:- ",10
  msg1len equ $ - msg1
  
  msg2 db "Factorial of given number is:- ", 10
  msg2len equ $ - msg2
  
  count db 0
  enter db 0x0A

section .bss
  num resb 1
  fact resb 8
  temp resb 1
  
  
section .text
  global _start
  
_start:
  pop rbx
  pop rbx
  pop rbx
  mov al , byte[rbx]
  mov [num] , al
  
  IO 1, 1, msg1, msg1len
  IO 1, 1, num, 1
  
  cmp byte[num] , 31h
  je oneprint
  
  cmp byte[num] , 30h
  je oneprint
  
  mov dl, byte[num]
  call A2H
  
  xor rax , rax
  xor rbx , rbx
  mov al , byte[num]
  
up1:  ; here ex: if  n = 5 =>  [5,4,3,2]  are pushed on stack.
  push rax
  inc byte[count]
  dec rax
  cmp rax , 1
  jne up1

push rax
xor rax , rax
pop rax

facto:
  pop rbx
  mul rbx
  dec byte[count]
  jnz facto
  
mov qword[fact] , rax ; save in fact
IO 1, 1, msg2, msg2len
call H2A

jmp exit

H2A:
  mov rax , [fact]
  mov byte[count] , 8
  
  up:
    rol eax , 4
    mov dl , al
    and dl , 0FH
    
    cmp dl , 09h
    jbe d1
    
    add dl , 07h
    
  d1:
    add dl , 30h
    
    mov [temp] , dl
    
    push rax
    IO 1, 1 , temp , 1
    pop rax
    
    dec byte[count]
    jnz up
    
    IO 1 , 1 , enter , 1
    ret
    
A2H:
  cmp dl , 39h
  jbe down
  sub dl, 7h
  down:
    sub dl , 30h
    mov [num] , dl
  ret

oneprint:
  IO 1 , 1 , one , onelen
  jmp exit
exit:
  mov rax, 60
  mov rdi, 0
  syscall
  
  
  