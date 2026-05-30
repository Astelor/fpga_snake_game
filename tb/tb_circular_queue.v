module tb_circular_queue;

//=============================================================================
// PARAMETER declarations
//=============================================================================
parameter PUSH = 0, POP = 1; // bit position

//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg clk=0;
reg reset=1;
wire[1:0] command;
reg [7:0] ixdata;
reg [7:0] iydata;
wire [7:0] oxdata;
wire [7:0] oydata;
wire dvalid;
wire wvalid;
reg iPOP = 0;
reg iPUSH = 0;

assign command = {iPOP, iPUSH};

//=============================================================================
// FUNCTIONS/MODULE declarations
//=============================================================================

circular_queue bruh(
            .iCLK(clk),    // system clock
            .iRST_n(reset),  // system reset
            .iCommand(command), // surely two bits are enough            
            .iXData(ixdata),
            .iYData(iydata),
            .oXData(oxdata),
            .oYData(oydata),
            .oRValid(dvalid),
            .oWValid(wvalid)
);

//=============================================================================
// Structural coding
//=============================================================================

always begin
    #5 clk = ~clk;
end

initial begin
    #10 reset <= 0;
    #10  reset <= 1;
    #30
    $stop;
end

reg [1:0] div;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        div <= 0;
    end
    else begin
        div <= div + 1;
    end
end

always @(posedge clk) begin
    ixdata <= $random&8'hff;
    iydata <= $random&8'hff;
    if(wvalid) begin
        iPUSH <= 1;
    end
    else begin
        iPUSH <= 0;
    end
end
endmodule