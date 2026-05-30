// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc.
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development
//   Kits made by Terasic.  Other use of this code, including the selling
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use
//   or functionality of this code.
//
// --------------------------------------------------------------------
//
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2_70 LTM Ephoto demo
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny FAN        :| 07/07/09  :| Initial Revision
// --------------------------------------------------------------------

module DE2_70_LTM_Ephoto
	(
		////////////////////	Clock Input	 	////////////////////
		iCLK_28,						//  28.63636 MHz
		iCLK_50,						//	50 MHz
		iCLK_50_2,						//	50 MHz
		iCLK_50_3,						//	50 MHz
		iCLK_50_4,						//	50 MHz
		iEXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		iKEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		iSW,							//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		oHEX0_D,						//	Seven Segment Digit 0
		oHEX0_DP,						//  Seven Segment Digit 0 decimal point
		oHEX1_D,						//	Seven Segment Digit 1
		oHEX1_DP,						//  Seven Segment Digit 1 decimal point
		oHEX2_D,						//	Seven Segment Digit 2
		oHEX2_DP,						//  Seven Segment Digit 2 decimal point
		oHEX3_D,						//	Seven Segment Digit 3
		oHEX3_DP,						//  Seven Segment Digit 3 decimal point
		oHEX4_D,						//	Seven Segment Digit 4
		oHEX4_DP,						//  Seven Segment Digit 4 decimal point
		oHEX5_D,						//	Seven Segment Digit 5
		oHEX5_DP,						//  Seven Segment Digit 5 decimal point
		oHEX6_D,						//	Seven Segment Digit 6
		oHEX6_DP,						//  Seven Segment Digit 6 decimal point
		oHEX7_D,						//	Seven Segment Digit 7
		oHEX7_DP,						//  Seven Segment Digit 7 decimal point
		////////////////////////	LED		////////////////////////
		oLEDG,							//	LED Green[8:0]
		oLEDR,							//	LED Red[17:0]
		////////////////////////	UART	////////////////////////
		oUART_TXD,						//	UART Transmitter
		iUART_RXD,						//	UART Receiver
		oUART_CTS,          			//	UART Clear To Send
		iUART_RTS,          			//	UART Requst To Send
		////////////////////////	IRDA	////////////////////////
		oIRDA_TXD,						//	IRDA Transmitter
		iIRDA_RXD,						//	IRDA Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 32 Bits
		oDRAM0_A,						//	SDRAM0 Address bus 12 Bits
		oDRAM1_A,						//	SDRAM1 Address bus 12 Bits
		oDRAM0_LDQM0,					//	SDRAM0 Low-byte Data Mask
		oDRAM1_LDQM0,					//	SDRAM1 Low-byte Data Mask
		oDRAM0_UDQM1,					//	SDRAM0 High-byte Data Mask
		oDRAM1_UDQM1,					//	SDRAM1 High-byte Data Mask
		oDRAM0_WE_N,					//	SDRAM0 Write Enable
		oDRAM1_WE_N,					//	SDRAM1 Write Enable
		oDRAM0_CAS_N,					//	SDRAM0 Column Address Strobe
		oDRAM1_CAS_N,					//	SDRAM1 Column Address Strobe
		oDRAM0_RAS_N,					//	SDRAM0 Row Address Strobe
		oDRAM1_RAS_N,					//	SDRAM1 Row Address Strobe
		oDRAM0_CS_N,					//	SDRAM0 Chip Select
		oDRAM1_CS_N,					//	SDRAM1 Chip Select
		oDRAM0_BA,						//	SDRAM0 Bank Address
		oDRAM1_BA,	 					//	SDRAM1 Bank Address
		oDRAM0_CLK,						//	SDRAM0 Clock
		oDRAM1_CLK,						//	SDRAM0 Clock
		oDRAM0_CKE,						//	SDRAM0 Clock Enable
		oDRAM1_CKE,						//	SDRAM1 Clock Enable
		////////////////////	Flash Interface		////////////////
		FLASH_DQ,						//	FLASH Data bus 15 Bits (0 to 14)
		FLASH_DQ15_AM1,					//  FLASH Data bus Bit 15 or Address A-1
		oFLASH_A,						//	FLASH Address bus 26 Bits
		oFLASH_WE_N,					//	FLASH Write Enable
		oFLASH_RST_N,					//	FLASH Reset
		oFLASH_WP_N,					//	FLASH Write Protect /Programming Acceleration
		iFLASH_RY_N,					//	FLASH Ready/Busy output
		oFLASH_BYTE_N,					//	FLASH Byte/Word Mode Configuration
		oFLASH_OE_N,					//	FLASH Output Enable
		oFLASH_CE_N,					//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data Bus 32 Bits
		SRAM_DPA, 						//  SRAM Parity Data Bus
		oSRAM_A,						//	SRAM Address bus 22 Bits
		oSRAM_ADSC_N,       			//	SRAM Controller Address Status
		oSRAM_ADSP_N,                   //	SRAM Processor Address Status
		oSRAM_ADV_N,                    //	SRAM Burst Address Advance
		oSRAM_BE_N,                     //	SRAM Byte Write Enable
		oSRAM_CE1_N,        			//	SRAM Chip Enable
		oSRAM_CE2,          			//	SRAM Chip Enable
		oSRAM_CE3_N,        			//	SRAM Chip Enable
		oSRAM_CLK,                      //	SRAM Clock
		oSRAM_GW_N,         			//  SRAM Global Write Enable
		oSRAM_OE_N,         			//	SRAM Output Enable
		oSRAM_WE_N,         			//	SRAM Write Enable
		////////////////////	ISP1362 Interface	////////////////
		OTG_D,							//	ISP1362 Data bus 16 Bits
		oOTG_A,							//	ISP1362 Address 2 Bits
		oOTG_CS_N,						//	ISP1362 Chip Select
		oOTG_OE_N,						//	ISP1362 Read
		oOTG_WE_N,						//	ISP1362 Write
		oOTG_RESET_N,					//	ISP1362 Reset
		OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
		OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
		iOTG_INT0,						//	ISP1362 Interrupt 0
		iOTG_INT1,						//	ISP1362 Interrupt 1
		iOTG_DREQ0,						//	ISP1362 DMA Request 0
		iOTG_DREQ1,						//	ISP1362 DMA Request 1
		oOTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
		oOTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
		////////////////////	LCD Module 16X2		////////////////
		oLCD_ON,						//	LCD Power ON/OFF
		oLCD_BLON,						//	LCD Back Light ON/OFF
		oLCD_RW,						//	LCD Read/Write Select, 0 = Write, 1 = Read
		oLCD_EN,						//	LCD Enable
		oLCD_RS,						//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_D,						//	LCD Data bus 8 bits
		////////////////////	SD_Card Interface	////////////////
		SD_DAT,							//	SD Card Data
		SD_DAT3,						//	SD Card Data 3
		SD_CMD,							//	SD Card Command Signal
		oSD_CLK,						//	SD Card Clock
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		oI2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,						//	PS2 Data
		PS2_CLK,						//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		oVGA_CLOCK,   					//	VGA Clock
		oVGA_HS,						//	VGA H_SYNC
		oVGA_VS,						//	VGA V_SYNC
		oVGA_BLANK_N,					//	VGA BLANK
		oVGA_SYNC_N,					//	VGA SYNC
		oVGA_R,   						//	VGA Red[9:0]
		oVGA_G,	 						//	VGA Green[9:0]
		oVGA_B,  						//	VGA Blue[9:0]
		////////////	Ethernet Interface	////////////////////////
		ENET_D,						//	DM9000A DATA bus 16Bits
		oENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
		oENET_CS_N,						//	DM9000A Chip Select
		oENET_IOW_N,					//	DM9000A Write
		oENET_IOR_N,					//	DM9000A Read
		oENET_RESET_N,					//	DM9000A Reset
		iENET_INT,						//	DM9000A Interrupt
		oENET_CLK,						//	DM9000A Clock 25 MHz
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		iAUD_ADCDAT,					//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		oAUD_DACDAT,					//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		oAUD_XCK,						//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		iTD1_CLK27,						//	TV Decoder1 Line_Lock Output Clock
		iTD1_D,    					    //	TV Decoder1 Data bus 8 bits
		iTD1_HS,						//	TV Decoder1 H_SYNC
		iTD1_VS,						//	TV Decoder1 V_SYNC
		oTD1_RESET_N,					//	TV Decoder1 Reset
		iTD2_CLK27,						//	TV Decoder2 Line_Lock Output Clock
		iTD2_D,    					    //	TV Decoder2 Data bus 8 bits
		iTD2_HS,						//	TV Decoder2 H_SYNC
		iTD2_VS,						//	TV Decoder2 V_SYNC
		oTD2_RESET_N,					//	TV Decoder2 Reset
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0 I/O
		GPIO_CLKIN_N0,     				//	GPIO Connection 0 Clock Input 0
		GPIO_CLKIN_P0,          		//	GPIO Connection 0 Clock Input 1
		GPIO_CLKOUT_N0,     			//	GPIO Connection 0 Clock Output 0
		GPIO_CLKOUT_P0,                 //	GPIO Connection 0 Clock Output 1
		GPIO_1,							//	GPIO Connection 1 I/O
		GPIO_CLKIN_N1,                  //	GPIO Connection 1 Clock Input 0
		GPIO_CLKIN_P1,                  //	GPIO Connection 1 Clock Input 1
		GPIO_CLKOUT_N1,                 //	GPIO Connection 1 Clock Output 0
		GPIO_CLKOUT_P1                  //	GPIO Connection 1 Clock Output 1

	);

//===========================================================================
// PARAMETER declarations
//===========================================================================


//===========================================================================
// PORT declarations
//===========================================================================
////////////////////////	Clock Input	 	////////////////////////
input			iCLK_28;				//  28.63636 MHz
input			iCLK_50;				//	50 MHz
input			iCLK_50_2;				//	50 MHz
input           iCLK_50_3;				//	50 MHz
input           iCLK_50_4;				//	50 MHz
input           iEXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	iKEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	iSW;					//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	oHEX0_D;				//	Seven Segment Digit 0
output			oHEX0_DP;				//  Seven Segment Digit 0 decimal point
output	[6:0]	oHEX1_D;				//	Seven Segment Digit 1
output			oHEX1_DP;				//  Seven Segment Digit 1 decimal point
output	[6:0]	oHEX2_D;				//	Seven Segment Digit 2
output			oHEX2_DP;				//  Seven Segment Digit 2 decimal point
output	[6:0]	oHEX3_D;				//	Seven Segment Digit 3
output			oHEX3_DP;				//  Seven Segment Digit 3 decimal point
output	[6:0]	oHEX4_D;				//	Seven Segment Digit 4
output			oHEX4_DP;				//  Seven Segment Digit 4 decimal point
output	[6:0]	oHEX5_D;				//	Seven Segment Digit 5
output			oHEX5_DP;				//  Seven Segment Digit 5 decimal point
output	[6:0]	oHEX6_D;				//	Seven Segment Digit 6
output			oHEX6_DP;				//  Seven Segment Digit 6 decimal point
output	[6:0]	oHEX7_D;				//	Seven Segment Digit 7
output			oHEX7_DP;				//  Seven Segment Digit 7 decimal point
////////////////////////////	LED		////////////////////////////
output	[8:0]	oLEDG;					//	LED Green[8:0]
output	[17:0]	oLEDR;					//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
output			oUART_TXD;				//	UART Transmitter
input			iUART_RXD;				//	UART Receiver
output			oUART_CTS;          	//	UART Clear To Send
input			iUART_RTS;          	//	UART Requst To Send
////////////////////////////	IRDA	////////////////////////////
output			oIRDA_TXD;				//	IRDA Transmitter
input			iIRDA_RXD;				//	IRDA Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	[31:0]	DRAM_DQ;				//	SDRAM Data bus 32 Bits
output	[12:0]	oDRAM0_A;				//	SDRAM0 Address bus 12 Bits
output	[12:0]	oDRAM1_A;				//	SDRAM1 Address bus 12 Bits
output			oDRAM0_LDQM0;			//	SDRAM0 Low-byte Data Mask
output			oDRAM1_LDQM0;			//	SDRAM1 Low-byte Data Mask
output			oDRAM0_UDQM1;			//	SDRAM0 High-byte Data Mask
output			oDRAM1_UDQM1;			//	SDRAM1 High-byte Data Mask
output			oDRAM0_WE_N;			//	SDRAM0 Write Enable
output			oDRAM1_WE_N;			//	SDRAM1 Write Enable
output			oDRAM0_CAS_N;			//	SDRAM0 Column Address Strobe
output			oDRAM1_CAS_N;			//	SDRAM1 Column Address Strobe
output			oDRAM0_RAS_N;			//	SDRAM0 Row Address Strobe
output			oDRAM1_RAS_N;			//	SDRAM1 Row Address Strobe
output			oDRAM0_CS_N;			//	SDRAM0 Chip Select
output			oDRAM1_CS_N;			//	SDRAM1 Chip Select
output	[1:0]	oDRAM0_BA;				//	SDRAM0 Bank Address
output	[1:0]	oDRAM1_BA;		 		//	SDRAM1 Bank Address
output			oDRAM0_CLK;				//	SDRAM0 Clock
output			oDRAM1_CLK;				//	SDRAM0 Clock
output			oDRAM0_CKE;				//	SDRAM0 Clock Enable
output			oDRAM1_CKE;				//	SDRAM1 Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	[14:0]	FLASH_DQ;				//	FLASH Data bus 15 Bits (0 to 14)
inout			FLASH_DQ15_AM1;			//  FLASH Data bus Bit 15 or Address A-1
output	[25:0]	oFLASH_A;				//	FLASH Address bus 26 Bits
output			oFLASH_WE_N;			//	FLASH Write Enable
output			oFLASH_RST_N;			//	FLASH Reset
output			oFLASH_WP_N;			//	FLASH Write Protect /Programming Acceleration
input			iFLASH_RY_N;			//	FLASH Ready/Busy output
output			oFLASH_BYTE_N;			//	FLASH Byte/Word Mode Configuration
output			oFLASH_OE_N;			//	FLASH Output Enable
output			oFLASH_CE_N;			//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	[31:0]	SRAM_DQ;				//	SRAM Data Bus 32 Bits
inout	[3:0]	SRAM_DPA; 				//  SRAM Parity Data Bus
output	[20:0]	oSRAM_A;				//	SRAM Address bus 21 Bits
output			oSRAM_ADSC_N;       	//	SRAM Controller Address Status
output			oSRAM_ADSP_N;           //	SRAM Processor Address Status
output			oSRAM_ADV_N;            //	SRAM Burst Address Advance
output	[3:0]	oSRAM_BE_N;             //	SRAM Byte Write Enable
output			oSRAM_CE1_N;        	//	SRAM Chip Enable
output			oSRAM_CE2;          	//	SRAM Chip Enable
output			oSRAM_CE3_N;        	//	SRAM Chip Enable
output			oSRAM_CLK;              //	SRAM Clock
output			oSRAM_GW_N;         	//  SRAM Global Write Enable
output			oSRAM_OE_N;         	//	SRAM Output Enable
output			oSRAM_WE_N;         	//	SRAM Write Enable
////////////////////	ISP1362 Interface	////////////////////////
inout	[15:0]	OTG_D;					//	ISP1362 Data bus 16 Bits
output	[1:0]	oOTG_A;					//	ISP1362 Address 2 Bits
output			oOTG_CS_N;				//	ISP1362 Chip Select
output			oOTG_OE_N;				//	ISP1362 Read
output			oOTG_WE_N;				//	ISP1362 Write
output			oOTG_RESET_N;			//	ISP1362 Reset
inout			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
inout			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
input			iOTG_INT0;				//	ISP1362 Interrupt 0
input			iOTG_INT1;				//	ISP1362 Interrupt 1
input			iOTG_DREQ0;				//	ISP1362 DMA Request 0
input			iOTG_DREQ1;				//	ISP1362 DMA Request 1
output			oOTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
output			oOTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
inout	[7:0]	LCD_D;					//	LCD Data bus 8 bits
output			oLCD_ON;				//	LCD Power ON/OFF
output			oLCD_BLON;				//	LCD Back Light ON/OFF
output			oLCD_RW;				//	LCD Read/Write Select, 0 = Write, 1 = Read
output			oLCD_EN;				//	LCD Enable
output			oLCD_RS;				//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
inout			SD_DAT;					//	SD Card Data
inout			SD_DAT3;				//	SD Card Data 3
inout			SD_CMD;					//	SD Card Command Signal
output			oSD_CLK;				//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			oI2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
inout		 	PS2_DAT;				//	PS2 Data
inout			PS2_CLK;				//	PS2 Clock
////////////////////////	VGA			////////////////////////////
output			oVGA_CLOCK;   			//	VGA Clock
output			oVGA_HS;				//	VGA H_SYNC
output			oVGA_VS;				//	VGA V_SYNC
output			oVGA_BLANK_N;			//	VGA BLANK
output			oVGA_SYNC_N;			//	VGA SYNC
output	[9:0]	oVGA_R;   				//	VGA Red[9:0]
output	[9:0]	oVGA_G;	 				//	VGA Green[9:0]
output	[9:0]	oVGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
inout	[15:0]	ENET_D;					//	DM9000A DATA bus 16Bits
output			oENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
output			oENET_CS_N;				//	DM9000A Chip Select
output			oENET_IOW_N;			//	DM9000A Write
output			oENET_IOR_N;			//	DM9000A Read
output			oENET_RESET_N;			//	DM9000A Reset
input			iENET_INT;				//	DM9000A Interrupt
output			oENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
inout			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			iAUD_ADCDAT;			//	Audio CODEC ADC Data
inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			oAUD_DACDAT;			//	Audio CODEC DAC Data
inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			oAUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input			iTD1_CLK27;				//	TV Decoder1 Line_Lock Output Clock
input	[7:0]	iTD1_D;    				//	TV Decoder1 Data bus 8 bits
input			iTD1_HS;				//	TV Decoder1 H_SYNC
input			iTD1_VS;				//	TV Decoder1 V_SYNC
output			oTD1_RESET_N;			//	TV Decoder1 Reset
input			iTD2_CLK27;				//	TV Decoder2 Line_Lock Output Clock
input	[7:0]	iTD2_D;    				//	TV Decoder2 Data bus 8 bits
input			iTD2_HS;				//	TV Decoder2 H_SYNC
input			iTD2_VS;				//	TV Decoder2 V_SYNC
output			oTD2_RESET_N;			//	TV Decoder2 Reset

////////////////////////	GPIO	////////////////////////////////
inout	[31:0]	GPIO_0;					//	GPIO Connection 0 I/O
input			GPIO_CLKIN_N0;     		//	GPIO Connection 0 Clock Input 0
input			GPIO_CLKIN_P0;          //	GPIO Connection 0 Clock Input 1
output			GPIO_CLKOUT_N0;     	//	GPIO Connection 0 Clock Output 0
output			GPIO_CLKOUT_P0;         //	GPIO Connection 0 Clock Output 1
inout	[31:0]	GPIO_1;					//	GPIO Connection 1 I/O
input			GPIO_CLKIN_N1;          //	GPIO Connection 1 Clock Input 0
input			GPIO_CLKIN_P1;          //	GPIO Connection 1 Clock Input 1
output			GPIO_CLKOUT_N1;         //	GPIO Connection 1 Clock Output 0
output			GPIO_CLKOUT_P1;         //	GPIO Connection 1 Clock Output 1
///////////////////////////////////////////////////////////////////

//=============================================================================
// REG/WIRE declarations
//=============================================================================

// Touch panel signal //
wire	[7:0]	ltm_r;		//	LTM Red Data 8 Bits
wire	[7:0]	ltm_g;		//	LTM Green Data 8 Bits
wire	[7:0]	ltm_b;		//	LTM Blue Data 8 Bits
wire			ltm_nclk;	//	LTM Clcok
wire			ltm_hd;
wire			ltm_vd;
wire			ltm_den;
wire 			adc_dclk;
wire 			adc_cs;
wire 			adc_penirq_n;
wire 			adc_busy;
wire 			adc_din;
wire 			adc_dout;
wire 			adc_ltm_sclk;
wire			ltm_grst;
// LTM Config//
wire			ltm_sclk;
wire			ltm_sda;
wire			ltm_scen;
wire 			ltm_3wirebusy_n;

wire	[11:0] 	x_coord;
wire	[11:0] 	y_coord;
wire			new_coord;
wire	[2:0]	photo_cnt;
// clock
wire 			F_CLK;// flash read clock
reg 	[31:0] 	div;
// sdram to touch panel timing
wire			mRead;
wire	[15:0]	Read_DATA1;
wire	[15:0]	Read_DATA2;
//  flash to sdram sdram
wire	[7:0]   sRED;// flash to sdram red pixel data
wire	[7:0]	sGREEN;// flash to sdram green pixel data
wire	[7:0]	sBLUE;// flash to sdram blue pixel data
wire			sdram_write_en; // flash to sdram write control
wire			sdram_write; // sdram write signal
// system reset
wire			DLY0;
wire			DLY1;
wire			DLY2;

wire [7:0] read_data_r;
wire [7:0] read_data_g;
wire [7:0] read_data_b;

//=============================================================================
// Structural coding
//=============================================================================

assign	adc_penirq_n  =GPIO_CLKIN_N0;
assign	adc_dout    =GPIO_0[0];
assign	adc_busy    =GPIO_CLKIN_P0;
assign	GPIO_0[1]	=adc_din;
assign	GPIO_0[2]	=adc_ltm_sclk;
assign	GPIO_0[3]	=ltm_b[3];
assign	GPIO_0[4]	=ltm_b[2];
assign	GPIO_0[5]	=ltm_b[1];
assign	GPIO_0[6]	=ltm_b[0];
assign	GPIO_0[7]	=~ltm_nclk;
assign	GPIO_0[8]	=ltm_den;
assign	GPIO_0[9]	=ltm_hd;
assign	GPIO_0[10]	=ltm_vd;
assign	GPIO_0[11]	=ltm_b[4];
assign	GPIO_0[12]	=ltm_b[5];
assign	GPIO_0[13]	=ltm_b[6];
assign	GPIO_CLKOUT_N0	=ltm_b[7];
assign	GPIO_0[14]	=ltm_g[0];
assign	GPIO_CLKOUT_P0	=ltm_g[1];
assign	GPIO_0[15]	=ltm_g[2];
assign	GPIO_0[16]	=ltm_g[3];
assign	GPIO_0[17]	=ltm_g[4];
assign	GPIO_0[18]	=ltm_g[5];
assign	GPIO_0[19]	=ltm_g[6];
assign	GPIO_0[20]	=ltm_g[7];
assign	GPIO_0[21]	=ltm_r[0];
assign	GPIO_0[22]	=ltm_r[1];
assign	GPIO_0[23]	=ltm_r[2];
assign	GPIO_0[24]	=ltm_r[3];
assign	GPIO_0[25]	=ltm_r[4];
assign	GPIO_0[26]	=ltm_r[5];
assign	GPIO_0[27]	=ltm_r[6];
assign	GPIO_0[28]	=ltm_r[7];
assign	GPIO_0[29]	=ltm_grst;
assign	GPIO_0[30]	=ltm_scen;
assign	GPIO_0[31]	=ltm_sda;


assign ltm_grst		= iKEY[0];
assign F_CLK 		= div[3];
assign oFLASH_BYTE_N = 1'b0;
assign {oHEX0_DP,oHEX1_DP,oHEX2_DP,oHEX3_DP,oHEX4_DP,oHEX5_DP,oHEX6_DP,oHEX7_DP}=8'hff;
assign adc_ltm_sclk	= ( adc_dclk & ltm_3wirebusy_n )  |  ( ~ltm_3wirebusy_n & ltm_sclk );

assign oLEDG[1] = mRead;
assign oLEDG[4:3] = test;
assign oLEDG[5] = ltm_hd;
reg [1:0] test;
reg [1:0] test2;
assign ltm_nclk = div[0];
always @(posedge iCLK_50 or negedge iKEY[0]) begin
	if(!iKEY[0]) begin
		test <= 0;
		test2 <= 0;
	end
	else begin
		if(new_coord) begin
			test <= test + 1;
		end
		if(mRead) begin
			test2 <= test2 + 1;
		end
	end
end

always @( posedge iCLK_50 )
	begin
		div <= div+1;
	end

///////////////////////////////////////////////////////////////
lcd_spi_cotroller    u1	   (
							// Host Side
							.iCLK(iCLK_50),
							.iRST_n(DLY0),
							// 3 wire Side
							.o3WIRE_SCLK(ltm_sclk),
							.io3WIRE_SDAT(ltm_sda),
							.o3WIRE_SCEN(ltm_scen),
							.o3WIRE_BUSY_n(ltm_3wirebusy_n)
							);

adc_spi_controller	u2		(
							.iCLK(iCLK_50),
							.iRST_n(DLY0),
							.oADC_DIN(adc_din),
							.oADC_DCLK(adc_dclk),
							.oADC_CS(adc_cs),
							.iADC_DOUT(adc_dout),
							.iADC_BUSY(adc_busy),
							.iADC_PENIRQ_n(adc_penirq_n),
							.oX_COORD(x_coord),
							.oY_COORD(y_coord),
							.oNEW_COORD(new_coord),
							 );

touch_point_detector	u3	(
							.iCLK(iCLK_50),
							.iRST_n(DLY0),
							.iX_COORD(x_coord),
							.iY_COORD(y_coord),
							.iNEW_COORD(new_coord),
							// .iSDRAM_WRITE_EN(sdram_write_en),
							.oPHOTO_CNT(photo_cnt),
							);

SEG7_LUT_8 			u5		(
							.oSEG0(oHEX0_D),
							.oSEG1(oHEX1_D),
							.oSEG2(oHEX2_D),
							.oSEG3(oHEX3_D),
							.oSEG4(oHEX4_D),
							.oSEG5(oHEX5_D),
							.oSEG6(oHEX6_D),
							.oSEG7(oHEX7_D),
							.iDIG({4'h0,x_coord,4'h0,y_coord}),
							.ON_OFF(8'b01110111)
							);

wire [3:0] read_int_data;

lcd_timing_controller	u6  (
							.iCLK(ltm_nclk),
							.iRST_n(DLY2),
							// sdram side
							// .iREAD_DATA_R(read_data_r),
							// .iREAD_DATA_G(read_data_g),
							// .iREAD_DATA_B(read_data_b),
							.iREAD_INT_DATA(read_int_data),
							// .iREAD_DATA1(Read_DATA1),
							// .iREAD_DATA2(Read_DATA2),
							.oREAD_SDRAM_EN(mRead),
							// lcd side
							.oLCD_R(ltm_r),
							.oLCD_G(ltm_g),
							.oLCD_B(ltm_b),
							.oHD(ltm_hd),
							.oVD(ltm_vd),
							.oDEN(ltm_den)
							);


Reset_Delay			u8	   (.iCLK(iCLK_50),
							.iRST(iKEY[0]),
							.oRST_0(DLY0),
							.oRST_1(DLY1),
							.oRST_2(DLY2)
							);

// RGB_ram                 u9 (
// 							.iCLK(iCLK_50),
// 							.iRST_n(DLY1),
// 							.iEnable(mRead),
// 							.oRData(read_data_r),
// 							.oGData(read_data_g),
// 							.oBData(read_data_b)
// );


parameter DATA_WIDTH = 4;
parameter DATA_DEPTH = 12;
wire ram_wren_1;
wire ram_wren_2;
wire [DATA_DEPTH-1:0] ram_addr_1;
wire [DATA_DEPTH-1:0] ram_addr_2;
wire [DATA_WIDTH-1:0] ram_idata_1;
wire [DATA_WIDTH-1:0] ram_idata_2;
wire [DATA_WIDTH-1:0] ram_odata_1;
wire [DATA_WIDTH-1:0] ram_odata_2;

// assign ram_wren_1 = 0;
assign ram_wren_2 = 0;
// assign ram_idata_1 = 0;
assign ram_idata_2 = 0;
assign ram_addr_2 = 0;

// dual_ram #(DATA_WIDTH,DATA_DEPTH,"D:/!Github_coding/fpga_snake_game/python/map.hex") mem_ram(
//                         .iCLK(iCLK_50),
//                         .iRST_n(DLY0),
//                         .iWrite_enable_1(ram_wren_1),
//                         .iWrite_enable_2(ram_wren_2),
//                         .iAddress_1     (ram_addr_1),
//                         .iAddress_2     (ram_addr_2),
//                         .iData_1        (ram_idata_1),
//                         .iData_2        (ram_idata_2),
//                         .oData_1        (ram_odata_1),
//                         .oData_2        (ram_odata_2)
// );

my_ram #(DATA_WIDTH,DATA_DEPTH,"D:/!Github_coding/fpga_snake_game/python/map.hex") intmap(
    .iCLK           (iCLK_50),
    .iRST_n         (DLY0),
    .iWrite_enable  (ram_wren_1),
    .iAddress       (ram_addr_1),
    .iData          (ram_idata_1),
    .oData          (ram_odata_1)
);

wire [15:0] read_lcd_addr;
// assign ram_addr_1 = read_lcd_addr;
// assign read_int_data = ram_odata_1;

intmap_lcd_controller u10(
                        .iCLK(iCLK_50),
                        .iRST_n(DLY0),
                        .iEnable(mRead),
                        .iVsync(ltm_vd),
                        .oAddr(read_lcd_addr)
);

wire [3:0] snake_status;
wire [3:0] snake_readdata;
wire [3:0] snake_writedata;
wire [15:0] snake_addr;
wire [2:0] movement;
wire new_move;

snake_controller u11(
                        .iCLK(iCLK_50),
                        .iRST_n(DLY0),
                        .iMove(movement),
                        .iMapData(snake_readdata),
                        .oMapAddr(snake_addr),
                        .oMapData(snake_writedata),
                        .oStatus(snake_status),
);

arbiter u12(
                        .iCLK(iCLK_50),
                        .iRST_n(DLY0),

                        .iSnakeStatus(snake_status),
                        .iSnakeData(snake_writedata),
                        .iSnakeAddr(snake_addr),
                        .oSnakeData(snake_readdata),

                        .iLcdAddr(read_lcd_addr),
                        .oLcdData(read_int_data),

                        .oMemAddr(ram_addr_1),
                        .iMemReadData(ram_odata_1),
                        .oWriteEnable(ram_wren_1),
                        .oMemWriteData(ram_idata_1),
                        //oStatus() //?
);

coordinate_checker u13(
                    .iCLK(iCLK_50),           // system clock
                    .iRST_n(DLY0),         // system reset 
                    .iX_COORD(x_coord),       // X coordinate from touch panel
                    .iY_COORD(y_coord),       // Y coordinate from touch panel
                    .iNEW_COORD(new_coord),     // new coordinates indicate (this is a bit whack for whatever reason)
                    // .iNEW_TOUCH(new_touch),     // touch panel 
                    // .iTOUCH_IRQ(touch_irq),
                    .oMOVEMENT(movement),      // movement direction (up down left right none)
                    .iADC_PENIRQ_n(adc_penirq_n), // okay this one works >:)
                    .oNEW_MOVE(new_move)       // new movement indicate

);

endmodule

