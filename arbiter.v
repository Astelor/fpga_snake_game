// this is an all wire box :)
/*
something like this...?
+--------------+       +-------------+
|intmap        |       | snake       |
|lcd controller|---+   | controller  |
+--------------+   |   +-------------+
                   |      |
+------+    +--------+    |
| RAM  |----| arbiter|----+
|      |    |        |
+------+    +--------+
*/
module arbiter(
    input                       iCLK,               // system clock
    input                       iRST_n,             // system reset
    
    input  [3:0]                iSnakeStatus,       // snake controller
    input  [3:0]                iSnakeData,         // write data 
    input  [ADDR_DEPTH-1:0]     iSnakeAddr,

    output reg [3:0]            oSnakeData,         // read data
    
    input  [ADDR_DEPTH-1:0]     iLcdAddr,           // intmap LCD controller
    output reg [3:0]            oLcdData,

    input  [3:0]                iMemReadData,           // RAM (aka the int map)
    output reg [ADDR_DEPTH-1:0] oMemAddr,
    output reg                  oWriteEnable,
    output reg [3:0]            oMemWriteData, // data to be written to the RAM
    
    output reg [3:0]            oStatus // not sure what I am going to do with this
    /*port declarations*/
);
//=============================================================================
// PARAMETER declarations
//=============================================================================
parameter DATA_WIDTH = 4;
parameter ADDR_DEPTH = 16;
parameter STAT_IDLE = 0, STAT_WRITE = 1, STAT_CHECK = 2;

//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg [3:0] rState;

//=============================================================================
// FUNCTIONS/MODULE declarations
//=============================================================================

//=============================================================================
// Structural coding
//=============================================================================

parameter IDLE=0, SNAKE_WRITE=1,SNAKE_CHECK=2;
always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        rState <= IDLE;
    end else begin
        /*====  Default Signals ====*/
        rState <= rState;
        /*====  State Machine ======*/
        case (rState)
            IDLE: begin // give RAM to intmap_lcd_controller
                oWriteEnable <= 0;
                oMemAddr <= iLcdAddr;
                oLcdData <= iMemReadData;
                if(iSnakeStatus == STAT_WRITE) begin
                    rState <= SNAKE_WRITE;
                end
            end
            SNAKE_WRITE: begin
                oWriteEnable <= 1;
                oMemAddr <= iSnakeAddr;
                oSnakeData <= iMemReadData;
                oMemWriteData <= iSnakeData; 
                if(iSnakeStatus == STAT_IDLE) begin
                    rState <= IDLE;
                end
            end
        endcase
    end
end

endmodule