`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 03:11:22 PM
// Design Name: 
// Module Name: exec_stage
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


module exec_stage (
    input wire i_riscv_estage_oprnd1sel,
    input wire i_riscv_estage_oprnd2sel,
    input wire [1:0] i_riscv_estage_fwda,
    input wire [1:0] i_riscv_estage_fwdb,
    input wire [1:0] i_riscv_estage_storesrc,
    input wire [3:0] i_riscv_estage_bcond,
    input wire [4:0] i_riscv_estage_aluctrl,
    input wire [63:0] i_riscv_estage_pc,
    input wire [63:0] i_riscv_estage_rs1data,
    input wire [63:0] i_riscv_estage_rs2data,
    input wire [63:0] i_riscv_estage_rddata_m,
    input wire [63:0] i_riscv_estage_rddata_wb,
    input wire [63:0] i_riscv_estage_simm,
    output wire [63:0] o_riscv_estage_aluresult,
    output wire [63:0] o_riscv_estage_storedata,
    output wire o_riscv_estage_branchtaken
);

    // Forward A MUX
    wire [63:0] forward_a_output;
    forward_a_mux u_fwda_mux (
        .i_riscv_fwdae_ctrl(i_riscv_estage_fwda),
        .i_riscv_fwdae_rs1data(i_riscv_estage_rs1data),
        .i_riscv_fwdae_rdwb(i_riscv_estage_rddata_wb),
        .i_riscv_fwdae_rdm(i_riscv_estage_rddata_m),
        .o_riscv_fwdae_newrs1(forward_a_output)
    );

    // Forward B MUX
    wire [63:0] forward_b_output;
    forward_b_mux u_fwdb_mux (
        .i_riscv_fwdbe_ctrl(i_riscv_estage_fwdb),
        .i_riscv_fwdbe_rs2data(i_riscv_estage_rs2data),
        .i_riscv_fwdbe_rdwb(i_riscv_estage_rddata_wb),
        .i_riscv_fwdbe_rdm(i_riscv_estage_rddata_m),
        .o_riscv_fwdbe_newrs2(forward_b_output)
    );

    // First Operand MUX
    wire [63:0] operand1;
    first_operand_mux u_amux (
        .i_riscv_amux_sel(i_riscv_estage_oprnd1sel),
        .i_riscv_amux_pc(i_riscv_estage_pc),
        .i_riscv_amux_rs1(forward_a_output),
        .o_riscv_amux_a(operand1)
    );

    // Second Operand MUX
    wire [63:0] operand2;
    second_operand_mux u_bmux (
        .i_riscv_bmux_sel(i_riscv_estage_oprnd2sel),
        .i_riscv_bmux_rs2(forward_b_output),
        .i_riscv_bmux_simm(i_riscv_estage_simm),
        .o_riscv_bmux_b(operand2)
    );

    // ALU
    wire alu_branch_condition;
    alu u_alu (
        .i_riscv_alu_a(operand1),
        .i_riscv_alu_b(operand2),
        .i_riscv_alu_ctrl(i_riscv_estage_aluctrl),
        .o_riscv_alu_result(o_riscv_estage_aluresult),
        .o_riscv_alu_branchcond(alu_branch_condition)
    );

    // Branch Condition Module
    branch_condition u_bc (
        .i_riscv_bc_bcond(i_riscv_estage_bcond),
        .i_riscv_bc_alucond(alu_branch_condition),
        .o_riscv_bc_branchtaken(o_riscv_estage_branchtaken)
    );

    // Store Data MUX
    store_data_mux u_stmux (
        .i_riscv_storesrc_ctrl(i_riscv_estage_storesrc),
        .i_riscv_storesrc_rs2data(forward_b_output),
        .i_riscv_storesrc_imm(i_riscv_estage_simm),
        .o_riscv_storesrc_data(o_riscv_estage_storedata)
    );

endmodule




