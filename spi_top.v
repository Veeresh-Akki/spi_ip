`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2023 18:25:10
// Design Name: 
// Module Name: spi_top
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


module spi_top #(parameter data=32,addr=32)(
    input wire PRESETn,
    input wire PSEL,
	input wire PCLK,
	input wire PENABLE,
	input wire PWRITE,
	
	input wire [addr-1:0] PADDR,
	input wire [data-1:0] PWDATA,
	input wire miso,
	
	//output wire [7:0]spisr,
    
	output wire [data-1:0] PRDATA,
	output wire ss,
	output wire sclk,
	output wire mosi
    );
    
    // input output wires
    wire clk;
    wire [data-1:0] MWDATA,MRDATA;  
    wire [addr-1:0] MADDR;
    wire [7:0]SPICR_1,SPICR_2,SPIBDR,SPISR;
   // wire clock,clkd,reset;
    
    //clk_div clkdivider(.clock(PCLK),.reset(PRESETn),.clkd(clkd));
    
    
    spi_controller SPI_CONTROLLER(
//PCLK(clkd),
   .PCLK(PCLK),
    .PSEL(PSEL),
	.PRESETn(PRESETn),
	.PWRITE(PWRITE),
	.PADDR(PADDR),
	.PWDATA(PWDATA),
	.MRDATA(MRDATA), 
	.SPISR(SPISR),    
	//.spisr(spisr),
	.clk(clk),
	.MADDR(MADDR),
	.MWDATA(MWDATA),                     
	.PRDATA(PRDATA),
	.SPICR_1(SPICR_1),
	.SPICR_2(SPICR_2),
	.SPIBDR(SPIBDR)
    );
    
    spi_master SPI_MASTER(
    .PCLK(clk),
    .PRESETn(PRESETn),
    .miso(miso),
    .MADDR(MADDR),
    .MWDATA(MWDATA),
    .SPICR_1(SPICR_1),                    // 7-6 RESERVED 5-SPIF, 4-SPE, 3-MSTR, 2-CPOL, 1-CPHASE, 0-LSBFE
    .SPICR_2(SPICR_2),                    // 7 to 1-RESERVED, 0-SPC0
    .SPISR(SPISR),                        // 7-3 RESERVED 2-TXCR 1-TXCW 0-SPTEF                
    .MRDATA(MRDATA),
    .ss(ss),
    .sclk(sclk),
    .mosi(mosi)  
    );
    
endmodule
