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

module snake_controller#(parameter ADDR_DEPTH = 16, TIMER_CAP = 70)(
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
// parameter ADDR_DEPTH = 16;
// parameter TIMER_CAP  = 70;//5_000_000; // 5MHz / 50Mhz = 100 ms
// 100;
parameter SNAKE_X = 40, SNAKE_Y = 23; // arena boundary 
parameter STAT_IDLE = 0, STAT_WRITE = 1, STAT_CHECK = 2;
parameter SNAKE_HEADX = 1, SNAKE_HEADY = 5;
parameter SNAKE_TAILX = 15, SNAKE_TAILY = 5;

parameter MOVE_NONE  = 0;
parameter MOVE_UP    = 3'b001; // 1
parameter MOVE_DOWN  = 3'b010; // 2
parameter MOVE_LEFT  = 3'b011; // 3
parameter MOVE_RIGHT = 3'b100; // 4

parameter SNAKE_GRASS = 4'd0;
parameter SNAKE_BODY  = 4'd1;
parameter SNAKE_HEAD  = 4'd2;
parameter SNAKE_FOOD  = 4'd3;
//=============================================================================
// REG/WIRE declarations
//=============================================================================
wire [1:0] qCommand;
reg [DATA_WIDTH-1:0] qixData;
reg [DATA_WIDTH-1:0] qiyData;
wire qReadValid;
wire qWriteValid;
wire [DATA_WIDTH-1:0] qoxData;
wire [DATA_WIDTH-1:0] qoyData;
wire [DATA_WIDTH-1:0] qSize;

reg qPOP, qPUSH;

reg [23:0] move_timer;
reg is_move; // make it a pulse?

reg [3:0] rState;
reg rTrig;
reg [7:0] counter;
reg [7:0] map_counter;
reg [2:0] rLastMove;
reg [2:0] rCurrentMove;
reg [DATA_WIDTH-1:0] rSize;

reg [DATA_WIDTH-1:0] rHeadX;
reg [DATA_WIDTH-1:0] rHeadY;

reg [DATA_WIDTH-1:0] rLastX;
reg [DATA_WIDTH-1:0] rLastY;

reg [DATA_WIDTH-1:0] rCurrentX;
reg [DATA_WIDTH-1:0] rCurrentY;

reg [DATA_WIDTH-1:0] rMapX;
reg [DATA_WIDTH-1:0] rMapY;

reg signed [DATA_WIDTH-1:0] rDistX;
reg signed [DATA_WIDTH-1:0] rDistY;

wire [DATA_WIDTH-1:0] absDistX = (rDistX < 0) ? (8'hFF)*rDistX : rDistX;
wire [DATA_WIDTH-1:0] absDistY = (rDistY < 0) ? (8'hFF)*rDistY : rDistY;

wire signed [DATA_WIDTH-1:0] offsetMapX = (rDistX != 0) ? ((rDistX  > 0) ? 1 : -1) : 0;
wire signed [DATA_WIDTH-1:0] offsetMapY = (rDistY != 0) ? ((rDistY  > 0) ? 1 : -1) : 0;

wire signed [DATA_WIDTH-1:0] offsetX = ~(offsetMapX) + 1; // TODO: (this does not make sense)
wire signed [DATA_WIDTH-1:0] offsetY = ~(offsetMapY) + 1;

reg [DATA_WIDTH-1:0] rFoodX;
reg [DATA_WIDTH-1:0] rFoodY;

reg is_food;
reg is_consumed;

wire TEST = (absDistX & absDistY) ? 1:0; // the distances should not be both non zero
//=============================================================================
// FUNCTIONS/MODULE declarations
//=============================================================================
circular_queue my_queue(
            .iCLK(iCLK),
            .iRST_n(iRST_n),
            .iCommand(qCommand),
            .iXData(qixData),
            .iYData(qiyData),
            .oRValid(qReadValid),
            .oWValid(qWriteValid),
            .oXData(qoxData),
            .oYData(qoyData),
            .oSize(qSize)
);

//=============================================================================
// Structural coding
//=============================================================================
assign qCommand = {qPOP,qPUSH};
assign obeMove = is_move;

/* is_move periodic timing generation */
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

always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        // is_food <= 1;
        rFoodX <= 7;
        rFoodY <= 7;
    end
    else if(is_food)begin
        rFoodX <= (rHeadX * rFoodX) % (SNAKE_X); // sorry no random
        rFoodY <= (rHeadY * rFoodX) % (SNAKE_Y); 
    end
end

parameter IDLE = 0, INIT = 1, WRITE=2, INPUT_WAIT = 3, MOVE = 4;
parameter SSNAKE1 = 5, SSNAKE2 = 6, SSNAKE3 = 7, SSNAKE4 = 8, SSNAKE5 = 9;
parameter DRAW_FOOD = 10;
always @(posedge iCLK or negedge iRST_n) begin
    if(!iRST_n) begin
        rState <= IDLE;
        oStatus <= STAT_IDLE;
        counter <= 0;
        map_counter <= 0;
        rCurrentMove <= 0;
        rLastMove <= 0;
        qPOP  <= 0;
        qPUSH <= 0;
        rTrig <= 0;
        is_consumed <= 0;
        is_food <= 0; // pulse
    end else begin
        /*====  Default Signals ====*/
        rState <= rState;
        oStatus <= oStatus;
        qPOP  <= 0;
        qPUSH <= 0;
        is_food <= 0; // pulse
        /*====  State Machine ======*/
        case (rState)
            IDLE: begin
                rState <= INIT;
            end
            INIT : begin // snake init head
                if(qWriteValid && (!rTrig)) begin
                    rTrig <= 1;
                end
                if(rTrig) begin
                    rTrig <= 0;
                    if(counter < 2) begin
                        counter <= counter + 1;
                    end
                    else begin
                        counter <= 0;
                        rState <= INPUT_WAIT;
                    end
                    if(counter == 0) begin
                        // qixData <= 5;
                        // qiyData <= 6;
                        rHeadX <= 5; // head
                        rHeadY <= 6;
                    end
                    else if(counter == 1) begin
                        qixData <= 5;
                        qiyData <= 10;
                        qPUSH <= 1; 
                    end
                end
            end
            INPUT_WAIT : begin // wait for movement trigger
                oStatus <= STAT_IDLE;
                if(is_move) begin // movement trigger
                    rLastMove <= rCurrentMove;
                    rCurrentMove <= iMove;
                    rState <= MOVE;
                end
            end
            MOVE : begin // update snake movement (and do boundary check)
                // area boundary check
                if(rCurrentMove == MOVE_NONE) begin
                    rState <= INPUT_WAIT; // reject no movement
                end
                else if( 
                    ((rCurrentMove == MOVE_LEFT ) && (rHeadY == SNAKE_Y-1) ) ||
                    ((rCurrentMove == MOVE_RIGHT) && (rHeadY == 0        ) ) ||
                    ((rCurrentMove == MOVE_UP   ) && (rHeadX == SNAKE_X-1) ) ||
                    ((rCurrentMove == MOVE_DOWN ) && (rHeadX == 0        ) )   ) begin
                    rCurrentMove <= rLastMove;
                    rState <= INPUT_WAIT; // boundary check failed
                end
                else if (
                    ((rCurrentMove == MOVE_LEFT ) && (rLastMove == MOVE_RIGHT)) ||
                    ((rCurrentMove == MOVE_RIGHT) && (rLastMove == MOVE_LEFT )) ||
                    ((rCurrentMove == MOVE_UP   ) && (rLastMove == MOVE_DOWN )) ||
                    ((rCurrentMove == MOVE_DOWN ) && (rLastMove == MOVE_UP   ))  ) begin
                    // no going back
                    // rLastMove <= rLastMove;
                    rCurrentMove <= rLastMove;
                    rState <= INPUT_WAIT;
                end
                else begin
                    case (rCurrentMove)
                        MOVE_UP : begin
                            rHeadX <= rHeadX + 1;
                            rHeadY <= rHeadY;
                        end
                        MOVE_DOWN : begin
                            rHeadX <= rHeadX - 1; 
                            rHeadY <= rHeadY; 
                        end
                        MOVE_LEFT : begin
                            rHeadX <= rHeadX; 
                            rHeadY <= rHeadY + 1;
                        end
                        MOVE_RIGHT : begin
                            rHeadX <= rHeadX; 
                            rHeadY <= rHeadY - 1;
                        end
                        default: begin
                            rHeadX <= rHeadX; 
                            rHeadY <= rHeadY;
                        end 
                    endcase
                    rCurrentX <= rHeadX; // original head
                    rCurrentY <= rHeadY;
                    oStatus <= STAT_WRITE; // get write perm for int map
                    rSize <= qSize; // record queue size
                    // qPOP <= 1; // send pop
                    rState <= SSNAKE1;
                end
            end
            SSNAKE1 : begin
                // food 
                if((rHeadX == rFoodX) && (rHeadY == rFoodY)) begin
                    is_consumed <= 1;
                    is_food <= 1;
                end
                // snake
                if(qWriteValid && (!rTrig)) begin
                    rTrig <= 1;
                end
                if(rTrig) begin
                    rTrig <= 0;
                    oMapAddr <= (rHeadY * SNAKE_X) + rHeadX; // paint the new head
                    oMapData <= SNAKE_HEAD;
                    if(rLastMove != rCurrentMove) begin // if the direction is different, put a new node in
                        qixData <= rCurrentX; // original head
                        qiyData <= rCurrentY;
                        qPUSH <= 1;
                    end
                    qPOP <= 1;
                    rState <= SSNAKE2;
                end
            end
            SSNAKE2 : begin // read the nodes
                if(qReadValid && (!rTrig)) begin
                    rTrig <= 1;
                    rMapX <= rCurrentX;
                    rMapY <= rCurrentY;

                    rLastX <= rCurrentX;
                    rLastY <= rCurrentY;
                    rCurrentX <= qoxData;
                    rCurrentY <= qoyData;
                    qPOP <= 0;
                end
                if(rTrig) begin
                    rTrig <= 0;
                    rDistX <= rCurrentX - rLastX;
                    rDistY <= rCurrentY - rLastY;
                    // I need the first iteration to go to SSNAKE3 no matter what
                    rState <= SSNAKE3;
                end
            end
            SSNAKE3 : begin // draaw
                // rTrig <= 1;
                rMapX <= (rDistX != 0) ? (rMapX + offsetMapX) : rMapX;
                rMapY <= (rDistY != 0) ? (rMapY + offsetMapY) : rMapY;
                // I think this is going to make the original head body colored >:(
                oMapAddr <= (rMapY * SNAKE_X) + rMapX;
                oMapData <= SNAKE_BODY;
                if((map_counter < (absDistX + absDistY - 1)) && ((absDistX + absDistY) != 0)) begin
                    map_counter <= map_counter + 1;
                end
                else begin
                    map_counter <= 0;
                    if(counter < (rSize - 1)) begin
                        counter <= counter + 1;
                        rState <= SSNAKE5;
                    end
                    else begin
                        counter <= 0;
                        rState <= SSNAKE4;
                    end
                end
            end
            SSNAKE5 : begin
                if(qWriteValid && (!rTrig)) begin
                    rTrig <= 1;
                end
                if(rTrig) begin
                    rTrig <= 0;
                    qixData <= rCurrentX;
                    qiyData <= rCurrentY;
                    qPUSH <= 1;
                    qPOP <= 1;
                    rState <= SSNAKE2;
                end
            end
            SSNAKE4 : begin // last node
                if(qWriteValid && (!rTrig)) begin
                    rTrig <= 1;
                    rCurrentX <= ((rDistX != 0) && (is_consumed != 1)) ? (rCurrentX + offsetX) : rCurrentX;
                    rCurrentY <= ((rDistY != 0) && (is_consumed != 1)) ? (rCurrentY + offsetY) : rCurrentY;
                    // if(is_consumed) begin
                        // is_food <= 1;
                    is_consumed <= 0;
                    // end
                end
                if(rTrig) begin
                    rTrig <= 0;
                    oMapAddr <= (rCurrentY * SNAKE_X) + rCurrentX;
                    oMapData <= SNAKE_GRASS;
                    if((rCurrentX != rLastX) || (rCurrentY != rLastY)) begin
                        qixData <= rCurrentX;
                        qiyData <= rCurrentY;
                        qPUSH <= 1;
                    end
                    // rState <= INPUT_WAIT;
                    // rState <= WRITE;
                    rState <= DRAW_FOOD;
                end
            end
            DRAW_FOOD : begin
                oMapAddr <= (rFoodY * SNAKE_X) + rFoodX;
                oMapData <= SNAKE_FOOD;
                rState <= WRITE;
            end
            WRITE : begin // okay it actually need this state
                rState <= INPUT_WAIT; 
            end
        endcase
    end
end

endmodule