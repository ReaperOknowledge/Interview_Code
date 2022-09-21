`timescale 1ns / 1ps


module ElevCtrl(
    input        clk, //clock
    input        rst, //reset
    input [3:0]  floorBtn,

    output logic [1:0] floorSel,
    output logic       door
);

enum {FLOOR1_OPEN, FLOOR1_CLOSED, FLOOR2_OPEN, FLOOR2_CLOSED, FLOOR3_OPEN, FLOOR3_CLOSED, FLOOR4_OPEN, FLOOR4_CLOSED} state, nextState, prevState;
logic [3:0] floorb;
wire doorTemp = door;
integer dest;
integer currentFloor;


always_ff @(posedge clk) begin
    if(rst) begin
        state <= FLOOR1_OPEN;
//        floorb <= floorBtn;
    end
    else begin 
        state <= nextState;
//        floorb <= floorBtn;
    end
end



always_comb begin
    nextState = state;
    dest = 1;
    currentFloor = 1;
    floorSel = 'b00;
    door = 1;
//    floorb = 0;
    
//    if(doorTemp) floorb = floorBtn;
    
    if(door & floorBtn == 'b0001 || rst) begin
        dest = 1;
    end
    else if(door & floorBtn == 'b0010) begin
        dest = 2;
    end
    else if(door & floorBtn == 'b0100) begin
        dest = 3;
    end
    else if(door & floorBtn == 'b1000) begin
        dest = 4;
    end
//    else if(floorBtn == 'b0000) begin
//        nextState = state;
//    end
        
    case(state)

        FLOOR1_OPEN:
            begin
                floorSel = 'b00;
                currentFloor = 1;
                door = 1;
                

                if(currentFloor < dest) begin
                    nextState = FLOOR1_CLOSED;
                end       
              if(floorBtn == 'b0000) nextState = FLOOR1_OPEN;    
             end
             
            FLOOR1_CLOSED:
            begin
                floorSel = 'b00;
                currentFloor = 1;
                door = 0;
               
                if(dest == currentFloor) nextState = FLOOR1_OPEN;
                else if(currentFloor < dest) nextState = FLOOR2_CLOSED;   
                if(floorBtn == 'b0000) nextState = FLOOR1_CLOSED;       
             end
       
            FLOOR2_OPEN:
            begin
                floorSel = 'b01;
                currentFloor = 2;
                door = 1;
                $display("###FloorBtn %b F2OPEN###", floorBtn);
                if(dest != currentFloor) nextState = FLOOR2_CLOSED;
                if(floorBtn == 'b0000) nextState = FLOOR2_OPEN;           
             end
             
            FLOOR2_CLOSED:
            begin
                floorSel = 'b01;
                currentFloor = 2;
                door = 0;
                
//                $display("###dest:%d###", dest);
              
               
               if(dest == currentFloor) nextState = FLOOR2_OPEN;
               else if(dest > currentFloor) nextState = FLOOR3_CLOSED;

               else if(dest < currentFloor) nextState = FLOOR1_CLOSED;  
               if(floorBtn == 'b0000) nextState = FLOOR2_CLOSED;  
                    
             end
                  
             
            
        FLOOR3_OPEN:
            begin
                floorSel = 'b10;
                currentFloor = 3;
                door = 1;
                
                
                if(dest != currentFloor) begin
                    nextState = FLOOR3_CLOSED;
                    $display(" ### F3 ### floorBtn:%b, dest:%b, currentFloor:%b", floorBtn, dest, currentFloor);                   
                end
                
                if(floorBtn == 'b0000) begin
                    nextState = FLOOR3_OPEN;  
                end
             end
             
        FLOOR3_CLOSED:
            begin
                floorSel = 'b10;
                currentFloor = 3;
                door = 0;
                
               
                if(dest == currentFloor) nextState = FLOOR3_OPEN;
                else if(dest > currentFloor) nextState = FLOOR4_CLOSED;
                else if(dest < currentFloor) nextState = FLOOR2_CLOSED;    
                
                if(floorBtn == 'b0000) begin
                    nextState = FLOOR3_CLOSED;  
                end               
             end
            
        FLOOR4_OPEN:
            begin
                floorSel = 'b11;
                currentFloor = 4;
                door = 1;
                
                 

                if(dest < currentFloor) nextState = FLOOR4_CLOSED; 
                
                if(floorBtn == 'b0000) nextState = FLOOR4_OPEN;               
             end
             
        FLOOR4_CLOSED:
            begin
                floorSel = 'b11;
                currentFloor = 4;
                door = 0;
                

                if(dest == currentFloor) nextState = FLOOR4_OPEN;
                else if(dest < currentFloor) nextState = FLOOR3_CLOSED;   
                
                if(floorBtn == 'b0000) nextState = FLOOR4_CLOSED;                  
             end
         default:
            nextState = FLOOR1_OPEN;
            
    endcase
end


endmodule