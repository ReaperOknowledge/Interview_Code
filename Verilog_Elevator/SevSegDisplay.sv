`timescale 1ns / 1ps



module SevSegDisplay(
    input   [1:0] floorSel,
    input         door, 

    output logic [6:0] segments,  //GFEDCBA Display open or closed door
    output logic [3:0] select     // select
);
    always_comb
    begin
    
        segments = 7'b1000011;
        select   = 4'b0001;
        
        case(floorSel)
        
            2'b00:
            begin
                select = 4'b1110;
                if(door == 1) segments = 7'b1000011;
                else          segments = 7'b0100011;
            end  
            
            2'b01:
            begin
                select = 4'b1101;
                if(door == 1) segments = 7'b1000011;
                else          segments = 7'b0100011;
            end  
            
            2'b10:
            begin
                select = 4'b1011;
                if(door == 1) segments = 7'b1000011;
                else          segments = 7'b0100011;
            end  
            
            2'b11:
            begin
                select = 4'b0111;
                if(door == 1) segments = 7'b1000011;
                else          segments = 7'b0100011;
            end  
        endcase
    
    end

endmodule
