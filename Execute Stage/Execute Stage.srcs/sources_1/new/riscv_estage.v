`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 03:53:46 PM
// Design Name: 
// Module Name: riscv_estage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module riscv_estage (
    // Inputs
    input wire oprnd1sel,       // Operand 1 Select (1-bit)
    input wire oprnd2sel,       // Operand 2 Select (1-bit)
    input wire [1:0] fwda,      // Forward A Select (2-bit)
    input wire [1:0] fwdb,      // Forward B Select (2-bit)
    input wire [1:0] storesrc,  // Store Source Select (2-bit)
    input wire [3:0] bcond,     // Branch Condition (4-bit)
    input wire [4:0] aluctrl,   // ALU Control (5-bit)
    input wire [63:0] pc,       // Program Counter (64-bit)
    input wire [63:0] rs1data,  // RS1 Data (64-bit)
    input wire [63:0] rs2data,  // RS2 Data (64-bit)
    input wire [63:0] rddata_m, // Rd Data from Memory (64-bit)
    input wire [63:0] rddata_wb,// Rd Data from Write Back (64-bit)
    input wire [63:0] simm,     // Sign-extended Immediate (64-bit)

    // Outputs
    output wire [63:0] aluresult,   // ALU Result (64-bit)
    output wire [63:0] storedata,  // Store Data (64-bit)
    output wire branchtaken        // Branch Taken (1-bit)
);

    // Intermediate signals
    wire [63:0] new_rs1;  // Forwarded RS1 data
    wire [63:0] new_rs2;  // Forwarded RS2 data
    wire [63:0] operand_a; // Operand A for ALU
    wire [63:0] operand_b; // Operand B for ALU
    reg [63:0] store_mux_out; // Store data after mux selection

    // Forwarding A Mux
    forward_a_mux forward_a (
        .sel(fwda),
        .rs1(rs1data),
        .rd_mem(rddata_m),
        .rd_wb(rddata_wb),
        .new_rs1(new_rs1)
    );

    // Forwarding B Mux
    forward_b_mux forward_b (
        .sel(fwdb),
        .rs2(rs2data),
        .rd_mem(rddata_m),
        .rd_wb(rddata_wb),
        .new_rs2(new_rs2)
    );

    // First Operand Mux
    first_operand_mux operand1_mux (
        .sel(oprnd1sel),
        .pc(pc),
        .rs1(new_rs1),
        .a(operand_a)
    );

    // Second Operand Mux
    second_operand_mux operand2_mux (
        .sel(oprnd2sel),
        .rs2(new_rs2),
        .simm(simm),
        .b(operand_b)
    );

    // ALU Module
    riscv_alu alu (
        .alu_ctrl(aluctrl),
        .rs1_data(operand_a),
        .rs2_data(operand_b),
        .alu_result(aluresult)
    );

    // Branch Comparator Module
    branch_comparator branch_cmp (
        .branch_cond(bcond),
        .rs1(new_rs1),
        .rs2(new_rs2),
        .branch_taken(branchtaken)
    );

    // Store Source Mux
    always @(*) begin
        case (storesrc)
            2'b00: store_mux_out = rs2data;    // Select RS2
            2'b01: store_mux_out = rddata_m;  // Select Memory Data
            2'b10: store_mux_out = rddata_wb; // Select Write Back Data
            default: store_mux_out = rs2data; // Default to RS2
        endcase
    end

    assign storedata = store_mux_out;

endmodule
