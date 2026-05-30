/*

+-----------+
| snake     |
| controller|
+-----------+
    |
+---------+      +-----+
| arbiter |------| RAM |
|         |      |     |
+---------+      +-----+
*/

module snake_controller(
    input                       iCLK,               // system clock
    input                       iRST_n,             // system reset
    input  [2:0]                iMove,              // movement input
    input  [3:0]                iMapData, // int map RAM control
    output reg [ADDR_DEPTH-1:0] oMapAddr,
    output reg [3:0]            oMapData,
    output reg [3:0]            oStatus

    /*port declarations*/
);

//=============================================================================
// PARAMETER declarations
//=============================================================================
parameter DATA_WIDTH = 8; // for the queue
parameter ADDR_DEPTH = 16;
parameter TIMER_CAP  = 5_000_000; // 5MHz / 50Mhz = 100 ms

parameter SNAKE_X = 40, SNAKE_Y = 20; // boundary 
parameter STAT_IDLE = 0, STAT_WRITE = 1, STAT_CHECK = 2;

parameter MOVE_NONE  = 0;
parameter MOVE_UP    = 3'b001; // 1
parameter MOVE_DOWN  = 3'b010; // 2
parameter MOVE_LEFT  = 3'b011; // 3
parameter MOVE_RIGHT = 3'b100; // 4

//=============================================================================
// REG/WIRE declarations
//=============================================================================
wire [1:0] qCommand;
reg [DATA_WIDTH-1:0] qixData;
reg [DATA_WIDTH-1:0] qiyData;
wire qreadValid;
wire qwriteValid;
wire [DATA_WIDTH-1:0] qoxData;
wire [DATA_WIDTH-1:0] qoyData;
wire [DATA_WIDTH-1:0] qSize;

reg rPOP, rPUSH;

reg [23:0] move_timer;
reg is_move; // make it a pulse?

reg [3:0] rState;
reg [15:0] counter;
//=============================================================================
// FUNCTIONS/MODULE declarations
//=============================================================================
circular_queue my_queue(
            .iCLK(iCLK),
            .iRST_n(iRST_n),
            .iCommand(qCommand),
            .iXData(qixData),
            .iYData(qiqData),
            .oRValid(qreadValid),
            .oWValid(qwriteValid),
            .oXData(qoxData),
            .oYData(qoyData),
            .oSize(qSize)
);

//=============================================================================
// Structural coding
//=============================================================================
assign qCommand = {rPOP,rPUSH};
assign obeMove = is_move;

// is_move periodic timing generation
always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        move_timer <= 0;
        is_move <= 0;
    end
    else if(move_timer < TIMER_CAP) begin
        move_timer <= move_timer + 1;
        is_move <= 0;
    end
    else begin
        move_timer <= 0;
        is_move <= 1; // pulse
    end
end

parameter IDLE = 0, INIT = 1, WRITE=2, WAIT = 3, MOVE = 4;
always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        rState <= IDLE;
        oStatus <= STAT_IDLE;
    end else begin
        /*====  Default Signals ====*/
        rState <= rState;
        oStatus <= oStatus;
        /*====  State Machine ======*/
        case (rState)
            IDLE: begin
                if(qwriteValid) begin
                    rState <= INIT;
                end
            end
            INIT : begin
                // initialize the snake here
                // rPUSH <= 1;
                qixData <= 5;
                qiyData <= 6;
                
                // qixData <= test_counter % SNAKE_X;
                // qiyData <= test_counter % SNAKE_Y;
                rState <= WAIT; 
            end
            WAIT : begin
                oStatus <= STAT_IDLE;
                if(is_move) begin
                    rState <= MOVE;
                end
            end
            MOVE : begin
                // area boundary check
                if( ((iMove == MOVE_LEFT ) && (qiyData == SNAKE_Y-1) ) ||
                    ((iMove == MOVE_RIGHT) && (qiyData == 0        ) ) ||
                    ((iMove == MOVE_UP   ) && (qixData == SNAKE_X-1) ) ||
                    ((iMove == MOVE_DOWN ) && (qixData == 0        ) ) )
                begin
                    // do nothing
                end
                else begin
                    // surely this is fine nope
                case (iMove)
                    MOVE_UP : begin
                        qixData <= qixData + 1;
                        qiyData <= qiyData;
                    end
                    MOVE_DOWN : begin
                        qixData <= qixData - 1; 
                        qiyData <= qiyData; 
                    end
                    MOVE_LEFT : begin
                        qixData <= qixData; 
                        qiyData <= qiyData + 1;
                    end
                    MOVE_RIGHT : begin
                        qixData <= qixData; 
                        qiyData <= qiyData - 1;
                    end
                    default: begin
                        qixData <= qixData; 
                        qiyData <= qiyData;
                    end 
                endcase
                end
                oStatus <= STAT_WRITE;
                rState <= WRITE;
            end
            WRITE : begin
                oMapAddr <= qiyData*SNAKE_X + qixData;
                oMapData <= 2;
                rState <= WAIT; 
            end
        endcase
    end
end


// test later
// task my_task(input [3:0] X,input [3:0] Y);
// begin
//   qixData <= X;
//   qiyData <= Y;
// end
// endtask

endmodule