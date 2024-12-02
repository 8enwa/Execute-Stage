`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 04:09:05 PM
// Design Name: 
// Module Name: tb_riscv_estage
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


`timescale 1ns/1ps

module tb_riscv_estage;
    // Testbench signals
    reg oprnd1sel;
    reg oprnd2sel;
    reg [1:0] fwda;
    reg [1:0] fwdb;
    reg [1:0] storesrc;
    reg [3:0] bcond;
    reg [4:0] aluctrl;
    reg [63:0] pc;
    reg [63:0] rs1data;
    reg [63:0] rs2data;
    reg [63:0] rddata_m;
    reg [63:0] rddata_wb;
    reg [63:0] simm;

    wire [63:0] aluresult;
    wire [63:0] storedata;
    wire branchtaken;

    // Instantiate the DUT (Device Under Test)
    riscv_estage dut (
        .oprnd1sel(oprnd1sel),
        .oprnd2sel(oprnd2sel),
        .fwda(fwda),
        .fwdb(fwdb),
        .storesrc(storesrc),
        .bcond(bcond),
        .aluctrl(aluctrl),
        .pc(pc),
        .rs1data(rs1data),
        .rs2data(rs2data),
        .rddata_m(rddata_m),
        .rddata_wb(rddata_wb),
        .simm(simm),
        .aluresult(aluresult),
        .storedata(storedata),
        .branchtaken(branchtaken)
    );

    // Test vectors
    initial begin
        // Initialize signals
        oprnd1sel = 0; oprnd2sel = 0; fwda = 2'b00; fwdb = 2'b00; storesrc = 2'b00;
        bcond = 4'b0000; aluctrl = 5'b00000; pc = 64'h0; rs1data = 64'h0;
        rs2data = 64'h0; rddata_m = 64'h0; rddata_wb = 64'h0; simm = 64'h0;

        // Apply test cases
        #10; 
        // Test Case 1: Direct operand usage
        rs1data = 64'hA; rs2data = 64'hB; simm = 64'hC; pc = 64'h10;
        fwda = 2'b00; fwdb = 2'b00; oprnd1sel = 0; oprnd2sel = 0;
        aluctrl = 5'b00001; // Assume ADD operation
        #10;

        // Test Case 2: Forwarding paths
        fwda = 2'b01; rddata_m = 64'h20; // Forwarding from Memory
        fwdb = 2'b10; rddata_wb = 64'h30; // Forwarding from Write-Back
        #10;

        // Test Case 3: Immediate operand selection
        oprnd2sel = 1; simm = 64'h40;
        #10;

        // Test Case 4: Store source selection
        storesrc = 2'b01; // Select rddata_m
        #10;
        storesrc = 2'b10; // Select rddata_wb
        #10;

        // Test Case 5: Branch conditions
        bcond = 4'b0001; // Example branch condition (e.g., equal)
        rs1data = 64'h50; rs2data = 64'h50; // Equal values
        #10;

        bcond = 4'b0010; // Example branch condition (e.g., not equal)
        rs1data = 64'h60; rs2data = 64'h70; // Not equal values
        #10;

        // Test Case 6: ALU edge cases
        oprnd1sel = 1; oprnd2sel = 0; pc = 64'h100;
        aluctrl = 5'b00010; // Example ALU operation (e.g., SUB)
        #10;

        oprnd1sel = 0; oprnd2sel = 1; simm = 64'h80;
        aluctrl = 5'b00011; // Example ALU operation (e.g., AND)
        #10;

        // Finish simulation
        $stop;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t | ALUResult: %h | StoreData: %h | BranchTaken: %b", 
                 $time, aluresult, storedata, branchtaken);
    end
endmodule

