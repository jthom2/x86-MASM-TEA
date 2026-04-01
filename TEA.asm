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



Encrypt:
	ADD		edx, DELTA

;------------------ v0 = v0 + (((v1 << 4) + k0) XOR (v1 + sum) XOR ((v1 >> 5) + k1))
	MOV		esi, ebx
	SHL		esi, 4
	ADD		esi, key[0]		

	LEA		edi, [ebx + edx] 
	XOR		esi, edi		


	MOV		edi, ebx
	SHR		edi, 5
	ADD		edi, key[4]		

	XOR		esi, edi		

	ADD		eax, esi		; v0 encrypted



; ------- v1 = v1 + (((v0 << 4) + k2) XOR (v0 + sum) XOR ((v0 >> 5) + k3))
	MOV		esi, eax		
	SHL		esi, 4			
	ADD		esi, key[8]		


	LEA		edi, [eax + edx]; edi = (v0 + sum)

	XOR		esi, edi		


	MOV		edi, eax		
	SHR		edi, 5			
	ADD		edi, key[12]	

	XOR		esi, edi		


	ADD		ebx, esi		; v1 encrypted

	DEC		ecx
	JNZ		Encrypt

	MOV		v0, eax			; v0 now encrytped
	MOV		v1, ebx			; v1 now encrypted

;------- Decryption -------;




	MOV		edx, DELTA
	SHL		edx, 5			; edx = Delta*32
	MOV		ecx, 32


Decrypt:
; v1 = v1 - (((v0 << 4) + k2) XOR (v0 + sum) XOR ((vo >> 5) + k3))

	MOV		esi, eax
	SHL		esi, 4
	ADD		esi, key[8]			

	LEA		edi, [eax + edx]	
	XOR		esi, edi			

	MOV		edi, eax
	SHR		edi, 5
	ADD		edi, key[12]		

	XOR		esi, edi			
	SUB		ebx, esi			; v1 decrypted

; v0 = v0 - (((v1 << 4) + k0) XOR (v1 + sum) XOR ((v1 >> 5) + k1))
	
	MOV		esi, ebx
	SHL		esi, 4
	ADD		esi, key[0]

	LEA		edi, [ebx + edx]
	XOR		esi, edi

	MOV		edi, ebx
	SHR		edi, 5
	ADD		edi, key[4]

	XOR		esi, edi
	SUB		eax, esi			; v0 decrypted


	SUB		edx, DELTA

	DEC		ecx
	JNZ		Decrypt
exit
main ENDP
END main