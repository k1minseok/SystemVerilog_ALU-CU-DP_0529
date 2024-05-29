`timescale 1ns / 1ps

module DataPath (
    input        clk,
    input        reset,
    // input       RFSrcMuxSel,
    // input [1:0] raddr1,
    // input [1:0] raddr2,
    // input [1:0] waddr,
    // input       wr_en,
    // input [1:0] ALUop,
    // input       OutLoad,
    input [13:0] machineCode,
    // machineCode = {RFSrcMuxSel(13), raddr1(12:10), raddr2(9:7), waddr(6:4), wr_en(3), ALUop(2:1), OutLoad(0)};

    // output       LE10,
    output [7:0] outPort
);

    logic [7:0] w_RFSrcMuxOut, w_OpResult, w_rdata1, w_rdata2;


    mux_2x1 U_Mux_RFSrc (
        // .sel(RFSrcMuxSel),
        .sel(machineCode[13]),
        .a  (w_OpResult),
        .b  (8'b1),

        .y(w_RFSrcMuxOut)  // logic : 4 state(reg+wire)
    );

    RegisterFile U_RF (
        .clk  (clk),
        // .wr_en(wr_en),
        // .waddr(waddr),
        .wr_en(machineCode[3]),
        .waddr(machineCode[6:4]),
        .wdata(w_RFSrcMuxOut),

        // .raddr1(raddr1), 
        // .raddr2(raddr2),
        .raddr1(machineCode[12:10]),
        .raddr2(machineCode[9:7]),

        .rdata1(w_rdata1),
        .rdata2(w_rdata2)
    );

    // Op U_Op (
    //     .a(w_rdata1),
    //     .b(w_rdata2),

    //     .y(w_OpResult)
    // );
    ALU U_ALU (
        .a(w_rdata1),
        .b(w_rdata2),
        // .ALUop(ALUop),
        .ALUop(machineCode[2:1]),

        .y(w_OpResult)
    );

    // comparator U_Comp (
    //     .a(w_rdata1),
    //     .b(8'd10),

    //     .le(LE10)
    // );

    register U_OutReg (
        .clk  (clk),
        .reset(reset),
        .load (machineCode[0]),
        .d    (w_rdata2),

        .q(outPort)
    );


endmodule


module RegisterFile (
    input       clk,
    input       wr_en,
    input [2:0] waddr,
    input [7:0] wdata,

    input [2:0] raddr1,  // address range : 000 ~ 111 8개
    input [2:0] raddr2,

    output [7:0] rdata1,
    output [7:0] rdata2
);

    logic [7:0] regFile[0:7];  // 8bit register 8개

    always_ff @(posedge clk) begin
        if (wr_en) regFile[waddr] <= wdata;
    end

    // regfile[0]은 0 고정 -> raddr == 0이면 0반환
    assign rdata1 = (raddr1 != 0) ? regFile[raddr1] : 0;
    assign rdata2 = (raddr2 != 0) ? regFile[raddr2] : 0;
    // raddr != 0 이면 클럭과 상관없이 값이 반환됨

endmodule


module mux_2x1 (
    input       sel,
    input [7:0] a,
    input [7:0] b,

    output logic [7:0] y  // logic : 4 state(reg+wire)
);

    always_comb begin : mux_2x1  // 논리회로
        case (sel)
            1'b0: y = a;
            1'b1: y = b;
        endcase
    end
endmodule


module register (
    input       clk,
    input       reset,
    input       load,
    input [7:0] d,

    output logic [7:0] q
);

    always_ff @(posedge clk, posedge reset) begin : register  // Flip-Flop형태
        if (reset) begin
            q <= 0;
        end else begin
            if (load) q <= d;
        end
    end : register
    // : register -> 주석같은 느낌, 여기가 always문 끝이라는걸 나타냄, 없어도됨
endmodule


module comparator (
    input [7:0] a,
    input [7:0] b,

    output le
);
    assign le = (a <= b);
endmodule


module ALU (
    input [7:0] a,
    input [7:0] b,
    input [1:0] ALUop,

    output logic [7:0] y
);
    enum logic [1:0] {
        ADD = 2'b00,
        SUB = 2'b01,
        AND = 2'b10,
        OR  = 2'b11
    } alu_op_t;

    always_comb begin
        case (ALUop)
            ADD: y = a + b;
            SUB: y = a - b;
            OR: y = a | b;
            AND: y = a & b;
            default: y = 8'b0;
        endcase
    end
endmodule


// module subtractor (
//     input [7:0] a,
//     input [7:0] b,

//     output [7:0] y
// );
//     assign y = a - b;
// endmodule


// module AND (
//     input [7:0] a,
//     input [7:0] b,

//     output [7:0] y
// );
//     assign y = a & b;
// endmodule


// module OR (
//     input [7:0] a,
//     input [7:0] b,

//     output [7:0] y
// );
//     assign y = a | b;
// endmodule
