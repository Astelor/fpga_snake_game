module tb_snake_controller;
//=============================================================================
// PARAMETER declarations
//=============================================================================

//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg clk=0;
reg reset=1;
reg [2:0] movement = 0;
reg [3:0] iMapData = 0;
wire [15:0] oMapAddr;
wire [3:0]  oMapData;
wire [3:0] oStatus;

wire [7:0] coord_X = oMapAddr%40;
wire [7:0] coord_Y = oMapAddr/40;
//=============================================================================
// FUNCTIONS/MODULE declarations
//=============================================================================

snake_controller bruh(
    .iCLK(clk),               // system clock
    .iRST_n(reset),             // system reset
    .iMove(movement),              // movement input
    .iMapData(iMapData), // int map RAM control
    .oMapAddr(oMapAddr),
    .oMapData(oMapData),
    .oStatus(oStatus)
);

//=============================================================================
// Structural coding
//=============================================================================

always begin
    #5 clk = ~clk;
end

initial begin
    #10 reset <= 0;
    #10 reset <= 1;
    #30
    $stop;
end

endmodule