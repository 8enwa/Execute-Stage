`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 02:17:47 AM
// Design Name: 
// Module Name: riscv_alu
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


module riscv_alu (
    input  wire [4:0] alu_ctrl,  // ALU control signal (5 bits)
    input  wire [63:0] rs1_data,  // Operand 1 (64 bits)
    input  wire [63:0] rs2_data,  // Operand 2 (64 bits)
    output reg  [63:0] alu_result    // ALU result (64 bits)
);

    wire [31:0] rs1_32 = rs1_data[31:0];
    wire [31:0] rs2_32 = rs2_data[31:0];
    reg [63:0] result_64;
    reg [31:0] result_32;

    always @(*) begin
        case (alu_ctrl)
            5'b00000: result_64 = rs1_data + rs2_data;                                                     // Addition (64-bit)
            5'b10000: result_64 = {32'b0, rs1_32 + rs2_32};                                               // Addition (32-bit)
            5'b00001: result_64 = rs1_data - rs2_data;                                                   // Subtraction (64-bit)
            5'b10001: result_64 = {32'b0, rs1_32 - rs2_32};                                             // Subtraction (32-bit)
            5'b00010: result_64 = rs1_data << rs2_data[5:0];                                           // Shift left logical (64-bit)
            5'b10010: result_64 = {32'b0, rs1_32 << rs2_32[4:0]};                                     // Shift left logical (32-bit)
            5'b00011: result_64 = ($signed(rs1_data) < $signed(rs2_data)) ? 64'b1 : 64'b0;           // Set less than (Signed)
            5'b00100: result_64 = (rs1_data < rs2_data) ? 64'b1 : 64'b0;                            // Set less than (Unsigned)
            5'b00101: result_64 = rs1_data ^ rs2_data;                                             // XOR
            5'b00110: result_64 = rs1_data >> rs2_data[5:0];                                      // Shift right logical (64-bit)
            5'b10110: result_64 = {32'b0, rs1_32 >> rs2_32[4:0]};                                // Shift right logical (32-bit)
            5'b00111: result_64 = $signed(rs1_data) >>> rs2_data[5:0];                          // Shift right arithmetic (64-bit)
            5'b10111: result_64 = {32'b0, $signed(rs1_32) >>> rs2_32[4:0]};                    // Shift right arithmetic (32-bit)
            5'b01000: result_64 = rs1_data | rs2_data;                                        // OR
            5'b01001: result_64 = rs1_data & rs2_data;                                       // AND
            5'b01010: result_64 = (rs1_data + rs2_data) & ~64'b1;                           // Jump and link register
            default: result_64 = 64'b0; // Default case
        endcase
        alu_result = result_64;
    end
endmodule

