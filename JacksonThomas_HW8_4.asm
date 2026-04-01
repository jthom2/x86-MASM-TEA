INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

.data
	key DWORD 1, 2, 3 ,4
	v0 DWORD 012345678h
	v1 DWORD 09ABCDEF0h
	sum DWORD 0

	DELTA EQU 09E379B9h

.code
main PROC

	MOV		eax, v0
	MOV		ebx, v1


exit
main ENDP
END main