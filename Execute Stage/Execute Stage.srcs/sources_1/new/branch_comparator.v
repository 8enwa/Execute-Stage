`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 07:54:06 PM
// Design Name: 
// Module Name: branch_comparator
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


module branch_comparator (
    input  [3:0] branch_cond, // Branch condition: beq, bne, etc.
    input  [63:0] rs1,        // Source register 1 data
    input  [63:0] rs2,        // Source register 2 data
    output reg branch_taken   // Branch decision: 1 if branch is taken, 0 otherwise
);

    always @(*) begin
        case (branch_cond)
            4'b0000: branch_taken = (rs1 == rs2);                  // beq
            4'b0001: branch_taken = (rs1 != rs2);                  // bne
            4'b0010: branch_taken = ($signed(rs1) < $signed(rs2)); // blt (signed)
            4'b0011: branch_taken = ($signed(rs1) >= $signed(rs2));// bge (signed)
            4'b0110: branch_taken = (rs1 < rs2);                   // bltu (unsigned)
            4'b0111: branch_taken = (rs1 >= rs2);                  // bgeu (unsigned)
            default: branch_taken = 1'b0;                          // Default: no branch
        endcase
    end

endmodule

