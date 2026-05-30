/*
+-----------+
| timing    |
| controler |-----+
+-----------+     |
                  |
+-------+    +-------+
|arbiter|----| this  |
|       |----| module|
+-------+    +-------+
*/

module intmap_lcd_controller(
    input              iCLK,               // system clock
    input              iRST_n,             // system reset
    input              iEnable,            // pulse from the timing controller
    input              iVsync, // skill issue
    output reg [15:0]  oAddr
    /*port declarations*/
);

//=============================================================================
// PARAMETER declarations
//=============================================================================
parameter DEPTH = 16;
parameter WIDTH = 4;

parameter X_RESOLUTION = 8'd40;
parameter Y_RESOLUTION = 8'd40;

parameter X_LENGTH = 8'd20;
parameter Y_LENGTH = 8'd20;

parameter COUNTER_CAP = 24'd384000; // this is not used 

//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg [23:0] rCounter;
reg [20:0] x;
reg [20:0] y;
reg rEn;
//=============================================================================
// FUNCTIONS/MODULE declarations
//=============================================================================

//=============================================================================
// Structural coding
//=============================================================================

// assign x = (rCounter/X_LENGTH) % X_RESOLUTION;
// assign y = (rCounter/(X_LENGTH * Y_LENGTH * X_RESOLUTION));// % Y_RESOLUTION; 

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        rEn <= 0;
    end
    else if(iEnable) begin
        rEn <= (!rEn) & iEnable;
    end
    else begin
        rEn <= 0;
    end
end

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        rCounter <= 0;
    end
    else if(rEn) begin
        // if(rCounter < COUNTER_CAP) begin
            rCounter <= rCounter + 1;
        // end
        // else begin
            // rCounter <= 0;
        // end
    end
    else if(!iVsync) begin
        rCounter <= 0;
    end
    else begin
        rCounter <= rCounter;
    end
end

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        oAddr <= 0;
        x<=0;
        y<=0;
    end
    else if(rEn) begin
        oAddr <= ((y * X_RESOLUTION) + x);
        x <= (rCounter/X_LENGTH) % X_RESOLUTION;
        y <= (rCounter/(X_LENGTH * Y_LENGTH * X_RESOLUTION)) % Y_RESOLUTION; 

        // oAddr <= ((rCounter/X_LENGTH) % X_RESOLUTION) + (rCounter/(X_LENGTH * Y_LENGTH * X_RESOLUTION)*X_RESOLUTION);
    end
    else begin
        oAddr <= oAddr;
    end
end


endmodule