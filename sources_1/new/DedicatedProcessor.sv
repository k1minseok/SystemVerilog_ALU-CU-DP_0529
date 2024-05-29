`timescale 1ns / 1ps

module DedicatedProcessor (
    input clk,
    input reset,

    output [7:0] outPort
);

    // logic       RFSrcMuxSel;
    // logic [1:0] raddr1;
    // logic [1:0] raddr2;
    // logic [1:0] waddr;
    // logic       wr_en;
    // logic [1:0] ALUop;
    // logic       OutLoad;
    // logic       LE10;

    logic [13:0] machineCode;

    ControlUnit U_ControlUnit (
        .*  // .* : 이름 똑같은 포트끼리 자동 연결
    );


    DataPath U_DataPath (.*);

endmodule
