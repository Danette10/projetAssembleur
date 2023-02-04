extern printf

global main

section .data
reponse1:   db  "Résultat: %d",10,0
resultat:	dd	0

section .bss
val1:  	resw    1


section .text
main:
push rbp

; chosir une valeur aléatoire avec rdrand
mov rax,0
rdrand ax
mov [val1],ax

; afficher la valeur aléatoire dans reponse1
mov rdi,reponse1
movzx rsi,word[val1]
mov rax,0
call printf

; sortir du programme proprement
mov rax,60
mov rdi,0
syscall
ret
