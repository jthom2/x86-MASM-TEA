INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

.data
	key DWORD 1, 2, 3 ,4
	v0 DWORD 012345678h
	v1 DWORD 09ABCDEF0h
	sum DWORD 0

	DELTA EQU 09E3779B9h

.code
main PROC

	MOV		eax, v0
	MOV		ebx, v1
	XOR		edx, edx	; Init edx=0
	MOV		ecx, 32		; loop runs 32 times


;------------------ v0 = v0 + (((v1 << 4) + k0) XOR (v1 + sum) XOR ((v1 >> 5) + k1))
Encrypt:
	ADD		edx, DELTA

;------------------------- ((v1 << 4) + k0)
	MOV		esi, ebx
	SHL		esi, 4
	ADD		esi, key[0]		; esi holds ((v1 <<4) + k0)


;------------------------- (v1 + sum)
	MOV		edi, ebx
	ADD		edi, edx		; edi holds (v1 + sum)

;------------------------- (((v1 << 4) + k0) XOR (v1 + sum)
	XOR		esi, edi		; esi holds above


;------------------------- ((v1 >> 5) + k1))
	MOV		edi, ebx
	SHR		edi, 5
	ADD		edi, key[4]		; edi holds above

;------------------------- (((v1 << 4) + k0) XOR (v1 + sum) XOR ((v1 >> 5) + k1))
	XOR		esi, edi		; esi holds above

;------------------------- v0 = v0 (eax) + above (esi)
	ADD		eax, esi



; ------- v1 = v1 + (((v0 << 4) + k2) XOR (v0 + sum) XOR ((v0 >> 5) + k3))
	MOV		esi, eax		; esi = v0
	SHL		esi, 4			; esi = (v0 << 4)
	ADD		esi, key[8]		; esi = ((v0 << 4) + k2)


	MOV		edi, eax		; edi = v0
	ADD		edi, edx		; edi = (v0 +sum)

	XOR		esi, edi		; esi = ((v0 << 4) + k2) XOR (v0 + sum)


	MOV		edi, eax		; edi = eax
	SHR		edi, 5			; edi = (v0 >> 5)
	ADD		edi, key[12]	; edi = ((v0 >> 5) + k3))

	XOR		esi, edi		; esi = (((v0 << 4) + k2) XOR (v0 + sum) XOR ((v0 >> 5) + k3))


	ADD		ebx, esi



	LOOP	Encrypt

	MOV		v0, eax
	MOV		v1, ebx

	Call WriteHex


exit
main ENDP
END main