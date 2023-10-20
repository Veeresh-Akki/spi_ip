`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2023 22:47:16
// Design Name: 
// Module Name: spi_controller
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

module spi_controller #(parameter data=32,addr=32)(
    input PCLK,
    input PSEL,
	input PRESETn,
	input PWRITE,
	
	input [addr-1:0] PADDR,
	input [data-1:0] PWDATA,     // to write the data
	input [data-1:0] MRDATA,     // to read the data
	
	input [7:0]SPISR,            // 7-SPIF, 6-RESERVED, 5-SPTEF, 4-MODF, 3 to 0-RESERVED     
	
	//output [7:0]spisr,          // 7-SPIF, 6-RESERVED, 5-SPTEF, 4-MODF, 3 to 0-RESERVED

    output wire clk,
    
	output reg [addr-1:0]MADDR=0,
	output reg [data-1:0]MWDATA=0,                     
	output reg [data-1:0]PRDATA=0,
	
	output reg [7:0]SPICR_1,     // 7-RESERVED 6-SPE, 5-SPTIE, 4-MSTR, 3-CPOL, 2-CPHASE, 1-SSOE, 0-LSBFE
	output reg [7:0]SPICR_2,     // 7 to 1-RESERVED, 0-SPC0
	output reg [7:0]SPIBDR     // 7-RESERVED 6-SPPR2, 5-SPPR1, 4-SPPR0, 3-RESERVED, 2-SPR2, 1-SPR1, 0-SPR0   
    );
	 
	 assign clk = (divisor==4'd1)?PCLK:clk_2;
	 
	//assign spisr=SPISR;
	
	reg [1:0] current_state,next_state;
	reg clk_2;
	reg [3:0] counter = 4'd0;
    reg [3:0] divisor = 4'd0;
	
	always@(posedge PCLK) 
	begin
        if(PADDR[7:0] == 8'h00 && PSEL==1'b1) 
        begin 
			if(PWRITE == 1) 
			begin                                             
                SPICR_1[7:0] <= PWDATA[7:0];          // REGISTER CONFIGURATION   SPICR-1  /*WRITE CONFIG*/
                SPICR_2[7:0] <= PWDATA[15:8];         // REGISTER CONFIGURATION   SPICR-2
                SPIBDR[7:0] <= PWDATA[23:16];         // BAUD RATE CONGIGURATION
		    end
					
		    else 
		    begin                                           
//                 SPICR_1[7:0] <= PWDATA[7:0];          // REGISTER CONFIGURATION   SPICR-1 /*READ CONFIG*/
//                 SPICR_2[7:0] <= PWDATA[15:8];         // REGISTER CONFIGURATION   SPICR-2
//                 SPIBDR[7:0] <= PWDATA[23:16];         // BAUD RATE CONGIGURATION
                 
                 PRDATA[7:0] <= SPISR;
			end			
		end
				
		else if(PADDR[7:0] == 8'h04 && PWRITE == 1) 
		begin                                               
			 MWDATA[31:0] <= PWDATA[31:0];
		end
					
		else if(PADDR[7:0] == 8'h08 && PWRITE == 0)
        begin                                            
            PRDATA <= MRDATA;
        end
        
		else 
		begin
		     MADDR=PADDR;
	    end
    end
    
    always@(posedge PCLK)
    begin
        if(SPIBDR[6:4]==3'b000 && SPIBDR[2:0]==3'b000)
            divisor <= 4'd1;
        else if(SPIBDR[6:4]==3'b000 && SPIBDR[2:0]==3'b001)
            divisor <= 4'd2;
        else if(SPIBDR[6:4]==3'b000 && SPIBDR[2:0]==3'b010)
            divisor <= 4'd4;
        else if(SPIBDR[6:4]==3'b000 && SPIBDR[2:0]==3'b011)
            divisor <= 4'd8;
        else
            divisor <= 4'd1;
  
        if(divisor>4'd1)
         begin
             counter <= counter + 4'd1;
             if(counter >= (divisor-1))
             counter <= 4'd0;
             clk_2 <= (counter<divisor/2)?1'b1:1'b0;
         end   
    end    
endmodule





