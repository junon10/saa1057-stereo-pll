/*
  ------------------------------------------------------------------------------
  Project: SAA1057 DipSwitch PLL Controller
  Author: Junon M
  Date: 15/09/2011
  Compiler: MikroC Pro for PIC
  ------------------------------------------------------------------------------
*/

//------------------------------------------------------------------------------
#define  Factor  1080 // FM Transmitter
//#define  Factor  1187 // FM Receiver (F + 10,7MHz)
//#define  Factor  973  // FM Receiver (F - 10,7MHz)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// WordB Table
//------------------------------------------------------------------------------
//  15 14   13  12  11  10   9   8        7    6    5   4  3  2  1  0
//  1  FM REFH CP3 CP2 CP1 CP0 SB2      SLA PDM1 PDM0 BRM T3 T2 T1 T0

#define  FM_a         1 // FM mode
#define  FM_b         0 // AM mode

#define  REFH_a       0 // Ref = 1KHz
#define  REFH_b       1 // Ref = 1,25KHz

#define  CP_a         0b00000 // Phase detector current = 0,023mA
#define  CP_b         0b00010 // Phase detector current = 0,07mA
#define  CP_c         0b00100 // Phase detector current = 0,23mA
#define  CP_d         0b01100 // Phase detector current = 0,7mA
#define  CP_e         0b11100 // Phase detector current = 2,3mA

#define  SB2_a        1 // Enables the last 8 bits of wordB SLA up to T0
#define  SB2_b        0 // Clears the last 8 bits of wordB SLA until T0

#define  SLA_a        1 // LatchA charging mode = Synchronous
#define  SLA_b        0 // LatchA charging mode = Asynchronous

#define  PDM_a        0b0000000 // Phase detector mode = Auto on/off
#define  PDM_b        0b1000000 // Phase detector mode = On
#define  PDM_c        0b1100000 // Phase detector mode = Off

#define  BRM_a        1 // Latch current automatically reduced
#define  BRM_b        0 // Current always on

#define  T_a          0b0000 // Test pin output = 1
#define  T_b          0b0100 // Test pin output = Reference frequency
#define  T_c          0b0001 // Test pin output = Programable divider output
#define  T_d          0b0101 // Test pin output = in-lock counter 

// NOTE: The test output pin must have a pull-up resistor.
// In-lock counter states: '0' = out-lock   '1' = in-lock.
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//                                 Pinout
//------------------------------------------------------------------------------
#define  Pin_CLOCK  PORTA.B2
#define  Pin_DLEN   PORTA.B3
#define  Pin_DATA   PORTA.B4
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//                            Stereo Encoder
//------------------------------------------------------------------------------
// Left_Channel   TRISA.B0
// Right_Channel  TRISA.B1
// Pilot_Signal   TRISA.B4
//------------------------------------------------------------------------------
#define E1_D0_P1  0b11101
#define E0_D1_P1  0b11110
#define E1_D0_P0  0b01101
#define E0_D1_P0  0b01110
//------------------------------------------------------------------------------


//Variable declaration
unsigned int Frequency;
unsigned short Keys, WordB_B1, WordB_B0, i;


//Sub Routines declaration
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
    Pin_DATA = 1;
    bit_delay();
    Pin_CLOCK = 1;
    bit_delay();
    Pin_CLOCK = 0;
    bit_delay();
    Pin_DATA = 0;
  }
  else
  {
    Pin_DATA = 0;
    Pin_CLOCK = 1;
    bit_delay();
    Pin_CLOCK = 0;
  }
 bit_delay();
}


void SendWordB(unsigned short Byte1, unsigned short Byte0){
   unsigned short H, L;
   
   H = Byte1;
   L = Byte0;
   
   Pin_DLEN = 1;
   bit_delay();

   Send_Bit(0);// Starting zero

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

   Pin_DLEN = 0;
   bit_delay();

   Pin_CLOCK = 1;
   bit_delay();

   Pin_CLOCK = 0;
   bit_delay();
   bit_delay();
   bit_delay();
}


void SendFrequency(unsigned int Freq){
   unsigned short FreqH, FreqL;

   FreqH = (freq & 0xFF00) / 0x100;
   FreqL = freq & 0xFF;

   Pin_DLEN = 1;
   bit_delay();

   Send_Bit(0);// Starting zero

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

   Pin_DLEN = 0;
   bit_delay();

   Pin_CLOCK = 1;
   bit_delay();

   Pin_CLOCK = 0;
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
   TRISA = 0b11100000; // RA1,RA2,RA3,RA4 as output
   TRISB  = 0xFF; // portB as input
   OPTION_REG.B7 = 0; // enable internal pull-up for portB

   //---------------------------------------------------------------------------
   // Builds high current WordB to tune faster
   //---------------------------------------------------------------------------

   WordB_B0 = 0;         // Just Clean
   WordB_B0 |= T_d;      // Output Test pin = In-lock counter
   WordB_B0.B4 = BRM_a;  // Latch current automatically reduced
   WordB_B0 |= PDM_a;    // Phase detector mode = Auto on/off
   WordB_B0.B7 = SLA_b;  // LatchA Load Mode = Asynchronous

   WordB_B1 = 0;         // Just Clean
   WordB_B1.B0 = SB2_a;  // Enables the last 8 bits of wordB SLA up to T0
   WordB_B1 |= CP_d;     // Phase detector current = 0.7mA
   WordB_B1.B5 = REFH_a; // Ref = 1KHz
   WordB_B1.B6 = FM_a;   // FM mode
   WordB_B1.B7 = 1;      // Flags WordB

   SendWordB(WordB_B1, WordB_B0);
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // Calculates frequency based on dipswitch
   //---------------------------------------------------------------------------
   Keys = ~PortB;
   Frequency = Factor - Keys;
   Frequency = Frequency * 10;
   SendFrequency(Frequency);// Ex: 101,50Mhz = 10150
   //---------------------------------------------------------------------------


   delay_ms(2000); // time for the pll to tune in


   //---------------------------------------------------------------------------
   // Builds low current WordB to avoid signal distortion
   //---------------------------------------------------------------------------
   WordB_B0 = 0;         // Just Clean
   WordB_B0 |= T_d;      // Output Test pin = In-lock counter
   WordB_B0.B4 = BRM_a;  // Latch current automatically reduced
   WordB_B0 |= PDM_a;    // Phase detector mode = Auto on/off
   WordB_B0.B7 = SLA_a;  // LatchA charging mode = Synchronous

   WordB_B1 = 0;         // Just Clean
   WordB_B1.B0 = SB2_a;  // Enables the last 8 bits of wordB SLA up to T0
   WordB_B1 |= CP_b;     // Phase detector current = 0.07mA
   WordB_B1.B5 = REFH_a; // Ref = 1KHz
   WordB_B1.B6 = FM_a;   // FM mode
   WordB_B1.B7 = 1;      // Flags WordB
   
   SendWordB(WordB_B1 , WordB_B0);
   SendFrequency(Frequency);
   //---------------------------------------------------------------------------

   // Complete cycle of (38KHz) 26.316 uS
   // Audio channels must be activated and deactivated alternately
   // every 13.158 uS
   // Complete pilot signal cycle (19KHz) 52.63uS
   
   // Time ->
   //    _   _
   // |_|1|_|1|  Right Channel
   //  _   _                      (Levels change every 13.158 uS)
   // |1|_|1|_|  Left Channel
   //
   // Pilot
   //  _ _
   // | 1 |_ _|  Pilot Signal 19KHz (Changes level every 26.316 uS)
   

   while(1)
   {
     TRISA = E1_D0_P1;
     signal_delay();
     asm nop;
     asm nop;
     
     TRISA = E0_D1_P1;
     signal_delay();
     asm nop;
     asm nop;
     
     TRISA = E1_D0_P0;
     signal_delay();
     asm nop;
     asm nop;
     
     TRISA = E0_D1_P0;
     signal_delay();
     // + 2 nops because of goto
   }
   
}