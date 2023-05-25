		

	 .INCLUDE "M32DEF.INC"

.EQU	KEY_PORT = PORTC		
.EQU	KEY_PIN = PINC
.EQU	KEY_DDR = DDRC 

.EQU    RAMZ1=13 ;4
.EQU    RAMZ2=11 ;0 
.EQU    RAMZ3=10 ;2
.EQU    RAMZ4=14 ;1

.DEF	AD1=R25
.DEF	AD2=R26
.DEF	AD0=R27
.DEF	AD4=R28

.DEF	ADAD=R20

.MACRO READ
	
	WT:
	SBIC EECR,EEWE
	RJMP WT
	LDI R18,0
	OUT EEARH,R18
	OUT EEARL,@0
	SBI EECR,EERE
	IN R10,EEDR
	
.ENDMACRO	


	        LDI R16,HIGH(RAMEND)
			OUT SPH,R16
			LDI R16,LOW(RAMEND)
			OUT SPL,R16
			
			LDI R16,0XFF
			OUT DDRB,R16
			OUT DDRD,R16
			SBI DDRA,0
			SBI DDRA,1

			LDI R16,0xF0
			OUT KEY_DDR,R16

			LDI AD0,0X15
			LDI AD1,0X13
			LDI AD2,0X14
			LDI AD4,0X16.

			

;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\


WAIT1:
    SBIC EECR,EEWE
	RJMP WAIT1
	LDI R18,0
	LDI R17,0X13
	OUT EEARH,R18
	OUT EEARL,R17
	LDI R21,RAMZ4
	OUT EEDR,R21
	SBI EECR,EEMWE 
	SBI EECR,EEWE

WAIT2:
    SBIC EECR,EEWE
	RJMP WAIT2
	LDI R18,0
	LDI R17,0X14
	OUT EEARH,R18
	OUT EEARL,R17
	LDI R22,RAMZ3
	OUT EEDR,R22
	SBI EECR,EEMWE 
	SBI EECR,EEWE

WAIT3:
    SBIC EECR,EEWE
	RJMP WAIT3
	LDI R18,0
	LDI R17,0X15
	OUT EEARH,R18
	OUT EEARL,R17
	LDI R23,RAMZ2
	OUT EEDR,R23
	SBI EECR,EEMWE 
	SBI EECR,EEWE
	
WAIT4:
    SBIC EECR,EEWE
	RJMP WAIT4
	LDI R18,0
	LDI R17,0X16
	OUT EEARH,R18
	OUT EEARL,R17
	LDI R24,RAMZ1
	OUT EEDR,R24
	SBI EECR,EEMWE 
	SBI EECR,EEWE

	LDI R16,15
	CLR R5

;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

GROUND_ALL_ROWS:

	LDI 	ADAD,0x0F
	OUT 	KEY_PORT,ADAD

WAIT_FOR_RELEASE:

	NOP
	IN  	R21,KEY_PIN 		;Read Key Pins
	ANDI	R21,0x0F    		;Mask unused bits
	CPI 	R21,0x0F    		;(equal if no key)
	BRNE	WAIT_FOR_RELEASE	;Do again till keys released

WAIT_FOR_KEY:

	NOP
	IN  	R21,KEY_PIN		;Read Key Pins
	ANDI	R21,0x0F		;Mask unused bits
	CPI 	R21,0x0F		;(equal if no key)
	BREQ	WAIT_FOR_KEY	;Do again till a key pressed

	CALL	WAIT15MS		;Wait 15ms

	NOP
	IN  	R21,KEY_PIN		;Read Key Pins
	ANDI	R21,0x0F		;Mask unused bits
	CPI 	R21,0x0F		;(equal if no key)
	BREQ	WAIT_FOR_KEY	;Do again till a key pressed

	LDI 	R21,0b01111111	;Ground row 0
	OUT 	KEY_PORT,R21	;
	NOP
	IN  	R21,KEY_PIN		;Read all columns
	ANDI	R21,0x0F		;Mask unused bits
	CPI 	R21,0x0F		;(equal if no key)
	BRNE	COL1			;row 0, find the colum

	LDI 	R21,0b10111111	;Ground row 1
	OUT 	KEY_PORT,R21	
	NOP
	IN  	R21,KEY_PIN		;Read all columns
	ANDI	R21,0x0F		;Mask unused bits
	CPI 	R21,0x0F		;(equal if no key)
	BRNE	COL2			;row 1, find the colum

	LDI 	R21,0b11011111	;Ground row 2
	OUT 	KEY_PORT,R21	
	NOP
	IN  	R21,KEY_PIN		;Read all columns
	ANDI	R21,0x0F		;Mask unused bits
	CPI 	R21,0x0F		;(equal if no key)
	BRNE	COL3			;row 0, find the colum

	LDI 	R21,0b11101111	;Ground row 3
	OUT 	KEY_PORT,R21	
	NOP
	IN  	R21,KEY_PIN		;Read all columns
	ANDI	R21,0x0F		;Mask unused bits
	CPI 	R21,0x0F		;(equal if no key)
	BRNE	COL4			;row 0, find the colum

COL1:
	LDI 	R30,LOW(KCODE0<<1)
	LDI 	R31,HIGH(KCODE0<<1)
	RJMP	FIND

COL2:
	LDI 	R30,LOW(KCODE1<<1)
	LDI 	R31,HIGH(KCODE1<<1)
	RJMP	FIND


COL3:
	LDI 	R30,LOW(KCODE2<<1)
	LDI 	R31,HIGH(KCODE2<<1)
	RJMP	FIND


COL4:
	LDI 	R30,LOW(KCODE3<<1)
	LDI 	R31,HIGH(KCODE3<<1)
	RJMP	FIND

FIND:
	LSR 	R21
	BRCC	MATCH			;if Carry is low goto match
	LPM 	ADAD,Z+			;INC Z
	RJMP	FIND	
MATCH:
	LPM 	ADAD,Z


;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
	
	MOV R9,ADAD
	SUB R9,R16
	BRNE EDAME
	RJMP LOOP

EDAME:

	SBRC R5,0
	RJMP BAD

	SBRC R5,1
	RJMP BAD2

	READ AD4
	SUB ADAD,R10
	BRNE L1
	INC R5
		
	RJMP GROUND_ALL_ROWS

L1: ORI R29,1
	INC R5
	RJMP GROUND_ALL_ROWS
;======================================================================
BAD:
	
	SBRC R5,1
	RJMP BAD3

	READ AD0
	SUB ADAD,R10
	BRNE L2
	INC R5

	
	RJMP GROUND_ALL_ROWS

L2: ORI R29,1
	INC R5
	RJMP GROUND_ALL_ROWS
;=======================================================================
BAD2: 

	READ AD2
	SUB ADAD,R10
	BRNE L3
	INC R5
	
	RJMP GROUND_ALL_ROWS

L3: ORI R29,1
	INC R5
	RJMP GROUND_ALL_ROWS

BAD3:

	READ AD1
	SUB ADAD,R10
	BRNE L4
	INC R5
    
	SBRC R29,0
	RJMP L4

	SBI PORTA,0
	CBI PORTA,1
	
	RJMP GROUND_ALL_ROWS

L4: SBI PORTA,1
	CBI PORTA,0

	RJMP	GROUND_ALL_ROWS

LOOP: 

	CLR R5
	CLR R29
	OUT PORTA,R5  	
	RJMP	GROUND_ALL_ROWS



;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
			


WAIT15MS:	
RET

.ORG 0x300
KCODE0:	.DB 0,1,2,3		;ROW 0
KCODE1:	.DB 4,5,6,7 	;ROW 1
KCODE2:	.DB 8,9,10,11		;ROW 2
KCODE3:	.DB 12,13,14,15		;ROW 3
 



