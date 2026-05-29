// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
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
// Major Functions:	This function will transmit the lcd register setting 
//            
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            		:| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Fan				:| 07/06/30  :| Initial Revision
// --------------------------------------------------------------------
module lcd_spi_cotroller (//	Host Side
                                iCLK,           /* 50Mhz clock */
                                iRST_n,         /* reset active low */
                                //	3wire interface side
                                o3WIRE_SCLK,    /* spi clock */
                                io3WIRE_SDAT,   /* spi data */
                                o3WIRE_SCEN,    /* spi chip enable, active low */
                                o3WIRE_BUSY_n   /* spi busy, activae low  */
                                );
//============================================================================
// PARAMETER declarations
//============================================================================						
parameter	LUT_SIZE	=	20; // Total setting register numbers 
//===========================================================================
// PORT declarations
//===========================================================================
//	Host Side
output 		o3WIRE_BUSY_n; /* spi busy, activae low  */
input		  iCLK;          /* 50Mhz clock */
input		  iRST_n;        /* reset active low */
//	3wire interface side
output		o3WIRE_SCLK;   /* spi clock */
inout		  io3WIRE_SDAT;  /* spi data */
output		o3WIRE_SCEN;   /* spi chip enable, active low */
//	Internal Registers/Wires
//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg         m3wire_str;
wire        m3wire_rdy;
wire        m3wire_ack;
wire        m3wire_clk;
reg [15:0]  m3wire_data;
reg [15:0]  lut_data; // to m3wiredata
reg [5:0]   lut_index;
reg [3:0]   msetup_st;
reg         o3WIRE_BUSY_n;
wire        v_reverse; // display Vertical reverse function
wire        h_reverse; // display Horizontal reverse function
wire [9:0]  g0;    
wire [9:0]  g1; 
wire [9:0]  g2;
wire [9:0]  g3;
wire [9:0]  g4;
wire [9:0]  g5;
wire [9:0]  g6;
wire [9:0]  g7;
wire [9:0]  g8;
wire [9:0]  g9;
wire [9:0]  g10;
wire [9:0]  g11;

//=============================================================================
// Structural coding
//=============================================================================

assign h_reverse = 1'b1;
assign v_reverse = 1'b0;

three_wire_controller u0 ( // Host Side
                                .iCLK(iCLK),       /* 50Mhz clock */
                                .iRST(iRST_n),     /* reset active low */
                                .iDATA(m3wire_data),/* Data sent by SPI */
                                .iSTR(m3wire_str), /* spi start */
                                .oACK(m3wire_ack), /* spi acknowledge*/
                                .oRDY(m3wire_rdy), /* spi ready */
                                .oCLK(m3wire_clk), /* spi clock */
                           // Serial Side
                                .oSCEN(o3WIRE_SCEN), /* to spi chip enable */
                                .SDA(io3WIRE_SDAT),  /* to spi dat*/
                                .oSCLK(o3WIRE_SCLK)  /* to spi clk */
                          );
//////////////////////	Config Control	////////////////////////////
always@(posedge m3wire_clk or negedge iRST_n) begin // finite state machine
     if(!iRST_n) begin
         lut_index <= 0;
         msetup_st <= 0; /* idle */
         m3wire_str    <= 0;
         o3WIRE_BUSY_n <= 0;
     end
     else  begin
         /*=== hold value ===*/
         lut_index     <= lut_index;
         msetup_st     <= msetup_st; 
         m3wire_str    <= m3wire_str;
         o3WIRE_BUSY_n <= o3WIRE_BUSY_n;
         /*=== hold value end ===*/
         
         if(lut_index<LUT_SIZE) begin
            o3WIRE_BUSY_n  <=  0;
            case(msetup_st)
            0: begin /* idle */
                  msetup_st <=  1;
               end
            1: begin /* wait 1 clock */
                  msetup_st <=  2;
               end

            2: begin /* get next lut data */
                  m3wire_data   <=  lut_data;
                  m3wire_str    <=  1; /* send start to controller */
                  msetup_st     <=  3; /* jump to state 3*/
               end
            3: begin
                  if(m3wire_rdy) begin
                     if(m3wire_ack)
                        msetup_st   <=  4; 
                     else
                        msetup_st   <=  0;
                     m3wire_str      <=  0; /* deactivate controller */
                  end
               end
            4: begin /* take next lut data*/
                  lut_index <=  lut_index+1; /* lut_index +1 */
                  msetup_st <=  0;
               end
            endcase
         end
         else 
            o3WIRE_BUSY_n  <=  1;
      end
end

assign g0 =106;   /*0x6A  */
assign g1 =200;   /*0xCB  */
assign g2 =289;   /*0x121 */
assign g3 =375;   /*0x177 */
assign g4 =460;   /*0x1CC */
assign g5 =543;   /*0x21F */
assign g6 =625;   /*0x271 */
assign g7 =705;   /*0x2C1 */
assign g8 =785;   /*0x311 */
assign g9 =864;   /*0x360 */
assign g10 = 942; /*0x3AE */
assign g11 = 1020;/*0x3FC */

///////////////////// Config Data LUT   //////////////////////////	
always begin
   #1 // so in simulation the tool is not going to implode :)
     case(lut_index) /* Addr[5:0], R/W[0], Hiz[0], Data[7:0] */
     0  : lut_data <= {6'h11, 2'b01,g0[9:8],g1[9:8],g2[9:8],g3[9:8]}; /* gamma correction */
     1  : lut_data <= {6'h12, 2'b01,g4[9:8],g5[9:8],g6[9:8],g7[9:8]}; /* gamma correction */
     2  : lut_data <= {6'h13, 2'b01,g8[9:8],g9[9:8],g10[9:8],g11[9:8]}; /* gamma correction */
     3  : lut_data <= {6'h14, 2'b01,g0[7:0]}; /* gamma correction */
     4  : lut_data <= {6'h15, 2'b01,g1[7:0]}; /* gamma correction */
     5  : lut_data <= {6'h16, 2'b01,g2[7:0]}; /* gamma correction */
     6  : lut_data <= {6'h17, 2'b01,g3[7:0]}; /* gamma correction */
     7  : lut_data <= {6'h18, 2'b01,g4[7:0]}; /* gamma correction */
     8  : lut_data <= {6'h19, 2'b01,g5[7:0]}; /* gamma correction */
     9  : lut_data <= {6'h1a, 2'b01,g6[7:0]}; /* gamma correction */
     10 : lut_data <= {6'h1b, 2'b01,g7[7:0]}; /* gamma correction */
     11 : lut_data <= {6'h1c, 2'b01,g8[7:0]}; /* gamma correction */
     12 : lut_data <= {6'h1d, 2'b01,g9[7:0]}; /* gamma correction */
     13 : lut_data <= {6'h1e, 2'b01,g10[7:0]}; /* gamma correction */
     14 : lut_data <= {6'h1f, 2'b01,g11[7:0]}; /* gamma correction */
     15 : lut_data <= {6'h20, 2'b01,4'hf,4'h0};/* positive gamma output voltage level for source driver input */
     16 : lut_data <= {6'h21, 2'b01,4'hf,4'h0};/* negative  gamma output voltage level for source driver input */
     17 : lut_data <= {6'h03, 2'b01, 8'hdf};   /* Software selection for resolution and standby, Pre-charge enable, 
                                                  Driving capability 150%, PWM enable, VGL pump enable, 
                                                  CP_CLK  enable, Normal operation */
     18 : lut_data <= {6'h02, 2'b01, 8'h07};   /* [7:6]Dot inversion method selection type 1,
                                                  [5] VD polarity LOW pulse 
                                                  [4] HD polarity LOW pulse 
                                                  [3] Input clock latch data edge->Latch data at NCLK falling edge
                                                  [2:0] Resolution selection -> 800RGBx480
                                               */
     19 : lut_data <= {6'h04, 2'b01, 6'b000101,!v_reverse,!h_reverse};
                                                /*[5:4] VGL pump frequenct -> 1*H(~32KHz)
                                                  [3:2] CP_CLK frequency -> 1*H(~32KHz)
                                                  [1]  Vertical reverse function -> Normal
                                                  [0]  Horizontal reverse function -> Reverse
                                                */
     default  : lut_data <= 16'h0000;
     endcase
end
////////////////////////////////////////////////////////////////////

endmodule