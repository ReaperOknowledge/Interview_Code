`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 04:56:25 PM
// Design Name: 
// Module Name: SevSegDisplay_tb
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


module SevSegDisplay_tb(

    );
    logic [1:0] floorSel;
    logic       door;
    logic [6:0] segments;
    logic [3:0] select;
    
    SevSegDisplay ssd(.floorSel, .door, .segments, .select);
    
    logic [3:0]index;
    
    initial begin
    
    floorSel = 2'b0;
    door = 0;
    
    for(index = 0; index < 4; index++)
    begin
        #5
        if(door == 1 && segments != 7'b1000011) $fatal(1, "segment and door1");
        if(door == 0 && segments != 7'b0100011) $fatal(1, "segment and door2");
    
        if(floorSel == 2'b00 && select != 4'b1110) $fatal(1,"select and floorsel");
        if(floorSel == 2'b01 && select != 4'b1101) $fatal(1,"select and floorsel");
        if(floorSel == 2'b10 && select != 4'b1011) $fatal(1,"select and floorsel");
        if(floorSel == 2'b11 && select != 4'b0111) $fatal(1,"select and floorsel");
        floorSel++;
    end
    
    door = 1;
    for(index = 0; index < 4; index++)
    begin
        #5
        if(door == 1 && segments != 7'b1000011) $fatal(1, "segment and door1");
        if(door == 0 && segments != 7'b0100011) $fatal(1, "segment and door2");
    
        if(floorSel == 2'b00 && select != 4'b1110) $fatal(1,"select and floorsel");
        if(floorSel == 2'b01 && select != 4'b1101) $fatal(1,"select and floorsel");
        if(floorSel == 2'b10 && select != 4'b1011) $fatal(1,"select and floorsel");
        if(floorSel == 2'b11 && select != 4'b0111) $fatal(1,"select and floorsel");
        floorSel++;
    end
   
    $display("@@@Passed");
    $finish;
    end
endmodule
