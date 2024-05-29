`timescale 1ns / 1ps


module ControlUnit (
    input       clk,
    input       reset,
    // input       LE10,
    input [7:0] outPort,

    output [13:0] machineCode
);

    enum logic [3:0] {
        S0,
        S1,
        S2,
        S3,
        S4,
        S5,
        S6,
        S7,
        S8,
        S9,
        S10,
        S11
    }
        state, state_next;

    logic       RFSrcMuxSel;
    logic [2:0] raddr1;
    logic [2:0] raddr2;
    logic [2:0] waddr;
    logic       wr_en;
    logic [1:0] ALUop;
    logic       OutLoad;


    assign machineCode = {
        RFSrcMuxSel, raddr1, raddr2, waddr, wr_en, ALUop, OutLoad
    };


    always_ff @(posedge clk, posedge reset) begin
        if (reset) state <= S0;
        else state <= state_next;
    end


    always_comb begin
        state_next = state;

        case (state)
            S0: state_next = S1;
            S1: state_next = S2;
            S2: state_next = S3;
            S3: state_next = S4;
            S4: state_next = S5;
            S5: state_next = S6;
            S6: state_next = S7;
            S7: state_next = S8;
            S8: state_next = S9;
            S9: state_next = S10;
            S10: state_next = S10;
            default: state_next = state;
        endcase
    end


    always_comb begin
        RFSrcMuxSel = 1'b0;
        raddr1      = 3'd0;
        raddr2      = 3'd0;
        waddr       = 3'd0;
        wr_en       = 1'b0;
        ALUop       = 2'b00;
        OutLoad     = 1'b0;

        case (state)
            S0: begin  // R1 = 0
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd1;
                wr_en       = 1'b1;
                ALUop       = 2'b00;
                OutLoad     = 1'b0;
            end
            S1: begin  // R2 = 0
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd2;
                wr_en       = 1'b1;
                ALUop       = 2'b00;
                OutLoad     = 1'b0;
            end
            S2: begin  // R3 = 1
                RFSrcMuxSel = 1'b1;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd3;
                wr_en       = 1'b1;
                ALUop       = 2'b00;
                OutLoad     = 1'b0;
            end
            S3: begin  // R1 = R1 + R3
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd1;
                raddr2      = 3'd3;
                waddr       = 3'd1;
                wr_en       = 1'b1;
                ALUop       = 2'b00;
                OutLoad     = 1'b0;
            end
            S4: begin  // R2 = R2 + R3
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd2;
                raddr2      = 3'd3;
                waddr       = 3'd2;
                wr_en       = 1'b1;
                ALUop       = 2'b00;
                OutLoad     = 1'b0;
            end
            S5: begin  // R3 = R1 - R2
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd1;
                raddr2      = 3'd2;
                waddr       = 3'd3;
                wr_en       = 1'b1;
                ALUop       = 2'b01;
                OutLoad     = 1'b0;
            end
            S6: begin  // R4 = R1 & R3
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd1;
                raddr2      = 3'd3;
                waddr       = 3'd4;
                wr_en       = 1'b1;
                ALUop       = 2'b10;
                OutLoad     = 1'b0;
            end
            S7: begin  // R5 = R2 | R3
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd2;
                raddr2      = 3'd3;
                waddr       = 3'd5;
                wr_en       = 1'b1;
                ALUop       = 2'b11;
                OutLoad     = 1'b0;
            end
            S8: begin  // R6 = R1 + R2
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd1;
                raddr2      = 3'd2;
                waddr       = 3'd6;
                wr_en       = 1'b1;
                ALUop       = 2'b00;
                OutLoad     = 1'b0;
            end
            S9: begin  // R7 = R2 + R6
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd2;
                raddr2      = 3'd6;
                waddr       = 3'd7;
                wr_en       = 1'b1;
                ALUop       = 2'b00;
                OutLoad     = 1'b0;
            end
            S10: begin  // output
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd7;
                raddr2      = 3'd7;
                waddr       = 3'd0;
                wr_en       = 1'b0;
                ALUop       = 2'b00;
                OutLoad     = 1'b1;
            end
            default: begin
                RFSrcMuxSel = 1'b0;
                raddr1      = 3'd0;
                raddr2      = 3'd0;
                waddr       = 3'd0;
                wr_en       = 1'b0;
                OutLoad     = 1'b0;
            end
        endcase
    end
endmodule
