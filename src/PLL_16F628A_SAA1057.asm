
_bit_delay:

;PLL_16F628A_SAA1057.c,93 :: 		void bit_delay(){
;PLL_16F628A_SAA1057.c,94 :: 		delay_ms(2);
	MOVLW      5
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_bit_delay0:
	DECFSZ     R13+0, 1
	GOTO       L_bit_delay0
	DECFSZ     R12+0, 1
	GOTO       L_bit_delay0
	NOP
;PLL_16F628A_SAA1057.c,95 :: 		}
L_end_bit_delay:
	RETURN
; end of _bit_delay

_Send_Bit:

;PLL_16F628A_SAA1057.c,98 :: 		void Send_Bit(unsigned short b){
;PLL_16F628A_SAA1057.c,99 :: 		if (b == 1)
	MOVF       FARG_Send_Bit_b+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Send_Bit1
;PLL_16F628A_SAA1057.c,101 :: 		Pin_DATA = 1;
	BSF        PORTA+0, 4
;PLL_16F628A_SAA1057.c,102 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,103 :: 		Pin_CLOCK = 1;
	BSF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,104 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,105 :: 		Pin_CLOCK = 0;
	BCF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,106 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,107 :: 		Pin_DATA = 0;
	BCF        PORTA+0, 4
;PLL_16F628A_SAA1057.c,108 :: 		}
	GOTO       L_Send_Bit2
L_Send_Bit1:
;PLL_16F628A_SAA1057.c,111 :: 		Pin_DATA = 0;
	BCF        PORTA+0, 4
;PLL_16F628A_SAA1057.c,112 :: 		Pin_CLOCK = 1;
	BSF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,113 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,114 :: 		Pin_CLOCK = 0;
	BCF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,115 :: 		}
L_Send_Bit2:
;PLL_16F628A_SAA1057.c,116 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,117 :: 		}
L_end_Send_Bit:
	RETURN
; end of _Send_Bit

_SendWordB:

;PLL_16F628A_SAA1057.c,120 :: 		void SendWordB(unsigned short Byte1, unsigned short Byte0){
;PLL_16F628A_SAA1057.c,123 :: 		H = Byte1;
	MOVF       FARG_SendWordB_Byte1+0, 0
	MOVWF      SendWordB_H_L0+0
;PLL_16F628A_SAA1057.c,124 :: 		L = Byte0;
	MOVF       FARG_SendWordB_Byte0+0, 0
	MOVWF      SendWordB_L_L0+0
;PLL_16F628A_SAA1057.c,126 :: 		Pin_DLEN = 1;
	BSF        PORTA+0, 3
;PLL_16F628A_SAA1057.c,127 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,129 :: 		Send_Bit(0);// Zero inicial
	CLRF       FARG_Send_Bit_b+0
	CALL       _Send_Bit+0
;PLL_16F628A_SAA1057.c,131 :: 		for(i = 0; i < 8; i++)
	CLRF       _i+0
L_SendWordB3:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_SendWordB4
;PLL_16F628A_SAA1057.c,133 :: 		Send_Bit(H.B7);
	MOVLW      0
	BTFSC      SendWordB_H_L0+0, 7
	MOVLW      1
	MOVWF      FARG_Send_Bit_b+0
	CALL       _Send_Bit+0
;PLL_16F628A_SAA1057.c,134 :: 		H <<= 1;
	RLF        SendWordB_H_L0+0, 1
	BCF        SendWordB_H_L0+0, 0
;PLL_16F628A_SAA1057.c,131 :: 		for(i = 0; i < 8; i++)
	INCF       _i+0, 1
;PLL_16F628A_SAA1057.c,135 :: 		}
	GOTO       L_SendWordB3
L_SendWordB4:
;PLL_16F628A_SAA1057.c,137 :: 		for(i = 0; i < 8; i++)
	CLRF       _i+0
L_SendWordB6:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_SendWordB7
;PLL_16F628A_SAA1057.c,139 :: 		Send_Bit(L.B7);
	MOVLW      0
	BTFSC      SendWordB_L_L0+0, 7
	MOVLW      1
	MOVWF      FARG_Send_Bit_b+0
	CALL       _Send_Bit+0
;PLL_16F628A_SAA1057.c,140 :: 		L <<= 1;
	RLF        SendWordB_L_L0+0, 1
	BCF        SendWordB_L_L0+0, 0
;PLL_16F628A_SAA1057.c,137 :: 		for(i = 0; i < 8; i++)
	INCF       _i+0, 1
;PLL_16F628A_SAA1057.c,141 :: 		}
	GOTO       L_SendWordB6
L_SendWordB7:
;PLL_16F628A_SAA1057.c,143 :: 		Pin_DLEN = 0;
	BCF        PORTA+0, 3
;PLL_16F628A_SAA1057.c,144 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,146 :: 		Pin_CLOCK = 1;
	BSF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,147 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,149 :: 		Pin_CLOCK = 0;
	BCF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,150 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,151 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,152 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,153 :: 		}
L_end_SendWordB:
	RETURN
; end of _SendWordB

_SendFrequency:

;PLL_16F628A_SAA1057.c,156 :: 		void SendFrequency(unsigned int Freq){
;PLL_16F628A_SAA1057.c,159 :: 		FreqH = (freq & 0xFF00) / 0x100;
	MOVLW      0
	ANDWF      FARG_SendFrequency_Freq+0, 0
	MOVWF      R3+0
	MOVF       FARG_SendFrequency_Freq+1, 0
	ANDLW      255
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      SendFrequency_FreqH_L0+0
;PLL_16F628A_SAA1057.c,160 :: 		FreqL = freq & 0xFF;
	MOVLW      255
	ANDWF      FARG_SendFrequency_Freq+0, 0
	MOVWF      SendFrequency_FreqL_L0+0
;PLL_16F628A_SAA1057.c,162 :: 		Pin_DLEN = 1;
	BSF        PORTA+0, 3
;PLL_16F628A_SAA1057.c,163 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,165 :: 		Send_Bit(0);// Zero inicial
	CLRF       FARG_Send_Bit_b+0
	CALL       _Send_Bit+0
;PLL_16F628A_SAA1057.c,167 :: 		for(i = 0; i < 8; i++)
	CLRF       _i+0
L_SendFrequency9:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_SendFrequency10
;PLL_16F628A_SAA1057.c,169 :: 		Send_Bit(FreqH.B7);
	MOVLW      0
	BTFSC      SendFrequency_FreqH_L0+0, 7
	MOVLW      1
	MOVWF      FARG_Send_Bit_b+0
	CALL       _Send_Bit+0
;PLL_16F628A_SAA1057.c,170 :: 		FreqH <<= 1;
	RLF        SendFrequency_FreqH_L0+0, 1
	BCF        SendFrequency_FreqH_L0+0, 0
;PLL_16F628A_SAA1057.c,167 :: 		for(i = 0; i < 8; i++)
	INCF       _i+0, 1
;PLL_16F628A_SAA1057.c,171 :: 		}
	GOTO       L_SendFrequency9
L_SendFrequency10:
;PLL_16F628A_SAA1057.c,173 :: 		for(i = 0; i < 8; i++)
	CLRF       _i+0
L_SendFrequency12:
	MOVLW      8
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_SendFrequency13
;PLL_16F628A_SAA1057.c,175 :: 		Send_Bit(FreqL.B7);
	MOVLW      0
	BTFSC      SendFrequency_FreqL_L0+0, 7
	MOVLW      1
	MOVWF      FARG_Send_Bit_b+0
	CALL       _Send_Bit+0
;PLL_16F628A_SAA1057.c,176 :: 		FreqL <<= 1;
	RLF        SendFrequency_FreqL_L0+0, 1
	BCF        SendFrequency_FreqL_L0+0, 0
;PLL_16F628A_SAA1057.c,173 :: 		for(i = 0; i < 8; i++)
	INCF       _i+0, 1
;PLL_16F628A_SAA1057.c,177 :: 		}
	GOTO       L_SendFrequency12
L_SendFrequency13:
;PLL_16F628A_SAA1057.c,179 :: 		Pin_DLEN = 0;
	BCF        PORTA+0, 3
;PLL_16F628A_SAA1057.c,180 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,182 :: 		Pin_CLOCK = 1;
	BSF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,183 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,185 :: 		Pin_CLOCK = 0;
	BCF        PORTA+0, 2
;PLL_16F628A_SAA1057.c,186 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,187 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,188 :: 		bit_delay();
	CALL       _bit_delay+0
;PLL_16F628A_SAA1057.c,189 :: 		}
L_end_SendFrequency:
	RETURN
; end of _SendFrequency

_signal_delay:

;PLL_16F628A_SAA1057.c,191 :: 		void signal_delay(){
;PLL_16F628A_SAA1057.c,192 :: 		delay_us(7);
	MOVLW      4
	MOVWF      R13+0
L_signal_delay15:
	DECFSZ     R13+0, 1
	GOTO       L_signal_delay15
;PLL_16F628A_SAA1057.c,193 :: 		asm nop;
	NOP
;PLL_16F628A_SAA1057.c,194 :: 		}
L_end_signal_delay:
	RETURN
; end of _signal_delay

_main:

;PLL_16F628A_SAA1057.c,196 :: 		void main(){
;PLL_16F628A_SAA1057.c,198 :: 		CMCON = 0x07;
	MOVLW      7
	MOVWF      CMCON+0
;PLL_16F628A_SAA1057.c,199 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;PLL_16F628A_SAA1057.c,200 :: 		TRISA = 0b11100000; //RA1,RA2,RA3,RA4 como saída
	MOVLW      224
	MOVWF      TRISA+0
;PLL_16F628A_SAA1057.c,201 :: 		TRISB  = 0xFF;//portB como entrada
	MOVLW      255
	MOVWF      TRISB+0
;PLL_16F628A_SAA1057.c,202 :: 		OPTION_REG.B7 = 0; //habilita pull-up interno para portB
	BCF        OPTION_REG+0, 7
;PLL_16F628A_SAA1057.c,208 :: 		WordB_B0 = 0;         // Apenas Limpa
	CLRF       _WordB_B0+0
;PLL_16F628A_SAA1057.c,209 :: 		WordB_B0 |= T_d;      // Saida Pino de teste = Contador in-lock
	MOVLW      5
	MOVWF      _WordB_B0+0
;PLL_16F628A_SAA1057.c,210 :: 		WordB_B0.B4 = BRM_a;  // Corrente no latch reduzida automaticamente
	BSF        _WordB_B0+0, 4
;PLL_16F628A_SAA1057.c,211 :: 		WordB_B0 |= PDM_a;    // Modo do detector de fase = Automático on/off
;PLL_16F628A_SAA1057.c,212 :: 		WordB_B0.B7 = SLA_b;  // Modo de carregamento do LatchA = Assíncrono
	BCF        _WordB_B0+0, 7
;PLL_16F628A_SAA1057.c,214 :: 		WordB_B1 = 0;         // Apenas Limpa
	CLRF       _WordB_B1+0
;PLL_16F628A_SAA1057.c,215 :: 		WordB_B1.B0 = SB2_a;  // Habilita os últimos 8 bits da wordB SLA até T0
	BSF        _WordB_B1+0, 0
;PLL_16F628A_SAA1057.c,216 :: 		WordB_B1 |= CP_d;     // Corrente detector fase = 0,7mA
	MOVLW      12
	IORWF      _WordB_B1+0, 1
;PLL_16F628A_SAA1057.c,217 :: 		WordB_B1.B5 = REFH_a; // Ref = 1KHz
	BCF        _WordB_B1+0, 5
;PLL_16F628A_SAA1057.c,218 :: 		WordB_B1.B6 = FM_a;   // Modo FM
	BSF        _WordB_B1+0, 6
;PLL_16F628A_SAA1057.c,219 :: 		WordB_B1.B7 = 1;      // Sinaliza WordB
	BSF        _WordB_B1+0, 7
;PLL_16F628A_SAA1057.c,221 :: 		SendWordB(WordB_B1, WordB_B0);
	MOVF       _WordB_B1+0, 0
	MOVWF      FARG_SendWordB_Byte1+0
	MOVF       _WordB_B0+0, 0
	MOVWF      FARG_SendWordB_Byte0+0
	CALL       _SendWordB+0
;PLL_16F628A_SAA1057.c,227 :: 		Keys = ~PortB;
	COMF       PORTB+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _Keys+0
;PLL_16F628A_SAA1057.c,228 :: 		Frequency = Factor - Keys;
	MOVF       R0+0, 0
	SUBLW      56
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      4
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _Frequency+0
	MOVF       R0+1, 0
	MOVWF      _Frequency+1
;PLL_16F628A_SAA1057.c,229 :: 		Frequency = Frequency * 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _Frequency+0
	MOVF       R0+1, 0
	MOVWF      _Frequency+1
;PLL_16F628A_SAA1057.c,230 :: 		SendFrequency(Frequency);// Ex: 101,50Mhz = 10150
	MOVF       R0+0, 0
	MOVWF      FARG_SendFrequency_Freq+0
	MOVF       R0+1, 0
	MOVWF      FARG_SendFrequency_Freq+1
	CALL       _SendFrequency+0
;PLL_16F628A_SAA1057.c,234 :: 		delay_ms(2000);//tempo para o pll sintonizar
	MOVLW      20
	MOVWF      R11+0
	MOVLW      72
	MOVWF      R12+0
	MOVLW      1
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	DECFSZ     R11+0, 1
	GOTO       L_main16
;PLL_16F628A_SAA1057.c,240 :: 		WordB_B0 = 0;         // Apenas Limpa
	CLRF       _WordB_B0+0
;PLL_16F628A_SAA1057.c,241 :: 		WordB_B0 |= T_d;      // Saida Pino de teste = Contador in-lock
	MOVLW      5
	MOVWF      _WordB_B0+0
;PLL_16F628A_SAA1057.c,242 :: 		WordB_B0.B4 = BRM_a;  // Corrente no latch reduzida automaticamente
	BSF        _WordB_B0+0, 4
;PLL_16F628A_SAA1057.c,243 :: 		WordB_B0 |= PDM_a;    // Modo do detector de fase = Automático on/off
;PLL_16F628A_SAA1057.c,244 :: 		WordB_B0.B7 = SLA_a;  // Modo de carregamento do LatchA = Síncrono
	BSF        _WordB_B0+0, 7
;PLL_16F628A_SAA1057.c,246 :: 		WordB_B1 = 0;         // Apenas Limpa
	CLRF       _WordB_B1+0
;PLL_16F628A_SAA1057.c,247 :: 		WordB_B1.B0 = SB2_a;  // Habilita os últimos 8 bits da wordB SLA até T0
	BSF        _WordB_B1+0, 0
;PLL_16F628A_SAA1057.c,248 :: 		WordB_B1 |= CP_b;     // Corrente detector fase = 0,07mA
	BSF        _WordB_B1+0, 1
;PLL_16F628A_SAA1057.c,249 :: 		WordB_B1.B5 = REFH_a; // Ref = 1KHz
	BCF        _WordB_B1+0, 5
;PLL_16F628A_SAA1057.c,250 :: 		WordB_B1.B6 = FM_a;   // Modo FM
	BSF        _WordB_B1+0, 6
;PLL_16F628A_SAA1057.c,251 :: 		WordB_B1.B7 = 1;      // Sinaliza WordB
	BSF        _WordB_B1+0, 7
;PLL_16F628A_SAA1057.c,253 :: 		SendWordB(WordB_B1 , WordB_B0);
	MOVF       _WordB_B1+0, 0
	MOVWF      FARG_SendWordB_Byte1+0
	MOVF       _WordB_B0+0, 0
	MOVWF      FARG_SendWordB_Byte0+0
	CALL       _SendWordB+0
;PLL_16F628A_SAA1057.c,254 :: 		SendFrequency(Frequency);
	MOVF       _Frequency+0, 0
	MOVWF      FARG_SendFrequency_Freq+0
	MOVF       _Frequency+1, 0
	MOVWF      FARG_SendFrequency_Freq+1
	CALL       _SendFrequency+0
;PLL_16F628A_SAA1057.c,273 :: 		while(1)
L_main17:
;PLL_16F628A_SAA1057.c,275 :: 		TRISA = E1_D0_P1;
	MOVLW      29
	MOVWF      TRISA+0
;PLL_16F628A_SAA1057.c,276 :: 		signal_delay();
	CALL       _signal_delay+0
;PLL_16F628A_SAA1057.c,277 :: 		asm nop;
	NOP
;PLL_16F628A_SAA1057.c,278 :: 		asm nop;
	NOP
;PLL_16F628A_SAA1057.c,280 :: 		TRISA = E0_D1_P1;
	MOVLW      30
	MOVWF      TRISA+0
;PLL_16F628A_SAA1057.c,281 :: 		signal_delay();
	CALL       _signal_delay+0
;PLL_16F628A_SAA1057.c,282 :: 		asm nop;
	NOP
;PLL_16F628A_SAA1057.c,283 :: 		asm nop;
	NOP
;PLL_16F628A_SAA1057.c,285 :: 		TRISA = E1_D0_P0;
	MOVLW      13
	MOVWF      TRISA+0
;PLL_16F628A_SAA1057.c,286 :: 		signal_delay();
	CALL       _signal_delay+0
;PLL_16F628A_SAA1057.c,287 :: 		asm nop;
	NOP
;PLL_16F628A_SAA1057.c,288 :: 		asm nop;
	NOP
;PLL_16F628A_SAA1057.c,290 :: 		TRISA = E0_D1_P0;
	MOVLW      14
	MOVWF      TRISA+0
;PLL_16F628A_SAA1057.c,291 :: 		signal_delay();
	CALL       _signal_delay+0
;PLL_16F628A_SAA1057.c,293 :: 		}
	GOTO       L_main17
;PLL_16F628A_SAA1057.c,295 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
