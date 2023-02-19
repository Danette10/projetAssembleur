; external functions from X11 library
extern XOpenDisplay
extern XDisplayName
extern XCloseDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XRootWindow
extern XSelectInput
extern XFlush
extern XCreateGC
extern XSetForeground
extern XDrawLine
extern XDrawPoint
extern XFillArc
extern XNextEvent

; external functions from stdio library (ld-linux-x86-64.so.2)    
extern printf
extern exit

%define	StructureNotifyMask	131072
%define KeyPressMask		1
%define ButtonPressMask		4
%define MapNotify		19
%define KeyPress		2
%define ButtonPress		4
%define Expose			12
%define ConfigureNotify		22
%define CreateNotify 16
%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1

global main
section .bss
point: resb 1
taille: resb 20

display_name:	resq	1
screen:			resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		resq	1
gc:		resq	1

section .data

reponse1: db "Coordonnées: %d",10,0
question: db "Taille de la fenetre : ",0

reponse: db "nombre aléatoire avec modulo = %d", 10,0


event:		times	24 dq 0

x1:	dd 0
x2:	dd	0
y1:	dd	0
y2:	dd	0
x3:	dd 0
x4:	dd	0
y3:	dd	0
y4:	dd	0

section .text


;##################################################
;########### FONCTION POUR GENERER UN #############
;############## NOMBRE ALEATOIRE ##################
;##################################################

; la fonction pour générer des nombres aléatoires entiers
; prend en entrée un pointeur vers un espace de stockage pour le résultat
; et retourne ce dernier dans EAX
global aleatoire

aleatoire:
push rbp
mov rdi,0
mov byte[taille],400
movzx rdi, byte[taille]
coord_al:
mov  ax, 0
rdrand ax; génération d'un nombre aléatoire

jnc coord_al; si Cf = 0 on saute a coord_al
modulo:

mov bx, di

mov dx, 0

div bx

mov ax, dx

stop:

pop rbp

ret

main:

push rbp



call aleatoire
mov [x1], ax
mov rsi, [x1]

call aleatoire
mov [y1], ax
mov rsi, [y1]

call aleatoire
mov [x2], ax
mov rsi, [x2]

call aleatoire
mov [y2], ax
mov rsi, [y2]

call aleatoire
mov [x3], ax
mov rsi, [x3]

call aleatoire
mov [y3], ax
mov rsi, [y3]



xor     rdi,rdi
call    XOpenDisplay	; Création de display
mov     qword[display_name],rax	; rax=nom du display

; display_name structure
; screen = DefaultScreen(display_name);
mov     rax,qword[display_name]
mov     eax,dword[rax+0xe0]
mov     dword[screen],eax

mov rdi,qword[display_name]
mov esi,dword[screen]
call XRootWindow
mov rbx,rax

mov rdi,qword[display_name]
mov rsi,rbx
mov rdx,10
mov rcx,10
mov r8,400	; largeur
mov r9,400	; hauteur
push 0xFFFFFF	; background  0xRRGGBB
push 0x00FF00
push 1
call XCreateSimpleWindow
mov qword[window],rax

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,131077 ;131072
call XSelectInput

mov rdi,qword[display_name]
mov rsi,qword[window]
call XMapWindow

mov rsi,qword[window]
mov rdx,0
mov rcx,0
call XCreateGC
mov qword[gc],rax

mov rdi,qword[display_name]
mov rsi,qword[gc]
mov rdx,0x000000	; Couleur du crayon
call XSetForeground

boucle: ; boucle de gestion des évènements
mov rdi,qword[display_name]
mov rsi,event
call XNextEvent

cmp dword[event],ConfigureNotify	; à l'apparition de la fenêtre
je dessin							; on saute au label 'dessin'

cmp dword[event],KeyPress			; Si on appuie sur une touche
je closeDisplay						; on saute au label 'closeDisplay' qui ferme la fenêtre
jmp boucle

;#########################################
;#		DEBUT DE LA ZONE DE DESSIN		 #
;#########################################
dessin:

; couleurs sous forme RRGGBB où RR esr le niveau de rouge, GG le niveua de vert et BB le niveau de bleu
; 0000000 (noir) à FFFFFF (blanc)

;couleur du point 1
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0xFF0000	; Couleur du crayon ; rouge
call XSetForeground

; Dessin d'un point rouge : coordonnées (100,200)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,100	; coordonnée source en x
mov r8d,200	; coordonnée source en y
call XDrawPoint

;couleur du point 2
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0x00FF00	; Couleur du crayon ; vert
call XSetForeground

; Dessin d'un point vert: coordonnées (100,250)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,100	; coordonnée source en x
mov r8d,250	; coordonnée source en y
call XDrawPoint

;couleur du point 3
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0x0000FF	; Couleur du crayon ; bleu
call XSetForeground

; Dessin d'un point bleu : coordonnées (200,200)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,200	; coordonnée source en x
mov r8d,200	; coordonnée source en y
call XDrawPoint

;couleur du point 4
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0xFF00FF	; Couleur du crayon ; violet
call XSetForeground

; Dessin d'un point violet : coordonnées (200,250)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,200	; coordonnée source en x
mov r8d,250	; coordonnée source en y
call XDrawPoint

;couleur de la ligne 1 (noir)
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0x000000	; Couleur du crayon ; noir
call XSetForeground
; dessin de la ligne 1
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,dword[x1]	; coordonnée source en x
mov r8d,dword[y1]	; coordonnée source en y
mov r9d,dword[x2]	; coordonnée destination en x
push qword[y2]		; coordonnée destination en y
call XDrawLine

; coordonnées de la ligne 2
mov dword[x3],x1
mov dword[y3],y1
; dessin de la ligne 1
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,dword[x1]	; coordonnée source en x
mov r8d,dword[y1]	; coordonnée source en y
call XDrawLine

; coordonnées de la ligne 3
mov dword[x4],x2
mov dword[y4],y2
; dessin de la ligne 1
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,dword[x2]	; coordonnée source en x
mov r8d,dword[y2]	; coordonnée source en y
call XDrawLine

; ############################
; # FIN DE LA ZONE DE DESSIN #
; ############################
jmp flush

flush:
mov rdi,qword[display_name]
call XFlush
jmp boucle
mov rax,34
syscall

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor	    rdi,rdi
    call    exit
