#line 1 "D:/Docs/Develop/Projetos/RF/PLL, VCO/SAA1057/PLL Simples no estilo Pira.cz/MikroC 5.01/16F628A/Pinagem configurável/Estéreo/0.5/PLL_16F628A_SAA1057.c"
#line 81 "D:/Docs/Develop/Projetos/RF/PLL, VCO/SAA1057/PLL Simples no estilo Pira.cz/MikroC 5.01/16F628A/Pinagem configurável/Estéreo/0.5/PLL_16F628A_SAA1057.c"
unsigned int Frequency;
unsigned short Keys, WordB_B1, WordB_B0, i;



void bit_delay();
void Send_Bit(unsigned short b);
void SendWordB(unsigned short Byte1, unsigned short Byte0);
void SendFrequency(unsigned int Freq);
void signal_delay();


void bit_delay(){
 delay_ms(2);
}


void Send_Bit(unsigned short b){
 if (b == 1)
 {
  PORTA.B4  = 1;
 bit_delay();
  PORTA.B2  = 1;
 bit_delay();
  PORTA.B2  = 0;
 bit_delay();
  PORTA.B4  = 0;
 }
 else
 {
  PORTA.B4  = 0;
  PORTA.B2  = 1;
 bit_delay();
  PORTA.B2  = 0;
 }
 bit_delay();
}


void SendWordB(unsigned short Byte1, unsigned short Byte0){
 unsigned short H, L;

 H = Byte1;
 L = Byte0;

  PORTA.B3  = 1;
 bit_delay();

 Send_Bit(0);

 for(i = 0; i < 8; i++)
 {
 Send_Bit(H.B7);
 H <<= 1;
 }

 for(i = 0; i < 8; i++)
 {
 Send_Bit(L.B7);
 L <<= 1;
 }

  PORTA.B3  = 0;
 bit_delay();

  PORTA.B2  = 1;
 bit_delay();

  PORTA.B2  = 0;
 bit_delay();
 bit_delay();
 bit_delay();
}


void SendFrequency(unsigned int Freq){
 unsigned short FreqH, FreqL;

 FreqH = (freq & 0xFF00) / 0x100;
 FreqL = freq & 0xFF;

  PORTA.B3  = 1;
 bit_delay();

 Send_Bit(0);

 for(i = 0; i < 8; i++)
 {
 Send_Bit(FreqH.B7);
 FreqH <<= 1;
 }

 for(i = 0; i < 8; i++)
 {
 Send_Bit(FreqL.B7);
 FreqL <<= 1;
 }

  PORTA.B3  = 0;
 bit_delay();

  PORTA.B2  = 1;
 bit_delay();

  PORTA.B2  = 0;
 bit_delay();
 bit_delay();
 bit_delay();
}

void signal_delay(){
 delay_us(7);
 asm nop;
}

void main(){

 CMCON = 0x07;
 PORTA = 0x00;
 TRISA = 0b11100000;
 TRISB = 0xFF;
 OPTION_REG.B7 = 0;





 WordB_B0 = 0;
 WordB_B0 |=  0b0101 ;
 WordB_B0.B4 =  1 ;
 WordB_B0 |=  0b0000000 ;
 WordB_B0.B7 =  0 ;

 WordB_B1 = 0;
 WordB_B1.B0 =  1 ;
 WordB_B1 |=  0b01100 ;
 WordB_B1.B5 =  0 ;
 WordB_B1.B6 =  1 ;
 WordB_B1.B7 = 1;

 SendWordB(WordB_B1, WordB_B0);





 Keys = ~PortB;
 Frequency =  1080  - Keys;
 Frequency = Frequency * 10;
 SendFrequency(Frequency);



 delay_ms(2000);





 WordB_B0 = 0;
 WordB_B0 |=  0b0101 ;
 WordB_B0.B4 =  1 ;
 WordB_B0 |=  0b0000000 ;
 WordB_B0.B7 =  1 ;

 WordB_B1 = 0;
 WordB_B1.B0 =  1 ;
 WordB_B1 |=  0b00010 ;
 WordB_B1.B5 =  0 ;
 WordB_B1.B6 =  1 ;
 WordB_B1.B7 = 1;

 SendWordB(WordB_B1 , WordB_B0);
 SendFrequency(Frequency);
#line 273 "D:/Docs/Develop/Projetos/RF/PLL, VCO/SAA1057/PLL Simples no estilo Pira.cz/MikroC 5.01/16F628A/Pinagem configurável/Estéreo/0.5/PLL_16F628A_SAA1057.c"
 while(1)
 {
 TRISA =  0b11101 ;
 signal_delay();
 asm nop;
 asm nop;

 TRISA =  0b11110 ;
 signal_delay();
 asm nop;
 asm nop;

 TRISA =  0b01101 ;
 signal_delay();
 asm nop;
 asm nop;

 TRISA =  0b01110 ;
 signal_delay();

 }

}
