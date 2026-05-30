// Current iteration: one pixel with set amount of width

module coordinate_checker (
    input           iCLK,           // system clock
    input           iRST_n,         // system reset 
    input   [11:0]  iX_COORD,       // X coordinate from touch panel
    input   [11:0]  iY_COORD,       // Y coordinate from touch panel
    input           iNEW_COORD,     // new coordinates indicate (this is a bit whack for whatever reason)
    input           iNEW_TOUCH,     // touch panel 
    input           iTOUCH_IRQ,     // touch panel interrupt
    output  [2:0]   oMOVEMENT,      // movement direction (up down left right none)
    input           iADC_PENIRQ_n,
    output          oNEW_MOVE       // new movement indicate
);

//=============================================================================
// PARAMETER declarations
//=============================================================================
parameter middle_X = 12'h800; // for left and right
parameter middle_Y = 12'hc00; // for up and down
parameter CTRL_X1 = 12'h600;
parameter CTRL_Y1 = 12'hB00;
parameter CTRL_X2 = 12'hA00;
parameter CTRL_Y2 = 12'hD00;

parameter NONE       = 0;
parameter MOVE_UP    = 3'b001; // 1
parameter MOVE_DOWN  = 3'b010; // 2
parameter MOVE_LEFT  = 3'b011; // 3
parameter MOVE_RIGHT = 3'b100; // 4

parameter TIMER = 5_000_000; // 5MHz/50MHz = 100ms
parameter IDLE=0, JUDGE=1, WAIT=2;
//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg [11:0] mX_COORD;
reg [11:0] mY_COORD;
reg [11:0] mX_COORD_1;
reg [11:0] mY_COORD_1;
reg [2:0] mMOVEMENT;

reg mNEW_MOVE;
reg mNEW_TOUCH;
reg mNEW_COORD;
reg [23:0] mTimer;
reg [3:0] mState;
reg mtrig;
reg mStartTimer;

//=============================================================================
// Structural coding
//=============================================================================

assign oMOVEMENT = mMOVEMENT;
assign oNEW_MOVE = mNEW_MOVE;

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        mNEW_TOUCH <= 0;
        mNEW_COORD <= 0;
    end
    else begin
        mNEW_TOUCH <= iNEW_TOUCH;
        mNEW_COORD <= iNEW_COORD;
    end
end

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        mState <= IDLE;
        mtrig <= 0;
        mTimer <= 0;
        // mStartTimer <= 0;
    end
    else begin
        mState <= mState;
        mtrig <= 0;
        case (mState)
            IDLE : begin
                if(mNEW_COORD) begin
                    mState <= JUDGE;
                end
            end 
            JUDGE : begin
                if(mNEW_MOVE) begin // new move sent -> judge finished
                    mState <= WAIT;
                end
                mtrig <= 1;
            end
            WAIT : begin
                if(mTimer < TIMER) begin
                    mTimer <= mTimer + 1;
                end
                else begin
                    mTimer <= 0;
                    mState <= IDLE;
                end
            end
        endcase
    end
end

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        mX_COORD <= 0;
        mY_COORD <= 0;
        mX_COORD_1 <= 0; 
        mY_COORD_1 <= 0; 
    end
    else begin
        mX_COORD/*_1*/ <= iX_COORD;
        mY_COORD/*_1*/ <= iY_COORD;
        // mX_COORD   <= mX_COORD_1;
        // mY_COORD   <= mY_COORD_1;
    end
end

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        mMOVEMENT <= NONE;
        mNEW_MOVE <= 0;
    end
    else if(/*~iADC_PENIRQ_n*/mtrig) begin
            mNEW_MOVE <= 1;
            if( (mY_COORD < CTRL_Y1) && (mX_COORD > CTRL_X1) && (mX_COORD < CTRL_X2))
                mMOVEMENT <= MOVE_UP;
            else if( (mY_COORD > CTRL_Y2) && (mX_COORD > CTRL_X1) && (mX_COORD < CTRL_X2))
                mMOVEMENT <= MOVE_DOWN;
            else if( (mX_COORD < CTRL_X1))
                mMOVEMENT <= MOVE_LEFT;
            else if( (mX_COORD > CTRL_X2))
                mMOVEMENT <= MOVE_RIGHT;
            else
                mMOVEMENT <= NONE;
    end
    else begin
        // mMOVEMENT <= NONE;
        mNEW_MOVE <= 0;
    end
end

endmodule