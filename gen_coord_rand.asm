extern printf

section .data
reponse1: db "Coordonnées: (%d,%d), (%d,%d)",10,0
x1: dd 0
y1: dd 0
x2: dd 0
y2: dd 0

section .bss

section .text

; la fonction pour générer des nombres aléatoires entiers
; prend en entrée un pointeur vers un espace de stockage pour le résultat
; et retourne ce dernier dans EAX
generer_nombre_aleatoire:
push rbp
mov rax,0
rdrand ax
jnc lbl_relancer
mov [rdi],ax
jmp lbl_fin
lbl_relancer:
call generer_nombre_aleatoire
lbl_fin:
pop rbp
ret

global main
main:
push rbp

; appeler la fonction pour générer les coordonnées x1 et y1
lea rdi, [x1]
call generer_nombre_aleatoire
lea rdi, [y1]
call generer_nombre_aleatoire

; utiliser un modulo pour obtenir des valeurs correctes
mov cx,65535
mov ax,[x1]
div cx
mov [x1],dx
mov ax,[y1]
div cx
mov [y1],dx

; appeler la fonction pour générer les coordonnées x2 et y2
lea rdi, [x2]
call generer_nombre_aleatoire
lea rdi, [y2]
call generer_nombre_aleatoire

; utiliser un modulo pour obtenir des valeurs correctes
mov cx,65535
mov ax,[x2]
div cx
mov [x2],dx
mov ax,[y2]
div cx
mov [y2],dx

; afficher les coordonnées x1, y1 et x2, y2 dans reponse1
mov rdi,reponse1
movzx rsi,word[x1]
movzx rdx,word[y1]
movzx rcx,word[x2]
movzx r8,word[y2]
mov rax,0
call printf

; sortir du programme proprement
mov rax,60
mov rdi,0
syscall
ret