%macro IO 4
  mov rax , %1
  mov rdi , %2
  mov rsi , %3
  mov rdx , %4
  syscall
%endmacro

section .data

    Prot    db "Protected Mode : ",10
    Protlen equ $-Prot

    Real    db "Real Mode : ",10
    Reallen equ $-Real

    msw     db "MSW  : "
    mswlen  equ $-msw

    gdtr    db 10,"GDTR : "
    gdtrlen equ $-gdtr

    idtm    db 10,"IDTR : "
    idtlen  equ $-idtm

    tr      db 10,"TR : "
    trlen   equ $-tr

    ld      db 10,"LDTR : "
    ldlen   equ $-ld
    
    vendlbl     db 10, "CPU Vendor  : "
    vendlbllen  equ $-vendlbl
    
    vendor      db 12 dup(0)
    vendlen     equ 12

    verlbl      db 10, "CPUID EAX(1): "
    verlbllen   equ $-verlbl

section .bss
  gdt     resb 8 
  gdtli   resb 2
  msw1    resb 2
  temp    resb 1
  result1 resq 1
  result2 resw 1
  idt     resb 8
  idtli   resb 2
  ldt     resb 2
  t_r     resb 2
  
section .text
  global _start

_start:
  mov rsi , msw1
  smsw [rsi]
  
  mov ax , [rsi]
  bt ax , 0
  jc next
  
  IO 1 , 1 , Real , Reallen
  jmp z1
  
  next:
    IO 1 , 1 , Prot , Protlen
  
  z1:
    IO 1 , 1 , msw , mswlen
    mov ax , [msw1]
    call display2
    
    IO 1 , 1 , gdtr , gdtrlen
    mov rsi , gdt
    sgdt [rsi]
    
    mov rax , qword[rsi]
    call display1
    
    mov rsi , gdtli
    mov ax , word[rsi]
    call display2
    
    IO 1 , 1 , ld , ldlen
    mov rsi , ldt
    sldt [rsi]
    mov rax , [ldt]
    call display2
    
    IO 1 , 1 , idtm , idtlen
    mov rsi , idt
    sidt[rsi]
    mov rax , [idt]
    call display1
    
    mov ax , [idtli]
    call display2
  
    IO 1,1,tr,trlen
    mov rsi, t_r
    str [rsi]
    mov rax, [t_r]
    call display2
    
    
    IO 1,1, vendlbl, vendlbllen
    
    mov    eax, 0
    cpuid
    mov    dword [vendor    ], ebx   
    mov    dword [vendor+4  ], edx
    mov    dword [vendor+8  ], ecx
    IO     1,1, vendor, vendlen
    
    IO     1,1, verlbl, verlbllen

    mov    eax, 1
    cpuid
    
    call display1
    jmp exit
  
  display2:
    mov bp , 4
  
    up2:
      rol ax, 4
      mov word[result2] , ax
      and al , 0fh
      cmp al , 09h
      jbe next2
      
      add al , 07h
      
      next2:
        add al , 30h
        mov byte[temp] , al
        IO 1 , 1 , temp , 1
        mov ax , word[result2]
        dec bp
        jnz up2
        ret
        
    display1:
    mov bp , 16
  
    up1:
      rol ax, 4
      mov qword[result1] , rax
      and al , 0fh
      cmp al , 09h
      jbe next1
      
      add al , 07h
      
      next1:
        add al , 30h
        mov byte[temp] , al
        IO 1 , 1 , temp , 1
        mov rax , qword[result1]
        dec bp
        jnz up1
        ret

  exit:
    mov rax , 60
    mov rdi , 0
    syscall