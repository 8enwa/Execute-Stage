`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 09:55:21 PM
// Design Name: 
// Module Name: forward_a_mux
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


module forward_a_mux (
    input  [1:0] sel,       // Select signal (2-bit)
    input  [63:0] rs1,      // Rs1 data (from Execute stage)
    input  [63:0] rd_wb,    // Rd data (from Write Back stage)
    input  [63:0] rd_mem,   // Rd data (from Memory stage)
    output reg [63:0] new_rs1 // Output selected Rs1 data
);

    always @(*) begin
        case (sel)
            2'b00: new_rs1 = rs1;   // Select Rs1 from Execute stage
            2'b01: new_rs1 = rd_mem; // Select Rd from Memory stage
            2'b10: new_rs1 = rd_wb;  // Select Rd from Write Back stage
            default: new_rs1 = rs1; // Default to Rs1
        endcase
    end

endmodule

