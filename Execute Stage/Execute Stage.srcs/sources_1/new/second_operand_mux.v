`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 10:23:30 PM
// Design Name: 
// Module Name: second_operand_mux
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


module second_operand_mux (
    input  sel,              // Select signal (1-bit)
    input  [63:0] rs2,       // Value from register rs2
    input  [63:0] simm,      // Sign-extended immediate value
    output reg [63:0] b      // Output: Selected operand
);

    always @(*) begin
        if (sel)
            b = simm;        // Select Sign-extended immediate as the second operand
        else
            b = rs2;         // Select Rs2 as the second operand
    end

endmodule

