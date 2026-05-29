// ram? ram? ram? ram?
// single port ram
module my_ram #(parameter DATA_WIDTH = 4, ADDRESS_DEPTH = 16, INIT_FILE="D:/!Github_coding/fpga_snake_game/intmap.hex")(
    input                           iCLK,               // system clock
    input                           iRST_n,             // system reset
    input                           iWrite_enable,
    input      [ADDRESS_DEPTH-1:0]  iAddress,
    input      [DATA_WIDTH-1   :0]  iData,
    output reg [DATA_WIDTH-1   :0]  oData
    /*port declarations*/
);

//=============================================================================
// PARAMETER declarations
//=============================================================================

// parameter INIT_FILE = "D:/!Github_coding/fpga_snake_game/python/rhex.hex";

//=============================================================================
// REG/WIRE declarations
//=============================================================================
(* ramstyle = "M4K" *)
reg [DATA_WIDTH-1:0] rMemory [(1 << ADDRESS_DEPTH)-1:0];

// integer i;
//=============================================================================
// Structural coding
//=============================================================================
initial begin
    $readmemh(INIT_FILE, rMemory);
    // for (i = 0; i < (1 << ADDRESS_DEPTH); i = i + 1)
    //     rMemory[i] = i[7:0];
    // case (CHOOSE)
    //     1 : begin
    //         $readmemh("D:/!Github_coding/fpga_snake_game/quartus/hex/rhex.hex", rMemory);
    //     end
    //     2 : begin
    //         $readmemh("D:/!Github_coding/fpga_snake_game/quartus/hex/ghex.hex", rMemory);
    //     end
    //     3 : begin
    //         $readmemh("D:/!Github_coding/fpga_snake_game/quartus/hex/bhex.hex", rMemory);
    //     end
    // endcase
end
always @(posedge iCLK /*or negedge iRST_n*/) begin
    // if(!iRST_n) begin
    //     oData <= 0;
    //     // do nothing
    // end
    if(iWrite_enable) begin
        rMemory[iAddress] <= iData;
        // oData <= iData;
    end
    else begin
        oData <= rMemory[iAddress];
    end
end


endmodule