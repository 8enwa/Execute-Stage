`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 10:18:05 PM
// Design Name: 
// Module Name: first_operand_mux
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


module first_operand_mux (
    input  sel,            // Select signal (1-bit)
    input  [63:0] pc,      // Program Counter value
    input  [63:0] rs1,     // Rs1 value from register
    output reg [63:0] a    // Output: Selected operand
);

    always @(*) begin
        if (sel)
            a = pc;        // Select PC as the first operand
        else
            a = rs1;       // Select Rs1 as the first operand
    end

endmodule

