// true dual port RAM
module dual_ram #(parameter DEPTH=10, WIDTH=4, INIT_FILE="D:/!Github_coding/fpga_snake_game/intmap.hex")(
    input                     iCLK,
    input                     iRST_n,       
    input                     iWrite_enable_1,
    input                     iWrite_enable_2,
    input [DEPTH-1:0]         iAddress_1,
    input [DEPTH-1:0]         iAddress_2,
    input      [WIDTH-1:0]    iData_1,
    input      [WIDTH-1:0]    iData_2,
    output reg [WIDTH-1:0]    oData_1,
    output reg [WIDTH-1:0]    oData_2
);
//parameter DEPTH = 8; // 2^8 = 256 depth = 8

(* ramstyle = "M4K" *)
reg [WIDTH-1:0] rMemory [ (1 << DEPTH)-1 :0];

initial begin
  $readmemh(INIT_FILE, rMemory);
end

// PORT 1
always @(posedge iCLK) begin
  if(iWrite_enable_1) begin
    rMemory[iAddress_1] <= iData_1;
    // oData_1 <= iData_1; // dual port RAM synthesize requirement
  end 
  else begin
    oData_1 <= rMemory[iAddress_1];
  end
end

// PORT 2
always @(posedge iCLK) begin
  if(iWrite_enable_2) begin
    rMemory[iAddress_2] <= iData_2;
    // oData_2 <= iData_2; // dual port RAM synthesize requirement
  end 
  else begin
    oData_2 <= rMemory[iAddress_2];
  end
end

endmodule