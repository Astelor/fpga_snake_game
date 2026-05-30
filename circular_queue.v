module circular_queue(
    input                       iCLK,    // system clock
    input                       iRST_n,  // system reset
    input  [1:0]                iCommand, //bit 0 -> push, bit 1 -> pop            
    input  [DATA_WIDTH-1:0]     iXData,
    input  [DATA_WIDTH-1:0]     iYData,
    output                      oRValid, // tell the outside that fifo read data is valid
    output reg                  oWValid, // tell outside fifo writing is ready
    output reg [DATA_WIDTH-1:0] oXData,
    output reg [DATA_WIDTH-1:0] oYData,
    output     [DATA_WIDTH-1:0] oSize    // size of the fifo queue 

    /*port declarations*/
);

//=============================================================================
// PARAMETER declarations
//=============================================================================
parameter PUSH = 0, POP = 1; // bit position for the command
parameter IDLE=0, WRITE=1, INCADR=2, WAIT=3;
parameter DATA_WIDTH = 8;
parameter ADDR_DEPTH = 16;
parameter ReadData=1, ReadReq=2;

//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg [DATA_WIDTH-1:0] xdata, ydata;
wire xrdreq, yrdreq;
wire xsclear, ysclear;
wire xwrreq, ywrreq;
wire xempty, yempty;
wire xfull, yfull;
wire [DATA_WIDTH-1:0] xq, yq;
wire [DATA_WIDTH-1:0] xusedw, yusedw;

// technicall we only need one set of read and write control
reg [2:0]  rState1;
reg [2:0]  rState2;
reg rDwrite;
reg rDread;
reg rReadvalid;
wire mFull;
wire mEmpty;

//=============================================================================
// FUNCTIONS/MODULE declarations
//=============================================================================

new_fifo xfifo( // quartus generated IP core
    // input
    .clock(iCLK),
	.data(xdata), // input data
	.rdreq(xrdreq), // read request
	.sclr(xsclear), // synchronous clear
	.wrreq(xwrreq), // write request

    // output
	.empty(xempty),
	.full(xfull),
	.q(xq), // output data
	.usedw(xusedw)
);

new_fifo yfifo( // quartus generated IP core
    // input
    .clock(iCLK),
	.data(ydata), // input data
	.rdreq(yrdreq), // read request
	.sclr(ysclear), // synchronous clear
	.wrreq(ywrreq), // write request

    // output
	.empty(yempty),
	.full(yfull),
	.q(yq), // output data
	.usedw(yusedw)
);

//=============================================================================
// Structural coding
//=============================================================================

assign xwrreq = rDwrite;
assign ywrreq = rDwrite;

assign xrdreq = rDread;
assign yrdreq = rDread;

assign mFull = xfull & yfull;
assign mEmpty = xempty & yempty;

assign oRValid = rReadvalid;
assign oSize = xusedw & yusedw;

// assign xsclear = 0;
// assign ysclear = 0;

// write control
always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        rState1 <= IDLE;
        rDwrite <= 0;
    end else begin
        /*==== To hold signals ====*/
        rState1 <= rState1;
        rDwrite <= 0;
        oWValid <= 0;
        /*==== To hold signals end ====*/
        case (rState1)
            IDLE: begin
                oWValid <= 1;
                if(iCommand[PUSH]) begin
                    xdata <= iXData;
                    ydata <= iYData;
                    rState1 <= WAIT;
                end
            end
            WAIT: begin
                if (!mFull) begin
                    rState1 <= WRITE;
                end
            end
            WRITE: begin
                rDwrite <= 1;
                rState1 <= INCADR;
            end
            INCADR: begin /* increase number */
                rState1 <= IDLE;
            end
        endcase
    end
end

// read control
always@(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        rState2 <= IDLE;
        rDread <= 0;
        rReadvalid <= 0;
    end else begin
        /*==== To hold signals ====*/
        rState2 <= rState2;
        rDread <= 0;
        rReadvalid <= 0;
        /*==== To hold signals end ====*/

        case (rState2)
            IDLE: begin /* wait button to start */
                if(iCommand[POP]) begin /* press buttion */
                    rState2 <= WAIT;
                end
            end
            WAIT: begin /* wait clock to trig */
                if(!mEmpty) begin /* wait ~iReadEmty */
                    rState2 <= ReadReq;
                end
            end
            ReadReq: begin /* send request */
                rDread <= 1;
                rState2 <= ReadData;
            end
            ReadData: begin /* read valid data */
                oXData <=  xq;
                oYData <=  yq;
                rReadvalid <= 1; // data valid
                rState2 <= IDLE;
            end
        endcase
    end
end

endmodule