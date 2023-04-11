
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : No
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _nhiet_do=R10
	.DEF _nhiet_do_msb=R11
	.DEF _ck=R12
	.DEF _ck_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x14:
	.DB  0x5,0x6,0x8,0x9,0xB,0xC
_0x0:
	.DB  0x3D,0x3E,0x20,0x20,0x20,0x20,0x43,0x41
	.DB  0x49,0x20,0x44,0x41,0x54,0x20,0x47,0x49
	.DB  0x4F,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x43,0x41,0x49,0x20,0x44
	.DB  0x41,0x54,0x20,0x4E,0x47,0x41,0x59,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x43,0x41,0x49,0x20,0x44,0x41,0x54,0x20
	.DB  0x47,0x49,0x4F,0x20,0x20,0x20,0x0,0x3D
	.DB  0x3E,0x20,0x20,0x20,0x20,0x43,0x41,0x49
	.DB  0x20,0x44,0x41,0x54,0x20,0x4E,0x47,0x41
	.DB  0x59,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x43,0x41,0x49,0x20,0x44,0x41,0x54,0x20
	.DB  0x47,0x49,0x4F,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x43,0x41,0x49
	.DB  0x20,0x44,0x41,0x54,0x20,0x4E,0x47,0x41
	.DB  0x59,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x25,0x32,0x2E,0x32,0x75
	.DB  0x3A,0x25,0x32,0x2E,0x32,0x75,0x3A,0x25
	.DB  0x32,0x2E,0x32,0x75,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x32,0x2E,0x32,0x75,0x2F,0x25,0x32
	.DB  0x2E,0x32,0x75,0x2F,0x25,0x32,0x2E,0x32
	.DB  0x75,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x6E,0x68,0x69,0x65,0x74,0x20,0x64
	.DB  0x6F,0x3A,0x25,0x64,0x0,0x6E,0x68,0x69
	.DB  0x65,0x74,0x20,0x64,0x6F,0x3A,0x25,0x64
	.DB  0x20,0x0,0x20,0x20,0x64,0x6F,0x20,0x61
	.DB  0x6E,0x20,0x68,0x6F,0x63,0x20,0x70,0x68
	.DB  0x61,0x6E,0x20,0x32,0x0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060003:
	.DB  0x80,0xC0
_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x06
	.DW  _vi_tri
	.DW  _0x14*2

	.DW  0x15
	.DW  _0x9B
	.DW  _0x0*2

	.DW  0x15
	.DW  _0x9B+21
	.DW  _0x0*2+21

	.DW  0x15
	.DW  _0x9B+42
	.DW  _0x0*2+42

	.DW  0x15
	.DW  _0x9B+63
	.DW  _0x0*2+63

	.DW  0x15
	.DW  _0x9B+84
	.DW  _0x0*2+84

	.DW  0x15
	.DW  _0x9B+105
	.DW  _0x0*2+105

	.DW  0x13
	.DW  _0x101
	.DW  _0x0*2+210

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/7/2022
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdio.h>
;// I2C Bus functions
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0040 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041 char status,data;
; 0000 0042 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0043 data=UDR;
	IN   R16,12
; 0000 0044 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0045    {
; 0000 0046    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0047 #if RX_BUFFER_SIZE == 256
; 0000 0048    // special case for receiver buffer size=256
; 0000 0049    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 004A #else
; 0000 004B    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 004C    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 004D       {
; 0000 004E       rx_counter=0;
	CLR  R7
; 0000 004F       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0050       }
; 0000 0051 #endif
; 0000 0052    }
_0x5:
; 0000 0053 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x124
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 005A {
_getchar:
; .FSTART _getchar
; 0000 005B char data;
; 0000 005C while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 005D data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 005E #if RX_BUFFER_SIZE != 256
; 0000 005F if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0060 #endif
; 0000 0061 #asm("cli")
_0x9:
	cli
; 0000 0062 --rx_counter;
	DEC  R7
; 0000 0063 #asm("sei")
	sei
; 0000 0064 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0065 }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 007B {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007C if (tx_counter)
	TST  R8
	BREQ _0xA
; 0000 007D    {
; 0000 007E    --tx_counter;
	DEC  R8
; 0000 007F    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0080 #if TX_BUFFER_SIZE != 256
; 0000 0081    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
; 0000 0082 #endif
; 0000 0083    }
_0xB:
; 0000 0084 }
_0xA:
_0x124:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 008B {
_putchar:
; .FSTART _putchar
; 0000 008C while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0xC
; 0000 008D #asm("cli")
	cli
; 0000 008E if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 008F    {
; 0000 0090    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0091 #if TX_BUFFER_SIZE != 256
; 0000 0092    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x12
	CLR  R6
; 0000 0093 #endif
; 0000 0094    ++tx_counter;
_0x12:
	INC  R8
; 0000 0095    }
; 0000 0096 else
	RJMP _0x13
_0xF:
; 0000 0097    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0098 #asm("sei")
_0x13:
	sei
; 0000 0099 }
	RJMP _0x2100009
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;//khai bao bien
;#include <stdio.h>
;#define den_bao PORTA.7
;#define nut_phai PINA.0
;#define nut_trai PINA.1
;#define nut_giam PINA.2
;#define nut_tang PINA.3
;#define data_len hc05[1]
;#define ma_lenh hc05[2]
;#define checksum (hc05[ki_tu-2]*256 + hc05[ki_tu-1])
;#define ki_tu_batdau '@'
;#define on_tb 1
;#define off_tb 0
;#define trang_thai_tb 2
;#define data_nhietdo 3
;#define tb1 PORTD.4
;#define tb2 PORTD.5
;#define tb3 PORTD.6
;#define tb4 PORTD.7
;#define trang_thai1 PIND.4
;#define trang_thai2 PIND.5
;#define trang_thai3 PIND.6
;#define trang_thai4 PIND.7
;#define on_all 0xFF
;#define off_all 0x00
;
;           // cau truc khung truyen 1 goi du lieu
;           //ky tu bat dau (1 byte) + data len (1 byte) + ma lenh(1 byte) + data(n byte) + checksum(2 byte)
;           //vi du:          @                  05                00             01 02               0x00 0x05
;           // ma lenh: 00:off thiet bi/ 01:on / 02:lay trang thai thiet bi / 03: lay du lieu nhiet do
;           // trong do "data_len" la do dai cua goi du lieu duoc tinh tu "vi tri sau no" den het
;           // checksum duoc tinh tu "data_len" cho toi "data"
;int nhiet_do;
;
;unsigned int ck;
;unsigned char hc05[20],ki_tu,so_tb;
;unsigned char vi_tri[6]={5,6,8,9,11,12};

	.DSEG
;unsigned char vi_tri_cai_dat,m;
;unsigned int test[6];
;unsigned char gio_cd, phut_cd, giay_cd,thu_cd, ngay_cd, thang_cd, nam_cd;
;unsigned char gio, phut, giay, thu, ngay, thang, nam;
;unsigned char chuoi1[6], chuoi2[6], chuoi3[6],chuoi4[6], chuoi5[6], chuoi6[6], chuoi[20];
;unsigned char da_nhan_trai, da_nhan_phai, da_nhan_tang, da_nhan_giam;
;void giaotiep_hc05(){
; 0000 00C9 void giaotiep_hc05(){

	.CSEG
_giaotiep_hc05:
; .FSTART _giaotiep_hc05
; 0000 00CA      // cau truc khung truyen 1 goi du lieu
; 0000 00CB            //ky tu bat dau (1 byte) + data len (1 byte) + ma lenh(1 byte) + data(n byte) + checksum(2 byte)
; 0000 00CC            //vi du:          @                  05                00             01 02              0x00 0x05
; 0000 00CD            // ma lenh: 00:off thiet bi/ 01:on / 02:lay trang thai thiet bi / 03: lay du lieu nhiet do
; 0000 00CE            // trong do "data_len" la do dai cua goi du lieu duoc tinh tu "vi tri sau no" den het
; 0000 00CF            // checksum duoc tinh tu "data_len" cho toi "data"
; 0000 00D0 
; 0000 00D1         if(rx_counter>0)                       //  03                   03        00 06
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x15
; 0000 00D2         {
; 0000 00D3 
; 0000 00D4             hc05[ki_tu]=getchar();
	LDS  R30,_ki_tu
	LDI  R31,0
	SUBI R30,LOW(-_hc05)
	SBCI R31,HIGH(-_hc05)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00D5             if(hc05[ki_tu]==ki_tu_batdau){
	LDS  R30,_ki_tu
	CALL SUBOPT_0x0
	CPI  R26,LOW(0x40)
	BRNE _0x16
; 0000 00D6                   hc05[0]=ki_tu_batdau;
	LDI  R30,LOW(64)
	STS  _hc05,R30
; 0000 00D7                 ki_tu=0;
	LDI  R30,LOW(0)
	STS  _ki_tu,R30
; 0000 00D8                 ck=0;
	CLR  R12
	CLR  R13
; 0000 00D9             }
; 0000 00DA             ki_tu++;
_0x16:
	LDS  R30,_ki_tu
	SUBI R30,-LOW(1)
	STS  _ki_tu,R30
; 0000 00DB             if(ki_tu>1 && ki_tu<=data_len )  // i<data len
	LDS  R26,_ki_tu
	CPI  R26,LOW(0x2)
	BRLO _0x18
	__GETB1MN _hc05,1
	CP   R30,R26
	BRSH _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 00DC             {
; 0000 00DD                  ck=ck+hc05[ki_tu-1];
	CALL SUBOPT_0x1
	__ADDWRR 12,13,30,31
; 0000 00DE 
; 0000 00DF             }
; 0000 00E0 
; 0000 00E1         }
_0x17:
; 0000 00E2 
; 0000 00E3          //kiem tra nhan du va dung goi du lieu
; 0000 00E4 
; 0000 00E5          if(ki_tu==data_len+ 2  ) // 2: 2 byte bom gom "ky tu bat dau" va ky tu tu "data_len"
_0x15:
	__GETB1MN _hc05,1
	LDI  R31,0
	ADIW R30,2
	LDS  R26,_ki_tu
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+2
	RJMP _0x1A
; 0000 00E6                       // 1: la do sau khi nhan du lieu thi i++
; 0000 00E7          {
; 0000 00E8 
; 0000 00E9             if(hc05[0]==ki_tu_batdau && ck==checksum){    //nhan dung goi' du lieu
	LDS  R26,_hc05
	CPI  R26,LOW(0x40)
	BRNE _0x1C
	LDS  R30,_ki_tu
	LDI  R31,0
	SBIW R30,2
	SUBI R30,LOW(-_hc05)
	SBCI R31,HIGH(-_hc05)
	LD   R26,Z
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	MOVW R26,R30
	CALL SUBOPT_0x1
	ADD  R30,R26
	ADC  R31,R27
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
; 0000 00EA                 if(ma_lenh == on_tb){
	__GETB2MN _hc05,2
	CPI  R26,LOW(0x1)
	BRNE _0x1E
; 0000 00EB                      for(so_tb=3;so_tb<data_len;so_tb++){
	LDI  R30,LOW(3)
	STS  _so_tb,R30
_0x20:
	__GETB1MN _hc05,1
	LDS  R26,_so_tb
	CP   R26,R30
	BRSH _0x21
; 0000 00EC                          if( hc05[so_tb] == 1){
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x1)
	BRNE _0x22
; 0000 00ED                             tb1=1;
	SBI  0x12,4
; 0000 00EE                          }
; 0000 00EF                           if( hc05[so_tb] == 2){
_0x22:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x2)
	BRNE _0x25
; 0000 00F0                             tb2=1;
	SBI  0x12,5
; 0000 00F1                          }
; 0000 00F2                           if( hc05[so_tb] == 3){
_0x25:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x3)
	BRNE _0x28
; 0000 00F3                             tb3=1;
	SBI  0x12,6
; 0000 00F4                          }
; 0000 00F5                           if( hc05[so_tb] == 4){
_0x28:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x4)
	BRNE _0x2B
; 0000 00F6                             tb4=1;
	SBI  0x12,7
; 0000 00F7                          }
; 0000 00F8                           if( hc05[so_tb] == 0xFF){
_0x2B:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0xFF)
	BRNE _0x2E
; 0000 00F9                             tb1=tb2=tb3=tb4=1;
	SBI  0x12,7
	SBI  0x12,6
	SBI  0x12,5
	SBI  0x12,4
; 0000 00FA                          }
; 0000 00FB                      }
_0x2E:
	LDS  R30,_so_tb
	SUBI R30,-LOW(1)
	STS  _so_tb,R30
	RJMP _0x20
_0x21:
; 0000 00FC                     putchar(ki_tu_batdau);
	CALL SUBOPT_0x3
; 0000 00FD                     putchar(7);
; 0000 00FE                     putchar(ma_lenh);
; 0000 00FF                     putchar(trang_thai1);
; 0000 0100                     putchar(trang_thai2);
; 0000 0101                     putchar(trang_thai3);
; 0000 0102                     putchar(trang_thai4);
; 0000 0103                     ck=7+ma_lenh+trang_thai1+trang_thai2+trang_thai3+trang_thai4;
	RJMP _0x114
; 0000 0104                     putchar(0);
; 0000 0105                     putchar(ck);
; 0000 0106                 }
; 0000 0107                 else if(ma_lenh == off_tb){
_0x1E:
	__GETB1MN _hc05,2
	CPI  R30,0
	BRNE _0x38
; 0000 0108                      for(so_tb=3;so_tb<data_len;so_tb++){
	LDI  R30,LOW(3)
	STS  _so_tb,R30
_0x3A:
	__GETB1MN _hc05,1
	LDS  R26,_so_tb
	CP   R26,R30
	BRSH _0x3B
; 0000 0109                          if( hc05[so_tb] == 0){
	LDS  R30,_so_tb
	LDI  R31,0
	SUBI R30,LOW(-_hc05)
	SBCI R31,HIGH(-_hc05)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x3C
; 0000 010A                                 tb1=tb2=tb3=tb4=0;
	CBI  0x12,7
	CBI  0x12,6
	CBI  0x12,5
	CBI  0x12,4
; 0000 010B                          }
; 0000 010C                          if( hc05[so_tb] == 1){
_0x3C:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x1)
	BRNE _0x45
; 0000 010D                             tb1=0;
	CBI  0x12,4
; 0000 010E                          }
; 0000 010F                           if( hc05[so_tb] == 2){
_0x45:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x2)
	BRNE _0x48
; 0000 0110                             tb2=0;
	CBI  0x12,5
; 0000 0111                          }
; 0000 0112                           if( hc05[so_tb] == 3){
_0x48:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x3)
	BRNE _0x4B
; 0000 0113                             tb3=0;
	CBI  0x12,6
; 0000 0114                          }
; 0000 0115                           if( hc05[so_tb] == 4){
_0x4B:
	CALL SUBOPT_0x2
	CPI  R26,LOW(0x4)
	BRNE _0x4E
; 0000 0116                             tb4=0;
	CBI  0x12,7
; 0000 0117                          }
; 0000 0118 
; 0000 0119                      }
_0x4E:
	LDS  R30,_so_tb
	SUBI R30,-LOW(1)
	STS  _so_tb,R30
	RJMP _0x3A
_0x3B:
; 0000 011A                     putchar(ki_tu_batdau);
	CALL SUBOPT_0x3
; 0000 011B                     putchar(7);    // datalen 07
; 0000 011C                     putchar(ma_lenh);
; 0000 011D                     putchar(trang_thai1);
; 0000 011E                     putchar(trang_thai2);
; 0000 011F                     putchar(trang_thai3);
; 0000 0120                     putchar(trang_thai4);
; 0000 0121                     ck=7+ma_lenh+trang_thai1+trang_thai2+trang_thai3+trang_thai4;
	RJMP _0x114
; 0000 0122                     putchar(0);
; 0000 0123                     putchar(ck);
; 0000 0124                 }
; 0000 0125                 else if(ma_lenh ==trang_thai_tb){
_0x38:
	__GETB2MN _hc05,2
	CPI  R26,LOW(0x2)
	BRNE _0x52
; 0000 0126                     putchar(ki_tu_batdau);
	CALL SUBOPT_0x3
; 0000 0127                     putchar(7);    // datalen 07
; 0000 0128                     putchar(ma_lenh);
; 0000 0129                     putchar(trang_thai1);
; 0000 012A                     putchar(trang_thai2);
; 0000 012B                     putchar(trang_thai3);
; 0000 012C                     putchar(trang_thai4);
; 0000 012D                     ck=7+ma_lenh+trang_thai1+trang_thai2+trang_thai3+trang_thai4;
	RJMP _0x114
; 0000 012E                     putchar(0);
; 0000 012F                     putchar(ck);
; 0000 0130                 }
; 0000 0131                 else if(ma_lenh==data_nhietdo){
_0x52:
	__GETB2MN _hc05,2
	CPI  R26,LOW(0x3)
	BRNE _0x54
; 0000 0132 
; 0000 0133                     putchar(ki_tu_batdau);
	LDI  R26,LOW(64)
	RCALL _putchar
; 0000 0134                     putchar(4);    // datalen
	LDI  R26,LOW(4)
	RCALL _putchar
; 0000 0135                     putchar(ma_lenh);
	__GETB2MN _hc05,2
	RCALL _putchar
; 0000 0136                     putchar(nhiet_do);
	MOV  R26,R10
	RCALL _putchar
; 0000 0137 
; 0000 0138 
; 0000 0139                     ck=4+ma_lenh+nhiet_do;
	__GETB1MN _hc05,2
	LDI  R31,0
	ADIW R30,4
	ADD  R30,R10
	ADC  R31,R11
_0x114:
	MOVW R12,R30
; 0000 013A                     putchar(0);
	LDI  R26,LOW(0)
	RCALL _putchar
; 0000 013B                     putchar(ck);
	MOV  R26,R12
	RCALL _putchar
; 0000 013C                 }
; 0000 013D 
; 0000 013E             }
_0x54:
; 0000 013F             ck=0;
_0x1B:
	CLR  R12
	CLR  R13
; 0000 0140             ki_tu=0;
	LDI  R30,LOW(0)
	STS  _ki_tu,R30
; 0000 0141          }
; 0000 0142 }
_0x1A:
	RET
; .FEND
;void hien_thi_chuoi(unsigned char data1, unsigned char data2, unsigned char data3,unsigned char ngay_gio,unsigned char c ...
;void hieuchinh_ngaygio(){
; 0000 0144 void hieuchinh_ngaygio(){
_hieuchinh_ngaygio:
; .FSTART _hieuchinh_ngaygio
; 0000 0145     //kiem tra hieu chinh gio_cd
; 0000 0146     if(gio_cd>100){  // do kieu du lieu khong dau unsigned char 0-1=255, chon so 100 la so dep
	LDS  R26,_gio_cd
	CPI  R26,LOW(0x65)
	BRLO _0x55
; 0000 0147         gio_cd=23;
	LDI  R30,LOW(23)
	RJMP _0x115
; 0000 0148     }
; 0000 0149     else if(gio_cd>23){
_0x55:
	LDS  R26,_gio_cd
	CPI  R26,LOW(0x18)
	BRLO _0x57
; 0000 014A         gio_cd=0;
	LDI  R30,LOW(0)
_0x115:
	STS  _gio_cd,R30
; 0000 014B     }
; 0000 014C     // kiem tra hieu chinh phut_cd
; 0000 014D     if(phut_cd>100){  // do kieu du lieu khong dau unsigned char 0-1=255, chon so 100 la so dep
_0x57:
	LDS  R26,_phut_cd
	CPI  R26,LOW(0x65)
	BRLO _0x58
; 0000 014E         phut_cd=59;
	LDI  R30,LOW(59)
	RJMP _0x116
; 0000 014F     }
; 0000 0150     else if(phut_cd>59){
_0x58:
	LDS  R26,_phut_cd
	CPI  R26,LOW(0x3C)
	BRLO _0x5A
; 0000 0151         phut_cd=0;
	LDI  R30,LOW(0)
_0x116:
	STS  _phut_cd,R30
; 0000 0152     }
; 0000 0153     // kiem tra hieu chinh giay_cd
; 0000 0154     if(giay_cd>100){  // do kieu du lieu khong dau unsigned char 0-1=255, chon so 100 la so dep
_0x5A:
	LDS  R26,_giay_cd
	CPI  R26,LOW(0x65)
	BRLO _0x5B
; 0000 0155         giay_cd=59;
	LDI  R30,LOW(59)
	RJMP _0x117
; 0000 0156     }
; 0000 0157     else if(giay_cd>59){
_0x5B:
	LDS  R26,_giay_cd
	CPI  R26,LOW(0x3C)
	BRLO _0x5D
; 0000 0158         giay_cd=0;
	LDI  R30,LOW(0)
_0x117:
	STS  _giay_cd,R30
; 0000 0159     }
; 0000 015A     // kiem tra hieu chinh ngay_cd
; 0000 015B     if(ngay_cd==0 || ngay_cd>100){
_0x5D:
	LDS  R26,_ngay_cd
	CPI  R26,LOW(0x0)
	BREQ _0x5F
	CPI  R26,LOW(0x65)
	BRLO _0x5E
_0x5F:
; 0000 015C         if(thang_cd==1 || thang_cd==3 || thang_cd==5 || thang_cd==7 || thang_cd==8 || thang_cd==10 || thang_cd==12 ){
	LDS  R26,_thang_cd
	CPI  R26,LOW(0x1)
	BREQ _0x62
	CPI  R26,LOW(0x3)
	BREQ _0x62
	CPI  R26,LOW(0x5)
	BREQ _0x62
	CPI  R26,LOW(0x7)
	BREQ _0x62
	CPI  R26,LOW(0x8)
	BREQ _0x62
	CPI  R26,LOW(0xA)
	BREQ _0x62
	CPI  R26,LOW(0xC)
	BRNE _0x61
_0x62:
; 0000 015D             ngay_cd=31;
	LDI  R30,LOW(31)
	RJMP _0x118
; 0000 015E         }
; 0000 015F         else if(thang_cd==4 || thang_cd==6 || thang_cd==9 || thang_cd==11){
_0x61:
	LDS  R26,_thang_cd
	CPI  R26,LOW(0x4)
	BREQ _0x66
	CPI  R26,LOW(0x6)
	BREQ _0x66
	CPI  R26,LOW(0x9)
	BREQ _0x66
	CPI  R26,LOW(0xB)
	BRNE _0x65
_0x66:
; 0000 0160             ngay_cd=30;
	LDI  R30,LOW(30)
	RJMP _0x118
; 0000 0161         }
; 0000 0162         else{
_0x65:
; 0000 0163             if(nam_cd%4 ==0){
	CALL SUBOPT_0x4
	BRNE _0x69
; 0000 0164                 ngay_cd=29;
	LDI  R30,LOW(29)
	RJMP _0x118
; 0000 0165             }
; 0000 0166             else{
_0x69:
; 0000 0167                 ngay_cd=28;
	LDI  R30,LOW(28)
_0x118:
	STS  _ngay_cd,R30
; 0000 0168             }
; 0000 0169         }
; 0000 016A     }
; 0000 016B 
; 0000 016C     //hieu chinh thang
; 0000 016D     if(thang_cd>12 && thang_cd<100){
_0x5E:
	LDS  R26,_thang_cd
	CPI  R26,LOW(0xD)
	BRLO _0x6C
	CPI  R26,LOW(0x64)
	BRLO _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
; 0000 016E         thang_cd=1;
	LDI  R30,LOW(1)
	RJMP _0x119
; 0000 016F     }
; 0000 0170     else if(thang_cd >100 || thang_cd ==0){
_0x6B:
	LDS  R26,_thang_cd
	CPI  R26,LOW(0x65)
	BRSH _0x70
	CPI  R26,LOW(0x0)
	BRNE _0x6F
_0x70:
; 0000 0171         thang_cd=12;
	LDI  R30,LOW(12)
_0x119:
	STS  _thang_cd,R30
; 0000 0172     }
; 0000 0173     //sau khi hieu chinh thang thi hieu chinh lai ngay
; 0000 0174     if(thang_cd==1 || thang_cd==3 || thang_cd==5 || thang_cd==7 || thang_cd==8 || thang_cd==10 || thang_cd==12 ){
_0x6F:
	LDS  R26,_thang_cd
	CPI  R26,LOW(0x1)
	BREQ _0x73
	CPI  R26,LOW(0x3)
	BREQ _0x73
	CPI  R26,LOW(0x5)
	BREQ _0x73
	CPI  R26,LOW(0x7)
	BREQ _0x73
	CPI  R26,LOW(0x8)
	BREQ _0x73
	CPI  R26,LOW(0xA)
	BREQ _0x73
	CPI  R26,LOW(0xC)
	BRNE _0x72
_0x73:
; 0000 0175         if(ngay_cd>31){
	LDS  R26,_ngay_cd
	CPI  R26,LOW(0x20)
	BRLO _0x75
; 0000 0176             ngay_cd=1;
	LDI  R30,LOW(1)
	STS  _ngay_cd,R30
; 0000 0177         }
; 0000 0178     }
_0x75:
; 0000 0179     else if(thang_cd==4 || thang_cd==6 || thang_cd==9 || thang_cd==11){
	RJMP _0x76
_0x72:
	LDS  R26,_thang_cd
	CPI  R26,LOW(0x4)
	BREQ _0x78
	CPI  R26,LOW(0x6)
	BREQ _0x78
	CPI  R26,LOW(0x9)
	BREQ _0x78
	CPI  R26,LOW(0xB)
	BRNE _0x77
_0x78:
; 0000 017A         if(ngay_cd>30){
	LDS  R26,_ngay_cd
	CPI  R26,LOW(0x1F)
	BRLO _0x7A
; 0000 017B             ngay_cd=1;
	LDI  R30,LOW(1)
	STS  _ngay_cd,R30
; 0000 017C         }
; 0000 017D     }
_0x7A:
; 0000 017E     else{
	RJMP _0x7B
_0x77:
; 0000 017F         if(nam_cd%4 ==0){
	CALL SUBOPT_0x4
	BRNE _0x7C
; 0000 0180             if(ngay_cd>29){
	LDS  R26,_ngay_cd
	CPI  R26,LOW(0x1E)
	BRLO _0x7D
; 0000 0181                 ngay_cd=1;
	LDI  R30,LOW(1)
	STS  _ngay_cd,R30
; 0000 0182             }
; 0000 0183         }
_0x7D:
; 0000 0184         else{
	RJMP _0x7E
_0x7C:
; 0000 0185             if(ngay_cd>28){
	LDS  R26,_ngay_cd
	CPI  R26,LOW(0x1D)
	BRLO _0x7F
; 0000 0186                 ngay_cd=1;
	LDI  R30,LOW(1)
	STS  _ngay_cd,R30
; 0000 0187             }
; 0000 0188         }
_0x7F:
_0x7E:
; 0000 0189     }
_0x7B:
_0x76:
; 0000 018A     //hieu chinh nam
; 0000 018B     if(nam_cd>150){
	LDS  R26,_nam_cd
	CPI  R26,LOW(0x97)
	BRLO _0x80
; 0000 018C         nam_cd=99;
	LDI  R30,LOW(99)
	RJMP _0x11A
; 0000 018D     }
; 0000 018E     else if(nam_cd>99){
_0x80:
	LDS  R26,_nam_cd
	CPI  R26,LOW(0x64)
	BRLO _0x82
; 0000 018F         nam_cd=0;
	LDI  R30,LOW(0)
_0x11A:
	STS  _nam_cd,R30
; 0000 0190     }
; 0000 0191 
; 0000 0192 
; 0000 0193 
; 0000 0194 }
_0x82:
	RET
; .FEND
;void xu_ly_nut(){
; 0000 0195 void xu_ly_nut(){
_xu_ly_nut:
; .FSTART _xu_ly_nut
; 0000 0196     unsigned char che_do, thu[6];
; 0000 0197     int hang=0;
; 0000 0198     unsigned char dem=0;
; 0000 0199     int check;
; 0000 019A     //bat con tro nhap nhay
; 0000 019B     if(nut_tang ==0 && nut_giam== 0 && nut_trai==1 && nut_phai ==1){
	SBIW R28,6
	CALL __SAVELOCR6
;	che_do -> R17
;	thu -> Y+6
;	hang -> R18,R19
;	dem -> R16
;	check -> R20,R21
	__GETWRN 18,19,0
	LDI  R16,0
	SBIC 0x19,3
	RJMP _0x84
	SBIC 0x19,2
	RJMP _0x84
	SBIS 0x19,1
	RJMP _0x84
	SBIC 0x19,0
	RJMP _0x85
_0x84:
	RJMP _0x83
_0x85:
; 0000 019C         che_do=1;
	LDI  R17,LOW(1)
; 0000 019D         while(che_do){
_0x86:
	CPI  R17,0
	BRNE PC+2
	RJMP _0x88
; 0000 019E             giaotiep_hc05();
	RCALL _giaotiep_hc05
; 0000 019F             if(nut_giam==0 && nut_tang==1 && nut_trai==1 && nut_phai ==1 && da_nhan_giam ==0){
	SBIC 0x19,2
	RJMP _0x8A
	SBIS 0x19,3
	RJMP _0x8A
	SBIS 0x19,1
	RJMP _0x8A
	SBIS 0x19,0
	RJMP _0x8A
	LDS  R26,_da_nhan_giam
	CPI  R26,LOW(0x0)
	BREQ _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
; 0000 01A0                 da_nhan_giam=1;
	LDI  R30,LOW(1)
	STS  _da_nhan_giam,R30
; 0000 01A1                 if(che_do==2){
	CPI  R17,2
	BRNE _0x8C
; 0000 01A2                     che_do--;
	SUBI R17,1
; 0000 01A3                 }
; 0000 01A4                 else if(che_do==1){
	RJMP _0x8D
_0x8C:
	CPI  R17,1
	BRNE _0x8E
; 0000 01A5                     che_do=2;
	LDI  R17,LOW(2)
; 0000 01A6                 }
; 0000 01A7             }
_0x8E:
_0x8D:
; 0000 01A8             if(nut_giam==1){
_0x89:
	SBIS 0x19,2
	RJMP _0x8F
; 0000 01A9                 da_nhan_giam=0;
	LDI  R30,LOW(0)
	STS  _da_nhan_giam,R30
; 0000 01AA             }
; 0000 01AB             if(nut_giam==1 && nut_tang==0 && nut_trai==1 && nut_phai ==1 && da_nhan_tang ==0){
_0x8F:
	SBIS 0x19,2
	RJMP _0x91
	SBIC 0x19,3
	RJMP _0x91
	SBIS 0x19,1
	RJMP _0x91
	SBIS 0x19,0
	RJMP _0x91
	LDS  R26,_da_nhan_tang
	CPI  R26,LOW(0x0)
	BREQ _0x92
_0x91:
	RJMP _0x90
_0x92:
; 0000 01AC                 da_nhan_tang=1;
	LDI  R30,LOW(1)
	STS  _da_nhan_tang,R30
; 0000 01AD                 if(che_do==1){
	CPI  R17,1
	BRNE _0x93
; 0000 01AE                     che_do++;
	SUBI R17,-1
; 0000 01AF                 }
; 0000 01B0                 else if(che_do==2){
	RJMP _0x94
_0x93:
	CPI  R17,2
	BRNE _0x95
; 0000 01B1                     che_do=1;
	LDI  R17,LOW(1)
; 0000 01B2                 }
; 0000 01B3             }
_0x95:
_0x94:
; 0000 01B4             if(nut_tang==1){
_0x90:
	SBIS 0x19,3
	RJMP _0x96
; 0000 01B5                 da_nhan_tang=0;
	LDI  R30,LOW(0)
	STS  _da_nhan_tang,R30
; 0000 01B6             }
; 0000 01B7             switch(che_do){
_0x96:
	MOV  R30,R17
	LDI  R31,0
; 0000 01B8                 case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9A
; 0000 01B9                 lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
; 0000 01BA                 lcd_puts("=>    CAI DAT GIO   ");
	__POINTW2MN _0x9B,0
	CALL SUBOPT_0x6
; 0000 01BB                 lcd_gotoxy(0,1);
; 0000 01BC                 lcd_puts("      CAI DAT NGAY  ");
	__POINTW2MN _0x9B,21
	RJMP _0x11B
; 0000 01BD                 break;
; 0000 01BE                 case 2:
_0x9A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x99
; 0000 01BF                 lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
; 0000 01C0                 lcd_puts("      CAI DAT GIO   ");
	__POINTW2MN _0x9B,42
	CALL SUBOPT_0x6
; 0000 01C1                 lcd_gotoxy(0,1);
; 0000 01C2                 lcd_puts("=>    CAI DAT NGAY  ");
	__POINTW2MN _0x9B,63
_0x11B:
	CALL _lcd_puts
; 0000 01C3                 break;
; 0000 01C4             }
_0x99:
; 0000 01C5             // thoat che do cai dat
; 0000 01C6             if(nut_tang ==1 && nut_giam== 1 && nut_trai==0 && nut_phai ==0){
	SBIS 0x19,3
	RJMP _0x9E
	SBIS 0x19,2
	RJMP _0x9E
	SBIC 0x19,1
	RJMP _0x9E
	SBIS 0x19,0
	RJMP _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
; 0000 01C7                 che_do=0;
	LDI  R17,LOW(0)
; 0000 01C8             }
; 0000 01C9             //vao cai dat theo che_do da lua chon
; 0000 01CA             if(nut_tang ==0 && nut_giam== 1 && nut_trai==0 && nut_phai ==1){
_0x9D:
	SBIC 0x19,3
	RJMP _0xA1
	SBIS 0x19,2
	RJMP _0xA1
	SBIC 0x19,1
	RJMP _0xA1
	SBIC 0x19,0
	RJMP _0xA2
_0xA1:
	RJMP _0xA0
_0xA2:
; 0000 01CB                goto cai_dat;
	RJMP _0xA3
; 0000 01CC             }
; 0000 01CD         }
_0xA0:
	RJMP _0x86
_0x88:
; 0000 01CE         cai_dat:
_0xA3:
; 0000 01CF         //che_do=1;
; 0000 01D0         if(che_do != 0 ){
	CPI  R17,0
	BREQ _0xA4
; 0000 01D1         den_bao=0;
	CBI  0x1B,7
; 0000 01D2         vi_tri_cai_dat=0;
	LDI  R30,LOW(0)
	STS  _vi_tri_cai_dat,R30
; 0000 01D3         if(che_do==1){
	CPI  R17,1
	BRNE _0xA7
; 0000 01D4              rtc_get_time(&gio_cd,&phut_cd,&giay_cd);
	LDI  R30,LOW(_gio_cd)
	LDI  R31,HIGH(_gio_cd)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_phut_cd)
	LDI  R31,HIGH(_phut_cd)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_giay_cd)
	LDI  R27,HIGH(_giay_cd)
	CALL _rtc_get_time
; 0000 01D5              lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
; 0000 01D6              lcd_puts("    CAI DAT GIO     ");
	__POINTW2MN _0x9B,84
	CALL _lcd_puts
; 0000 01D7              hien_thi_chuoi(gio_cd,phut_cd,giay_cd,0,0,1);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 01D8              lcd_gotoxy(5,1);
; 0000 01D9              _lcd_write_data(0x0F);  // nhap nhay con tro
; 0000 01DA         }
; 0000 01DB         if(che_do==2){
_0xA7:
	CPI  R17,2
	BRNE _0xA8
; 0000 01DC             rtc_get_date(&thu_cd, &ngay_cd,&thang_cd,&nam_cd);
	LDI  R30,LOW(_thu_cd)
	LDI  R31,HIGH(_thu_cd)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ngay_cd)
	LDI  R31,HIGH(_ngay_cd)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_thang_cd)
	LDI  R31,HIGH(_thang_cd)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_nam_cd)
	LDI  R27,HIGH(_nam_cd)
	CALL _rtc_get_date
; 0000 01DD             lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
; 0000 01DE             lcd_puts("    CAI DAT NGAY    ");
	__POINTW2MN _0x9B,105
	CALL _lcd_puts
; 0000 01DF             hien_thi_chuoi(ngay_cd,thang_cd,nam_cd,1,0,1);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x8
; 0000 01E0             lcd_gotoxy(5,1);
; 0000 01E1             _lcd_write_data(0x0F);
; 0000 01E2         }
; 0000 01E3 
; 0000 01E4         }
_0xA8:
; 0000 01E5 
; 0000 01E6     }
_0xA4:
; 0000 01E7     //vao che de cai dat ngay va gio
; 0000 01E8     while(che_do){
_0x83:
_0xA9:
	CPI  R17,0
	BRNE PC+2
	RJMP _0xAB
; 0000 01E9          giaotiep_hc05();
	RCALL _giaotiep_hc05
; 0000 01EA         // nhan nut qua phai
; 0000 01EB     {
; 0000 01EC         if(nut_tang ==1 && nut_giam==1 && nut_trai==1 && nut_phai==0 && da_nhan_phai==0){
	SBIS 0x19,3
	RJMP _0xAD
	SBIS 0x19,2
	RJMP _0xAD
	SBIS 0x19,1
	RJMP _0xAD
	SBIC 0x19,0
	RJMP _0xAD
	LDS  R26,_da_nhan_phai
	CPI  R26,LOW(0x0)
	BREQ _0xAE
_0xAD:
	RJMP _0xAC
_0xAE:
; 0000 01ED             vi_tri_cai_dat++;
	LDS  R30,_vi_tri_cai_dat
	SUBI R30,-LOW(1)
	STS  _vi_tri_cai_dat,R30
; 0000 01EE             if(vi_tri_cai_dat>5){
	LDS  R26,_vi_tri_cai_dat
	CPI  R26,LOW(0x6)
	BRLO _0xAF
; 0000 01EF                 vi_tri_cai_dat=0;
	LDI  R30,LOW(0)
	STS  _vi_tri_cai_dat,R30
; 0000 01F0 
; 0000 01F1 
; 0000 01F2             }
; 0000 01F3             lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
_0xAF:
	CALL SUBOPT_0xA
; 0000 01F4               da_nhan_phai=1;
	STS  _da_nhan_phai,R30
; 0000 01F5 
; 0000 01F6 
; 0000 01F7         }
; 0000 01F8         if(nut_phai==1){
_0xAC:
	SBIS 0x19,0
	RJMP _0xB0
; 0000 01F9             da_nhan_phai=0;
	LDI  R30,LOW(0)
	STS  _da_nhan_phai,R30
; 0000 01FA         }
; 0000 01FB     }
_0xB0:
; 0000 01FC         // nhan nut qua trai
; 0000 01FD     {
; 0000 01FE          if(nut_tang ==1 && nut_giam==1 && nut_trai==0 && nut_phai==1 && da_nhan_trai==0){
	SBIS 0x19,3
	RJMP _0xB2
	SBIS 0x19,2
	RJMP _0xB2
	SBIC 0x19,1
	RJMP _0xB2
	SBIS 0x19,0
	RJMP _0xB2
	LDS  R26,_da_nhan_trai
	CPI  R26,LOW(0x0)
	BREQ _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
; 0000 01FF             vi_tri_cai_dat--;
	LDS  R30,_vi_tri_cai_dat
	SUBI R30,LOW(1)
	STS  _vi_tri_cai_dat,R30
; 0000 0200 
; 0000 0201 
; 0000 0202             if(vi_tri_cai_dat > 5 ){
	LDS  R26,_vi_tri_cai_dat
	CPI  R26,LOW(0x6)
	BRLO _0xB4
; 0000 0203                 vi_tri_cai_dat=5;
	LDI  R30,LOW(5)
	STS  _vi_tri_cai_dat,R30
; 0000 0204 
; 0000 0205 
; 0000 0206             }
; 0000 0207             lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
_0xB4:
	CALL SUBOPT_0xA
; 0000 0208             da_nhan_trai=1;
	STS  _da_nhan_trai,R30
; 0000 0209 
; 0000 020A 
; 0000 020B         }
; 0000 020C         if(nut_trai==1){
_0xB1:
	SBIS 0x19,1
	RJMP _0xB5
; 0000 020D             da_nhan_trai=0;
	LDI  R30,LOW(0)
	STS  _da_nhan_trai,R30
; 0000 020E         }
; 0000 020F     }
_0xB5:
; 0000 0210     // nhan nut tang
; 0000 0211     if(nut_tang ==0 && nut_giam==1 && nut_trai==1 && nut_phai==1 && da_nhan_tang==0 ){
	SBIC 0x19,3
	RJMP _0xB7
	SBIS 0x19,2
	RJMP _0xB7
	SBIS 0x19,1
	RJMP _0xB7
	SBIS 0x19,0
	RJMP _0xB7
	LDS  R26,_da_nhan_tang
	CPI  R26,LOW(0x0)
	BREQ _0xB8
_0xB7:
	RJMP _0xB6
_0xB8:
; 0000 0212              dem++;
	SUBI R16,-1
; 0000 0213 
; 0000 0214         if(che_do==1){
	CPI  R17,1
	BRNE _0xB9
; 0000 0215             switch(vi_tri_cai_dat){
	CALL SUBOPT_0xB
; 0000 0216              case 0:
	BRNE _0xBD
; 0000 0217                  gio_cd=gio_cd+10;
	LDS  R30,_gio_cd
	SUBI R30,-LOW(10)
	STS  _gio_cd,R30
; 0000 0218              break;
	RJMP _0xBC
; 0000 0219              case 1:
_0xBD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xBE
; 0000 021A                  gio_cd++;
	LDS  R30,_gio_cd
	SUBI R30,-LOW(1)
	STS  _gio_cd,R30
; 0000 021B              break;
	RJMP _0xBC
; 0000 021C              case 2:
_0xBE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBF
; 0000 021D                  phut_cd=phut_cd+10;
	LDS  R30,_phut_cd
	SUBI R30,-LOW(10)
	STS  _phut_cd,R30
; 0000 021E              break;
	RJMP _0xBC
; 0000 021F              case 3:
_0xBF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC0
; 0000 0220                  phut_cd++;
	LDS  R30,_phut_cd
	SUBI R30,-LOW(1)
	STS  _phut_cd,R30
; 0000 0221              break;
	RJMP _0xBC
; 0000 0222              case 4:
_0xC0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC1
; 0000 0223                  giay_cd=giay_cd+10;
	LDS  R30,_giay_cd
	SUBI R30,-LOW(10)
	RJMP _0x11C
; 0000 0224              break;
; 0000 0225              case 5:
_0xC1:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xBC
; 0000 0226                  giay_cd++;
	LDS  R30,_giay_cd
	SUBI R30,-LOW(1)
_0x11C:
	STS  _giay_cd,R30
; 0000 0227              break;
; 0000 0228 
; 0000 0229             }
_0xBC:
; 0000 022A         }
; 0000 022B         else if(che_do==2){
	RJMP _0xC3
_0xB9:
	CPI  R17,2
	BRNE _0xC4
; 0000 022C             // tang cho hang 2: ngay, thang, nam
; 0000 022D             switch (vi_tri_cai_dat){
	CALL SUBOPT_0xB
; 0000 022E             case 0:
	BRNE _0xC8
; 0000 022F             ngay_cd=ngay_cd+10;
	LDS  R30,_ngay_cd
	SUBI R30,-LOW(10)
	STS  _ngay_cd,R30
; 0000 0230              break;
	RJMP _0xC7
; 0000 0231              case 1 :
_0xC8:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC9
; 0000 0232                  ngay_cd++;
	LDS  R30,_ngay_cd
	SUBI R30,-LOW(1)
	STS  _ngay_cd,R30
; 0000 0233              break;
	RJMP _0xC7
; 0000 0234              case 2:
_0xC9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCA
; 0000 0235                  thang_cd=thang_cd+10;
	LDS  R30,_thang_cd
	SUBI R30,-LOW(10)
	STS  _thang_cd,R30
; 0000 0236              break;
	RJMP _0xC7
; 0000 0237              case 3:
_0xCA:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xCB
; 0000 0238                  thang_cd++;
	LDS  R30,_thang_cd
	SUBI R30,-LOW(1)
	STS  _thang_cd,R30
; 0000 0239              break;
	RJMP _0xC7
; 0000 023A              case 4:
_0xCB:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xCC
; 0000 023B                  nam_cd=nam_cd+10;
	LDS  R30,_nam_cd
	SUBI R30,-LOW(10)
	RJMP _0x11D
; 0000 023C              break;
; 0000 023D              case 5:
_0xCC:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC7
; 0000 023E                  nam_cd++;
	LDS  R30,_nam_cd
	SUBI R30,-LOW(1)
_0x11D:
	STS  _nam_cd,R30
; 0000 023F              break;
; 0000 0240             }
_0xC7:
; 0000 0241 
; 0000 0242 
; 0000 0243 
; 0000 0244              }
; 0000 0245 
; 0000 0246 
; 0000 0247 
; 0000 0248             da_nhan_tang=1;
_0xC4:
_0xC3:
	LDI  R30,LOW(1)
	STS  _da_nhan_tang,R30
; 0000 0249             //hieu chinh ngay gio
; 0000 024A             hieuchinh_ngaygio();
	RCALL _hieuchinh_ngaygio
; 0000 024B 
; 0000 024C             if(che_do==1){
	CPI  R17,1
	BRNE _0xCE
; 0000 024D                 hien_thi_chuoi(gio_cd,phut_cd,giay_cd,0,0,1);
	CALL SUBOPT_0x7
	RJMP _0x11E
; 0000 024E 
; 0000 024F                 lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
; 0000 0250             }
; 0000 0251             else if(che_do==2){
_0xCE:
	CPI  R17,2
	BRNE _0xD0
; 0000 0252                 hien_thi_chuoi(ngay_cd,thang_cd,nam_cd,1,0,1);
	CALL SUBOPT_0x9
_0x11E:
	ST   -Y,R30
	CALL SUBOPT_0xC
; 0000 0253 
; 0000 0254                 lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
; 0000 0255             }
; 0000 0256 
; 0000 0257    }
_0xD0:
; 0000 0258 
; 0000 0259 
; 0000 025A 
; 0000 025B 
; 0000 025C         if(nut_tang==1){
_0xB6:
	SBIS 0x19,3
	RJMP _0xD1
; 0000 025D             da_nhan_tang=0;
	LDI  R30,LOW(0)
	STS  _da_nhan_tang,R30
; 0000 025E         }
; 0000 025F 
; 0000 0260         // nhan nut giam
; 0000 0261         if(nut_tang ==1 && nut_giam==0 && nut_trai==1 && nut_phai==1 && da_nhan_giam==0 ){
_0xD1:
	SBIS 0x19,3
	RJMP _0xD3
	SBIC 0x19,2
	RJMP _0xD3
	SBIS 0x19,1
	RJMP _0xD3
	SBIS 0x19,0
	RJMP _0xD3
	LDS  R26,_da_nhan_giam
	CPI  R26,LOW(0x0)
	BREQ _0xD4
_0xD3:
	RJMP _0xD2
_0xD4:
; 0000 0262              if(che_do==1){
	CPI  R17,1
	BRNE _0xD5
; 0000 0263                 switch(vi_tri_cai_dat){
	CALL SUBOPT_0xB
; 0000 0264                      case 0:
	BRNE _0xD9
; 0000 0265                          gio_cd=gio_cd-10;
	LDS  R30,_gio_cd
	SUBI R30,LOW(10)
	STS  _gio_cd,R30
; 0000 0266                      break;
	RJMP _0xD8
; 0000 0267                      case 1:
_0xD9:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xDA
; 0000 0268                          gio_cd--;
	LDS  R30,_gio_cd
	SUBI R30,LOW(1)
	STS  _gio_cd,R30
; 0000 0269                      break;
	RJMP _0xD8
; 0000 026A                      case 2:
_0xDA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xDB
; 0000 026B                          phut_cd=phut_cd-10;
	LDS  R30,_phut_cd
	SUBI R30,LOW(10)
	STS  _phut_cd,R30
; 0000 026C                      break;
	RJMP _0xD8
; 0000 026D                      case 3:
_0xDB:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xDC
; 0000 026E                          phut_cd--;
	LDS  R30,_phut_cd
	SUBI R30,LOW(1)
	STS  _phut_cd,R30
; 0000 026F                      break;
	RJMP _0xD8
; 0000 0270                      case 4:
_0xDC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xDD
; 0000 0271                          giay_cd=giay_cd-10;
	LDS  R30,_giay_cd
	SUBI R30,LOW(10)
	RJMP _0x11F
; 0000 0272                      break;
; 0000 0273                      case 5:
_0xDD:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xD8
; 0000 0274                          giay_cd--;
	LDS  R30,_giay_cd
	SUBI R30,LOW(1)
_0x11F:
	STS  _giay_cd,R30
; 0000 0275                      break;
; 0000 0276                 }
_0xD8:
; 0000 0277              }
; 0000 0278              // tang cho hang 2: ngay, thang, nam
; 0000 0279              if(che_do==2){
_0xD5:
	CPI  R17,2
	BRNE _0xDF
; 0000 027A                 switch(vi_tri_cai_dat){
	CALL SUBOPT_0xB
; 0000 027B                     case 0:
	BRNE _0xE3
; 0000 027C                     ngay_cd=ngay_cd-10;
	LDS  R30,_ngay_cd
	SUBI R30,LOW(10)
	STS  _ngay_cd,R30
; 0000 027D                     break;
	RJMP _0xE2
; 0000 027E                     case 1 :
_0xE3:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE4
; 0000 027F                     ngay_cd--;
	LDS  R30,_ngay_cd
	SUBI R30,LOW(1)
	STS  _ngay_cd,R30
; 0000 0280                     break;
	RJMP _0xE2
; 0000 0281                     case 2:
_0xE4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0282                     thang_cd=thang_cd-10;
	LDS  R30,_thang_cd
	SUBI R30,LOW(10)
	STS  _thang_cd,R30
; 0000 0283                     break;
	RJMP _0xE2
; 0000 0284                     case 3:
_0xE5:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0285                     thang_cd--;
	LDS  R30,_thang_cd
	SUBI R30,LOW(1)
	STS  _thang_cd,R30
; 0000 0286                     break;
	RJMP _0xE2
; 0000 0287                     case 4:
_0xE6:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0288                     nam_cd=nam_cd-10;
	LDS  R30,_nam_cd
	SUBI R30,LOW(10)
	RJMP _0x120
; 0000 0289                     break;
; 0000 028A                     case 5:
_0xE7:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xE2
; 0000 028B                     nam_cd--;
	LDS  R30,_nam_cd
	SUBI R30,LOW(1)
_0x120:
	STS  _nam_cd,R30
; 0000 028C                     break;
; 0000 028D 
; 0000 028E                 }
_0xE2:
; 0000 028F              }
; 0000 0290 
; 0000 0291 
; 0000 0292 
; 0000 0293 
; 0000 0294 
; 0000 0295 
; 0000 0296             da_nhan_giam=1;
_0xDF:
	LDI  R30,LOW(1)
	STS  _da_nhan_giam,R30
; 0000 0297 
; 0000 0298             hieuchinh_ngaygio();
	RCALL _hieuchinh_ngaygio
; 0000 0299             if(che_do==1){
	CPI  R17,1
	BRNE _0xE9
; 0000 029A                 hien_thi_chuoi(gio_cd,phut_cd,giay_cd,0,0,1);
	CALL SUBOPT_0x7
	RJMP _0x121
; 0000 029B 
; 0000 029C                 lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
; 0000 029D             }
; 0000 029E             else if(che_do==2){
_0xE9:
	CPI  R17,2
	BRNE _0xEB
; 0000 029F                 hien_thi_chuoi(ngay_cd,thang_cd,nam_cd,1,0,1);
	CALL SUBOPT_0x9
_0x121:
	ST   -Y,R30
	CALL SUBOPT_0xC
; 0000 02A0 
; 0000 02A1                 lcd_gotoxy(vi_tri[vi_tri_cai_dat],1);
; 0000 02A2             }
; 0000 02A3 
; 0000 02A4 
; 0000 02A5 
; 0000 02A6 
; 0000 02A7 
; 0000 02A8         }
_0xEB:
; 0000 02A9 
; 0000 02AA         if(nut_giam==1){
_0xD2:
	SBIS 0x19,2
	RJMP _0xEC
; 0000 02AB             da_nhan_giam=0;
	LDI  R30,LOW(0)
	STS  _da_nhan_giam,R30
; 0000 02AC         }
; 0000 02AD 
; 0000 02AE         //luu va thoat che do cai dat
; 0000 02AF         if(nut_tang ==1 && nut_giam==1 && nut_trai==0 && nut_phai==0 ){
_0xEC:
	SBIS 0x19,3
	RJMP _0xEE
	SBIS 0x19,2
	RJMP _0xEE
	SBIC 0x19,1
	RJMP _0xEE
	SBIS 0x19,0
	RJMP _0xEF
_0xEE:
	RJMP _0xED
_0xEF:
; 0000 02B0             _lcd_write_data(0x0C);
	LDI  R26,LOW(12)
	CALL __lcd_write_data
; 0000 02B1             if(che_do==1){
	CPI  R17,1
	BRNE _0xF0
; 0000 02B2                 rtc_set_time(gio_cd,phut_cd,giay_cd);
	LDS  R30,_gio_cd
	ST   -Y,R30
	LDS  R30,_phut_cd
	ST   -Y,R30
	LDS  R26,_giay_cd
	CALL _rtc_set_time
; 0000 02B3 
; 0000 02B4             }
; 0000 02B5             else if(che_do==2){
	RJMP _0xF1
_0xF0:
	CPI  R17,2
	BRNE _0xF2
; 0000 02B6                  rtc_set_date(thu_cd, ngay_cd,thang_cd,nam_cd);
	LDS  R30,_thu_cd
	ST   -Y,R30
	LDS  R30,_ngay_cd
	ST   -Y,R30
	LDS  R30,_thang_cd
	ST   -Y,R30
	LDS  R26,_nam_cd
	CALL _rtc_set_date
; 0000 02B7 
; 0000 02B8             }
; 0000 02B9 
; 0000 02BA             che_do=0;
_0xF2:
_0xF1:
	LDI  R17,LOW(0)
; 0000 02BB             den_bao=1;
	SBI  0x1B,7
; 0000 02BC 
; 0000 02BD 
; 0000 02BE         }
; 0000 02BF        //thoat va khong luu
; 0000 02C0         if(nut_trai==0 && nut_giam==0 && nut_phai==1 && nut_tang==1){
_0xED:
	SBIC 0x19,1
	RJMP _0xF6
	SBIC 0x19,2
	RJMP _0xF6
	SBIS 0x19,0
	RJMP _0xF6
	SBIC 0x19,3
	RJMP _0xF7
_0xF6:
	RJMP _0xF5
_0xF7:
; 0000 02C1             _lcd_write_data(0x0C);
	LDI  R26,LOW(12)
	CALL __lcd_write_data
; 0000 02C2 
; 0000 02C3             che_do=0;
	LDI  R17,LOW(0)
; 0000 02C4             den_bao=1;
	SBI  0x1B,7
; 0000 02C5 
; 0000 02C6         }
; 0000 02C7     }
_0xF5:
	RJMP _0xA9
_0xAB:
; 0000 02C8 }
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND

	.DSEG
_0x9B:
	.BYTE 0x7E
;void hien_thi_chuoi(unsigned char data1, unsigned char data2, unsigned char data3,unsigned char ngay_gio, unsigned char  ...
; 0000 02C9 void hien_thi_chuoi(unsigned char data1, unsigned char data2, unsigned char data3,unsigned char ngay_gio, unsigned char cot, unsigned char hang ){

	.CSEG
_hien_thi_chuoi:
; .FSTART _hien_thi_chuoi
; 0000 02CA 
; 0000 02CB 
; 0000 02CC       if(ngay_gio ==0){
	ST   -Y,R26
;	data1 -> Y+5
;	data2 -> Y+4
;	data3 -> Y+3
;	ngay_gio -> Y+2
;	cot -> Y+1
;	hang -> Y+0
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0xFA
; 0000 02CD           /*
; 0000 02CE           if(data1>9){
; 0000 02CF             sprintf(chuoi1,"%u:",data1);
; 0000 02D0           }
; 0000 02D1           else{
; 0000 02D2             sprintf(chuoi1,"0%u:",data1);
; 0000 02D3           }
; 0000 02D4           if(data2>9){
; 0000 02D5            sprintf(chuoi2,"%u:",data2);
; 0000 02D6           }
; 0000 02D7           else{
; 0000 02D8             sprintf(chuoi2,"0%u:",data2);
; 0000 02D9           }
; 0000 02DA           if(data3>9){
; 0000 02DB             sprintf(chuoi3,"%u",data3);
; 0000 02DC           }
; 0000 02DD           else{
; 0000 02DE             sprintf(chuoi3,"0%u",data3);
; 0000 02DF           }
; 0000 02E0           */
; 0000 02E1            sprintf(chuoi,"     %2.2u:%2.2u:%2.2u      ",data1,data2,data3);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,126
	RJMP _0x122
; 0000 02E2            /*sprintf(chuoi2,"%2.2u:",data2);
; 0000 02E3            sprintf(chuoi3,"%2.2u",data3);*/
; 0000 02E4       }
; 0000 02E5        else{
_0xFA:
; 0000 02E6        /*
; 0000 02E7           if(data1>9){
; 0000 02E8             sprintf(chuoi1,"%u/",data1);
; 0000 02E9           }
; 0000 02EA           else{
; 0000 02EB             sprintf(chuoi1,"0%u/",data1);
; 0000 02EC           }
; 0000 02ED           if(data2>9){
; 0000 02EE             sprintf(chuoi2,"%u/",data2);
; 0000 02EF           }
; 0000 02F0           else{
; 0000 02F1             sprintf(chuoi2,"0%u/",data2);
; 0000 02F2           }
; 0000 02F3           if(data3>9){
; 0000 02F4             sprintf(chuoi3,"%u",data3);
; 0000 02F5           }
; 0000 02F6           else{
; 0000 02F7             sprintf(chuoi3,"0%u",data3);
; 0000 02F8           }*/
; 0000 02F9           sprintf(chuoi,"     %2.2u/%2.2u/%2.2u       ",data1,data2,data3);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,155
_0x122:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+9
	CALL SUBOPT_0xE
	LDD  R30,Y+12
	CALL SUBOPT_0xE
	LDD  R30,Y+15
	CALL SUBOPT_0xE
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 02FA       }
; 0000 02FB      // sprintf(chuoi,"     %s%s%s     ",chuoi1,chuoi2,chuoi3);
; 0000 02FC       lcd_gotoxy(cot,hang);
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	CALL SUBOPT_0xF
; 0000 02FD       lcd_puts(chuoi);
; 0000 02FE }
	JMP  _0x2100006
; .FEND
;void kiem_tra_nut_nhan(int thoi_gian){
; 0000 02FF void kiem_tra_nut_nhan(int thoi_gian){
_kiem_tra_nut_nhan:
; .FSTART _kiem_tra_nut_nhan
; 0000 0300       int time;
; 0000 0301       for(time=0;time<thoi_gian;time++){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	thoi_gian -> Y+2
;	time -> R16,R17
	__GETWRN 16,17,0
_0xFD:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0xFE
; 0000 0302         giaotiep_hc05();
	RCALL _giaotiep_hc05
; 0000 0303         xu_ly_nut();
	RCALL _xu_ly_nut
; 0000 0304         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0305       }
	__ADDWRN 16,17,1
	RJMP _0xFD
_0xFE:
; 0000 0306 
; 0000 0307 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;
;
;
;
;// Declare your global variables here
;
;unsigned int adc_data;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0315 {
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R30
	ST   -Y,R31
; 0000 0316 // Read the AD conversion result
; 0000 0317 adc_data=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	STS  _adc_data,R30
	STS  _adc_data+1,R31
; 0000 0318 }
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc(unsigned char adc_input)
; 0000 031D {
_read_adc:
; .FSTART _read_adc
; 0000 031E ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 031F // Delay needed for the stabilization of the ADC input voltage
; 0000 0320 delay_us(10);
	__DELAY_USB 27
; 0000 0321 #asm
; 0000 0322     in   r30,mcucr
    in   r30,mcucr
; 0000 0323     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
; 0000 0324     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0325     out  mcucr,r30
    out  mcucr,r30
; 0000 0326     sleep
    sleep
; 0000 0327     cbr  r30,__se_bit
    cbr  r30,__se_bit
; 0000 0328     out  mcucr,r30
    out  mcucr,r30
; 0000 0329 #endasm
; 0000 032A return adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
_0x2100009:
	ADIW R28,1
	RET
; 0000 032B 
; 0000 032C }
; .FEND
;void hienthi_nhietdo(){
; 0000 032D void hienthi_nhietdo(){
_hienthi_nhietdo:
; .FSTART _hienthi_nhietdo
; 0000 032E      nhiet_do=read_adc(6);
	LDI  R26,LOW(6)
	RCALL _read_adc
	MOVW R10,R30
; 0000 032F        nhiet_do=500/1024.0*nhiet_do;
	CALL SUBOPT_0x10
	__GETD2N 0x3EFA0000
	CALL __MULF12
	CALL __CFD1
	MOVW R10,R30
; 0000 0330     if(nhiet_do>9){
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0xFF
; 0000 0331         sprintf(chuoi,"nhiet do:%d",nhiet_do);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,185
	RJMP _0x123
; 0000 0332     }
; 0000 0333     else{
_0xFF:
; 0000 0334         sprintf(chuoi,"nhiet do:%d ",nhiet_do);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,197
_0x123:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0335     }
; 0000 0336 
; 0000 0337     test[3]=nhiet_do;
	__POINTW1MN _test,6
	ST   Z,R10
	STD  Z+1,R11
; 0000 0338     lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
; 0000 0339     lcd_puts("  do an hoc phan 2");
	__POINTW2MN _0x101,0
	CALL _lcd_puts
; 0000 033A     lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0xF
; 0000 033B 
; 0000 033C     lcd_puts(chuoi);
; 0000 033D }
	RET
; .FEND

	.DSEG
_0x101:
	.BYTE 0x13
;
;void main(void)
; 0000 0340 {

	.CSEG
_main:
; .FSTART _main
; 0000 0341 {
; 0000 0342 // Declare your local variables here
; 0000 0343 
; 0000 0344 // Input/Output Ports initialization
; 0000 0345 // Port A initialization
; 0000 0346 // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0347 DDRA=(1<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(128)
	OUT  0x1A,R30
; 0000 0348 // State: Bit7=1 Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0349 PORTA=(1<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 034A 
; 0000 034B // Port B initialization
; 0000 034C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 034D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 034E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 034F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0350 
; 0000 0351 // Port C initialization
; 0000 0352 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0353 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0354 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0355 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0356 
; 0000 0357 // Port D initialization
; 0000 0358 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0359 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 035A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 035B PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 035C 
; 0000 035D // Timer/Counter 0 initialization
; 0000 035E // Clock source: System Clock
; 0000 035F // Clock value: Timer 0 Stopped
; 0000 0360 // Mode: Normal top=0xFF
; 0000 0361 // OC0 output: Disconnected
; 0000 0362 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0363 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0364 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0365 
; 0000 0366 // Timer/Counter 1 initialization
; 0000 0367 // Clock source: System Clock
; 0000 0368 // Clock value: Timer1 Stopped
; 0000 0369 // Mode: Normal top=0xFFFF
; 0000 036A // OC1A output: Disconnected
; 0000 036B // OC1B output: Disconnected
; 0000 036C // Noise Canceler: Off
; 0000 036D // Input Capture on Falling Edge
; 0000 036E // Timer1 Overflow Interrupt: Off
; 0000 036F // Input Capture Interrupt: Off
; 0000 0370 // Compare A Match Interrupt: Off
; 0000 0371 // Compare B Match Interrupt: Off
; 0000 0372 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0373 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0374 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0375 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0376 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0377 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0378 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0379 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 037A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 037B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 037C 
; 0000 037D // Timer/Counter 2 initialization
; 0000 037E // Clock source: System Clock
; 0000 037F // Clock value: Timer2 Stopped
; 0000 0380 // Mode: Normal top=0xFF
; 0000 0381 // OC2 output: Disconnected
; 0000 0382 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0383 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0384 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0385 OCR2=0x00;
	OUT  0x23,R30
; 0000 0386 
; 0000 0387 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0388 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0389 
; 0000 038A // External Interrupt(s) initialization
; 0000 038B // INT0: Off
; 0000 038C // INT1: Off
; 0000 038D // INT2: Off
; 0000 038E MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 038F MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0390 
; 0000 0391 // USART initialization
; 0000 0392 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0393 // USART Receiver: On
; 0000 0394 // USART Transmitter: On
; 0000 0395 // USART Mode: Asynchronous
; 0000 0396 // USART Baud Rate: 9600
; 0000 0397 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0398 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0399 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 039A UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 039B UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 039C 
; 0000 039D // Analog Comparator initialization
; 0000 039E // Analog Comparator: Off
; 0000 039F // The Analog Comparator's positive input is
; 0000 03A0 // connected to the AIN0 pin
; 0000 03A1 // The Analog Comparator's negative input is
; 0000 03A2 // connected to the AIN1 pin
; 0000 03A3 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 03A4 
; 0000 03A5 // ADC initialization
; 0000 03A6 // ADC Clock frequency: 500.000 kHz
; 0000 03A7 // ADC Voltage Reference: AVCC pin
; 0000 03A8 // ADC Auto Trigger Source: ADC Stopped
; 0000 03A9 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 03AA ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0000 03AB SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 03AC 
; 0000 03AD // SPI initialization
; 0000 03AE // SPI disabled
; 0000 03AF SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 03B0 
; 0000 03B1 // TWI initialization
; 0000 03B2 // TWI disabled
; 0000 03B3 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 03B4 
; 0000 03B5 // Bit-Banged I2C Bus initialization
; 0000 03B6 // I2C Port: PORTD
; 0000 03B7 // I2C SDA bit: 3
; 0000 03B8 // I2C SCL bit: 2
; 0000 03B9 // Bit Rate: 100 kHz
; 0000 03BA // Note: I2C settings are specified in the
; 0000 03BB // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 03BC i2c_init();
	CALL _i2c_init
; 0000 03BD 
; 0000 03BE // DS1307 Real Time Clock initialization
; 0000 03BF // Square wave output on pin SQW/OUT: On
; 0000 03C0 // Square wave frequency: 1Hz
; 0000 03C1 rtc_init(0,1,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _rtc_init
; 0000 03C2 
; 0000 03C3 // Alphanumeric LCD initialization
; 0000 03C4 // Connections are specified in the
; 0000 03C5 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 03C6 // RS - PORTC Bit 0
; 0000 03C7 // RD - PORTC Bit 1
; 0000 03C8 // EN - PORTC Bit 2
; 0000 03C9 // D4 - PORTC Bit 4
; 0000 03CA // D5 - PORTC Bit 5
; 0000 03CB // D6 - PORTC Bit 6
; 0000 03CC // D7 - PORTC Bit 7
; 0000 03CD // Characters/line: 20
; 0000 03CE lcd_init(20);
	LDI  R26,LOW(20)
	CALL _lcd_init
; 0000 03CF 
; 0000 03D0 // Global enable interrupts
; 0000 03D1 #asm("sei")
	sei
; 0000 03D2 }
; 0000 03D3 DDRD.4=DDRD.5=DDRD.6=DDRD.7 = 1;
	SBI  0x11,7
	SBI  0x11,6
	SBI  0x11,5
	SBI  0x11,4
; 0000 03D4 lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
; 0000 03D5 //lcd_puts("do an hoc phan 2");
; 0000 03D6 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 03D7 //lcd_puts("Nguyen Ba Phi Hung");
; 0000 03D8 rtc_set_time(23,59,59);
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R30,LOW(59)
	ST   -Y,R30
	LDI  R26,LOW(59)
	CALL _rtc_set_time
; 0000 03D9 //rtc_set_time(gio_cd,phut_cd,giay_cd);
; 0000 03DA rtc_set_date(3,31,12,20);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(31)
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(20)
	CALL _rtc_set_date
; 0000 03DB delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 03DC 
; 0000 03DD 
; 0000 03DE while (1)
_0x10A:
; 0000 03DF       {
; 0000 03E0 
; 0000 03E1 
; 0000 03E2         for(m=0;m<15;m++){
	LDI  R30,LOW(0)
	STS  _m,R30
_0x10E:
	LDS  R26,_m
	CPI  R26,LOW(0xF)
	BRLO PC+2
	RJMP _0x10F
; 0000 03E3             rtc_get_time(&gio,&phut,&giay);
	LDI  R30,LOW(_gio)
	LDI  R31,HIGH(_gio)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_phut)
	LDI  R31,HIGH(_phut)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_giay)
	LDI  R27,HIGH(_giay)
	CALL _rtc_get_time
; 0000 03E4             kiem_tra_nut_nhan(100);  //  delay 100ms giua cac lan doc
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _kiem_tra_nut_nhan
; 0000 03E5             rtc_get_date(&thu, &ngay,&thang,&nam);
	LDI  R30,LOW(_thu)
	LDI  R31,HIGH(_thu)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ngay)
	LDI  R31,HIGH(_ngay)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_thang)
	LDI  R31,HIGH(_thang)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_nam)
	LDI  R27,HIGH(_nam)
	CALL _rtc_get_date
; 0000 03E6             hien_thi_chuoi(gio,phut,giay,0,0,0);
	LDS  R30,_gio
	ST   -Y,R30
	LDS  R30,_phut
	ST   -Y,R30
	LDS  R30,_giay
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _hien_thi_chuoi
; 0000 03E7             hien_thi_chuoi(ngay,thang,nam,1,0,1);
	LDS  R30,_ngay
	ST   -Y,R30
	LDS  R30,_thang
	ST   -Y,R30
	LDS  R30,_nam
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _hien_thi_chuoi
; 0000 03E8             kiem_tra_nut_nhan(100); //  delay 100ms giua cac lan doc
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _kiem_tra_nut_nhan
; 0000 03E9         }
	LDS  R30,_m
	SUBI R30,-LOW(1)
	STS  _m,R30
	RJMP _0x10E
_0x10F:
; 0000 03EA 
; 0000 03EB 
; 0000 03EC 
; 0000 03ED         for(m=0;m<5;m++){
	LDI  R30,LOW(0)
	STS  _m,R30
_0x111:
	LDS  R26,_m
	CPI  R26,LOW(0x5)
	BRSH _0x112
; 0000 03EE             hienthi_nhietdo();
	RCALL _hienthi_nhietdo
; 0000 03EF 
; 0000 03F0 
; 0000 03F1             kiem_tra_nut_nhan(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	RCALL _kiem_tra_nut_nhan
; 0000 03F2         }
	LDS  R30,_m
	SUBI R30,-LOW(1)
	STS  _m,R30
	RJMP _0x111
_0x112:
; 0000 03F3 
; 0000 03F4 
; 0000 03F5         giaotiep_hc05();
	CALL _giaotiep_hc05
; 0000 03F6 
; 0000 03F7 
; 0000 03F8       }
	RJMP _0x10A
; 0000 03F9 }
_0x113:
	RJMP _0x113
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x11
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x11
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G101:
; .FSTART __ftoe_G101
	CALL SUBOPT_0x12
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2020019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x2100008
_0x2020019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x2100008
_0x2020018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001B:
	LDD  R17,Y+11
_0x202001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001E
	CALL SUBOPT_0x13
	RJMP _0x202001C
_0x202001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x13
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x14
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2020021
	CALL SUBOPT_0x13
_0x2020022:
	CALL SUBOPT_0x14
	BRLO _0x2020024
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	CALL SUBOPT_0x14
	BRSH _0x2020028
	CALL SUBOPT_0x15
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	CALL SUBOPT_0x13
_0x2020025:
	__GETD1S 12
	CALL SUBOPT_0x19
	CALL SUBOPT_0x18
	CALL SUBOPT_0x14
	BRLO _0x2020029
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	__GETD2S 4
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x19
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x15
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x18
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	CALL SUBOPT_0x1B
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	CALL SUBOPT_0x1E
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2020113
_0x202002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2020113:
	ST   X,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1E
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x1E
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100008:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x11
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020036
	CPI  R18,37
	BRNE _0x2020037
	LDI  R17,LOW(1)
	RJMP _0x2020038
_0x2020037:
	CALL SUBOPT_0x1F
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	CALL SUBOPT_0x1F
	RJMP _0x2020114
_0x202003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003B
	LDI  R16,LOW(1)
	RJMP _0x2020035
_0x202003B:
	CPI  R18,43
	BRNE _0x202003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003C:
	CPI  R18,32
	BRNE _0x202003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003D:
	RJMP _0x202003E
_0x2020039:
	CPI  R30,LOW(0x2)
	BRNE _0x202003F
_0x202003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020040
	ORI  R16,LOW(128)
	RJMP _0x2020035
_0x2020040:
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2020042
_0x2020041:
	CPI  R18,48
	BRLO _0x2020044
	CPI  R18,58
	BRLO _0x2020045
_0x2020044:
	RJMP _0x2020043
_0x2020045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020035
_0x2020043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020046
	LDI  R17,LOW(4)
	RJMP _0x2020035
_0x2020046:
	RJMP _0x2020047
_0x2020042:
	CPI  R30,LOW(0x4)
	BRNE _0x2020049
	CPI  R18,48
	BRLO _0x202004B
	CPI  R18,58
	BRLO _0x202004C
_0x202004B:
	RJMP _0x202004A
_0x202004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020035
_0x202004A:
_0x2020047:
	CPI  R18,108
	BRNE _0x202004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020035
_0x202004D:
	RJMP _0x202004E
_0x2020049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2020035
_0x202004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020053
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x20
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x22
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x45)
	BREQ _0x2020057
	CPI  R30,LOW(0x65)
	BRNE _0x2020058
_0x2020057:
	RJMP _0x2020059
_0x2020058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x202005A
_0x2020059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x23
	CALL __GETD1P
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	CPI  R26,LOW(0x20)
	BREQ _0x202005F
	RJMP _0x2020060
_0x202005B:
	CALL SUBOPT_0x26
	CALL __ANEGF1
	CALL SUBOPT_0x24
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x2020061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x22
	RJMP _0x2020062
_0x2020061:
_0x202005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020062:
_0x2020060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020064
	CALL SUBOPT_0x26
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2020065
_0x2020064:
	CALL SUBOPT_0x26
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G101
_0x2020065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x27
	RJMP _0x2020066
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020068
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	CALL SUBOPT_0x27
	RJMP _0x2020069
_0x2020068:
	CPI  R30,LOW(0x70)
	BRNE _0x202006B
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x202006D
	CP   R20,R17
	BRLO _0x202006E
_0x202006D:
	RJMP _0x202006C
_0x202006E:
	MOV  R17,R20
_0x202006C:
_0x2020066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x202006F
_0x202006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2020072
	CPI  R30,LOW(0x69)
	BRNE _0x2020073
_0x2020072:
	ORI  R16,LOW(4)
	RJMP _0x2020074
_0x2020073:
	CPI  R30,LOW(0x75)
	BRNE _0x2020075
_0x2020074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x29
	LDI  R17,LOW(10)
	RJMP _0x2020077
_0x2020076:
	__GETD1N 0x2710
	CALL SUBOPT_0x29
	LDI  R17,LOW(5)
	RJMP _0x2020077
_0x2020075:
	CPI  R30,LOW(0x58)
	BRNE _0x2020079
	ORI  R16,LOW(8)
	RJMP _0x202007A
_0x2020079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20200B8
_0x202007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x29
	LDI  R17,LOW(8)
	RJMP _0x2020077
_0x202007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x29
	LDI  R17,LOW(4)
_0x2020077:
	CPI  R20,0
	BREQ _0x202007D
	ANDI R16,LOW(127)
	RJMP _0x202007E
_0x202007D:
	LDI  R20,LOW(1)
_0x202007E:
	SBRS R16,1
	RJMP _0x202007F
	CALL SUBOPT_0x25
	CALL SUBOPT_0x23
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020115
_0x202007F:
	SBRS R16,2
	RJMP _0x2020081
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	CALL __CWD1
	RJMP _0x2020115
_0x2020081:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x28
	CLR  R22
	CLR  R23
_0x2020115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020084
	CALL SUBOPT_0x26
	CALL __ANEGD1
	CALL SUBOPT_0x24
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020086
_0x2020085:
	ANDI R16,LOW(251)
_0x2020086:
_0x2020083:
	MOV  R19,R20
_0x202006F:
	SBRC R16,0
	RJMP _0x2020087
_0x2020088:
	CP   R17,R21
	BRSH _0x202008B
	CP   R19,R21
	BRLO _0x202008C
_0x202008B:
	RJMP _0x202008A
_0x202008C:
	SBRS R16,7
	RJMP _0x202008D
	SBRS R16,2
	RJMP _0x202008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x202008F
_0x202008E:
	LDI  R18,LOW(48)
_0x202008F:
	RJMP _0x2020090
_0x202008D:
	LDI  R18,LOW(32)
_0x2020090:
	CALL SUBOPT_0x1F
	SUBI R21,LOW(1)
	RJMP _0x2020088
_0x202008A:
_0x2020087:
_0x2020091:
	CP   R17,R20
	BRSH _0x2020093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020094
	CALL SUBOPT_0x2A
	BREQ _0x2020095
	SUBI R21,LOW(1)
_0x2020095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x22
	CPI  R21,0
	BREQ _0x2020096
	SUBI R21,LOW(1)
_0x2020096:
	SUBI R20,LOW(1)
	RJMP _0x2020091
_0x2020093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2020097
_0x2020098:
	CPI  R19,0
	BREQ _0x202009A
	SBRS R16,3
	RJMP _0x202009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x202009C
_0x202009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x202009C:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x202009D
	SUBI R21,LOW(1)
_0x202009D:
	SUBI R19,LOW(1)
	RJMP _0x2020098
_0x202009A:
	RJMP _0x202009E
_0x2020097:
_0x20200A0:
	CALL SUBOPT_0x2B
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A2
	SBRS R16,3
	RJMP _0x20200A3
	SUBI R18,-LOW(55)
	RJMP _0x20200A4
_0x20200A3:
	SUBI R18,-LOW(87)
_0x20200A4:
	RJMP _0x20200A5
_0x20200A2:
	SUBI R18,-LOW(48)
_0x20200A5:
	SBRC R16,4
	RJMP _0x20200A7
	CPI  R18,49
	BRSH _0x20200A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20200A8
_0x20200A9:
	RJMP _0x20200AB
_0x20200A8:
	CP   R20,R19
	BRSH _0x2020116
	CP   R21,R19
	BRLO _0x20200AE
	SBRS R16,0
	RJMP _0x20200AF
_0x20200AE:
	RJMP _0x20200AD
_0x20200AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200B0
_0x2020116:
	LDI  R18,LOW(48)
_0x20200AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200B1
	CALL SUBOPT_0x2A
	BREQ _0x20200B2
	SUBI R21,LOW(1)
_0x20200B2:
_0x20200B1:
_0x20200B0:
_0x20200A7:
	CALL SUBOPT_0x1F
	CPI  R21,0
	BREQ _0x20200B3
	SUBI R21,LOW(1)
_0x20200B3:
_0x20200AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x2B
	CALL __MODD21U
	CALL SUBOPT_0x24
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x29
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20200A1
	RJMP _0x20200A0
_0x20200A1:
_0x202009E:
	SBRS R16,0
	RJMP _0x20200B4
_0x20200B5:
	CPI  R21,0
	BREQ _0x20200B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x22
	RJMP _0x20200B5
_0x20200B7:
_0x20200B4:
_0x20200B8:
_0x2020054:
_0x2020114:
	LDI  R17,LOW(0)
_0x2020035:
	RJMP _0x2020030
_0x2020032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x2C
	SBIW R30,0
	BRNE _0x20200B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2100007
_0x20200B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x2C
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2100007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2040003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2040003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2040004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2040004:
	CALL SUBOPT_0x2D
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0x2E
	RJMP _0x2100005
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x2D
	LDI  R26,LOW(0)
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
_0x2100006:
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL SUBOPT_0x2D
	LDI  R26,LOW(0)
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2E
	RJMP _0x2100005
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x2D
	LDI  R26,LOW(3)
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	CALL SUBOPT_0x30
	CALL _i2c_stop
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	CALL SUBOPT_0x2D
	LDI  R26,LOW(3)
	CALL _i2c_write
	LDD  R26,Y+3
	CALL SUBOPT_0x35
	CALL SUBOPT_0x34
	CALL SUBOPT_0x33
	CALL SUBOPT_0x2E
	JMP  _0x2100003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2100004
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x2100004
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x36
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x36
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
_0x2060005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060007
	RJMP _0x2100004
_0x2060007:
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2100004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
	LDD  R17,Y+0
_0x2100005:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2100004:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2100003
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2100003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x12
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20C000D
	CALL SUBOPT_0x38
	__POINTW2FN _0x20C0000,0
	CALL _strcpyf
	RJMP _0x2100002
_0x20C000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20C000C
	CALL SUBOPT_0x38
	__POINTW2FN _0x20C0000,1
	CALL _strcpyf
	RJMP _0x2100002
_0x20C000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20C000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
	LDI  R30,LOW(45)
	ST   X,R30
_0x20C000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20C0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20C0010:
	LDD  R17,Y+8
_0x20C0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20C0013
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x3C
	RJMP _0x20C0011
_0x20C0013:
	CALL SUBOPT_0x3D
	CALL __ADDF12
	CALL SUBOPT_0x39
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x3C
_0x20C0014:
	CALL SUBOPT_0x3D
	CALL __CMPF12
	BRLO _0x20C0016
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x17
	CALL SUBOPT_0x3C
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20C0017
	CALL SUBOPT_0x38
	__POINTW2FN _0x20C0000,5
	CALL _strcpyf
	RJMP _0x2100002
_0x20C0017:
	RJMP _0x20C0014
_0x20C0016:
	CPI  R17,0
	BRNE _0x20C0018
	CALL SUBOPT_0x3A
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20C0019
_0x20C0018:
_0x20C001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20C001C
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x19
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x1C
	LDI  R31,0
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x10
	CALL __MULF12
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x39
	RJMP _0x20C001A
_0x20C001C:
_0x20C0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2100001
	CALL SUBOPT_0x3A
	LDI  R30,LOW(46)
	ST   X,R30
_0x20C001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20C0020
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x17
	CALL SUBOPT_0x39
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x1C
	LDI  R31,0
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x10
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x39
	RJMP _0x20C001E
_0x20C0020:
_0x2100001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_hc05:
	.BYTE 0x14
_ki_tu:
	.BYTE 0x1
_so_tb:
	.BYTE 0x1
_vi_tri:
	.BYTE 0x6
_vi_tri_cai_dat:
	.BYTE 0x1
_m:
	.BYTE 0x1
_test:
	.BYTE 0xC
_gio_cd:
	.BYTE 0x1
_phut_cd:
	.BYTE 0x1
_giay_cd:
	.BYTE 0x1
_thu_cd:
	.BYTE 0x1
_ngay_cd:
	.BYTE 0x1
_thang_cd:
	.BYTE 0x1
_nam_cd:
	.BYTE 0x1
_gio:
	.BYTE 0x1
_phut:
	.BYTE 0x1
_giay:
	.BYTE 0x1
_thu:
	.BYTE 0x1
_ngay:
	.BYTE 0x1
_thang:
	.BYTE 0x1
_nam:
	.BYTE 0x1
_chuoi:
	.BYTE 0x14
_da_nhan_trai:
	.BYTE 0x1
_da_nhan_phai:
	.BYTE 0x1
_da_nhan_tang:
	.BYTE 0x1
_da_nhan_giam:
	.BYTE 0x1
_adc_data:
	.BYTE 0x2
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G106:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SUBI R30,LOW(-_hc05)
	SBCI R31,HIGH(-_hc05)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDS  R30,_ki_tu
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_hc05)
	SBCI R31,HIGH(-_hc05)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDS  R30,_so_tb
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(64)
	CALL _putchar
	LDI  R26,LOW(7)
	CALL _putchar
	__GETB2MN _hc05,2
	CALL _putchar
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CALL _putchar
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CALL _putchar
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CALL _putchar
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CALL _putchar
	__GETB1MN _hc05,2
	LDI  R31,0
	ADIW R30,7
	MOVW R26,R30
	LDI  R30,0
	SBIC 0x10,4
	LDI  R30,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,0
	SBIC 0x10,5
	LDI  R30,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,0
	SBIC 0x10,7
	LDI  R30,1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R26,_nam_cd
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDS  R30,_gio_cd
	ST   -Y,R30
	LDS  R30,_phut_cd
	ST   -Y,R30
	LDS  R30,_giay_cd
	ST   -Y,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _hien_thi_chuoi
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R26,LOW(15)
	JMP  __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	LDS  R30,_ngay_cd
	ST   -Y,R30
	LDS  R30,_thang_cd
	ST   -Y,R30
	LDS  R30,_nam_cd
	ST   -Y,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LDS  R30,_vi_tri_cai_dat
	LDI  R31,0
	SUBI R30,LOW(-_vi_tri)
	SBCI R31,HIGH(-_vi_tri)
	LD   R30,Z
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R30,_vi_tri_cai_dat
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _hien_thi_chuoi
	LDS  R30,_vi_tri_cai_dat
	LDI  R31,0
	SUBI R30,LOW(-_vi_tri)
	SBCI R31,HIGH(-_vi_tri)
	LD   R30,Z
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(_chuoi)
	LDI  R31,HIGH(_chuoi)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL _lcd_gotoxy
	LDI  R26,LOW(_chuoi)
	LDI  R27,HIGH(_chuoi)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x13:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x14:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x20:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x21:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x23:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x20
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x23
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2A:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	CALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	CALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	CALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G103
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	__GETD2S 9
	RET


	.CSEG
	.equ __sda_bit=3
	.equ __scl_bit=2
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
