`timescale 1ns / 1ps


module ElevCtrl_tb();

logic clk, rst;
logic [3:0] floorBtn;

logic [1:0] floorSel;
logic door;

ElevCtrl e1(.clk, .rst, .floorBtn, .floorSel, .door);

//inverts the clock signal for 100MHz clock
always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;
    floorBtn = 'b0001;

    $monitor ("rst:%b floorBtn:%b floorSel:%b door:%b",
                rst, floorBtn, floorSel, door);
     
    $display("Reset Case");
    rst = 1;                
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    assert(door == 1) else $fatal(1, "door not openfloor1");
    assert(floorSel == 'b00) else $fatal(1, "Floorsel should be %b, floorSel: %b", 0, floorSel);
    
    
    rst = 0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    assert(door == 1) else $fatal(1, "door not openfloor1");
    assert(floorSel == 'b00) else $fatal(1, "Floorsel should be %b, floorSel: %b", 0, floorSel);
    
    
    $display("Floor1 ---> Floor2");
    assert(door == 1) else $fatal(1, "door should be open floor1");
    floorBtn = 'b0010;
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor1");
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor1");
    @(negedge clk);
    assert(floorSel == 'b01) else $fatal(1, "Floorsel should be %b, floorSel: %b", 1, floorSel);
    assert(door == 1) else $fatal(1, "Door should be open, door:%b", door);
    
     $display("Floor2 ---> Floor3");
     assert(door == 1) else $fatal(1, "door should be open floor2");
    floorBtn = 'b0100;
    @(negedge clk);
    assert(door == 0) else $fatal("door not closed, floor2");
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor2");
    @(negedge clk);
    assert(floorSel == 'b10) else $fatal(1, "Floorsel should be %b, floorSel: %b", 2, floorSel);
    assert(door == 1) else $fatal(1, "Door should be open, door:%b", door);
    
    $display("Floor3 ---> Floor4");
    assert(door == 1) else $fatal(1, "door should be open floor3");
    floorBtn = 'b1000;
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor3");
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor3");
    @(negedge clk);
    assert(floorSel == 'b11) else $fatal(1, "Floorsel should be %b, floorSel: %b", 3, floorSel);
    assert(door == 1) else $fatal(1, "Door should be open, door:%b", door);
    
    
    $display("Floor4 ---> Floor3");
    assert(door == 1) else $fatal(1, "door should be open floor4");
    floorBtn = 'b0100;
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor3");
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor3");
    @(negedge clk);
    assert(floorSel == 'b10) else $fatal(1, "Floorsel should be %b, floorSel: %b", 2, floorSel);
    assert(door == 1) else $fatal(1, "Door should be open, door:%b", door);
    
    $display("Floor3 ---> Floor2");
    assert(door == 1) else $fatal(1, "door should be open floor3");
    floorBtn = 'b0010;
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor3");
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor2");
    @(negedge clk);
    assert(floorSel == 'b01) else $fatal(1, "Floorsel should be %b, floorSel: %b", 1, floorSel);
    assert(door == 1) else $fatal(1, "Door should be open, door:%b", door);
    
    $display("Floor2 ---> Floor1");
    assert(door == 1) else $fatal(1, "door should be open floor3");
    floorBtn = 'b0001;
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor2");
    @(negedge clk);
    assert(door == 0) else $fatal(1, "door not closed, floor1");
    @(negedge clk);  
    assert(floorSel == 'b00) else $fatal(1, "Floorsel should be %b, floorSel: %b", 0, floorSel);
    assert(door == 1) else $fatal(1, "Door should be open, door:%b", door);
    
    
    // test 1 --> 4, no stop
    $display("Floor1 ---> Floor4\n\n");
    assert(door == 1) else $fatal("door should be open floor1");
    floorBtn = 'b1000;
    @(negedge clk);
    assert(door == 0 && floorSel == 'b00) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b00);
    @(negedge clk);
    assert(door == 0 && floorSel == 'b01) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b01);
    @(negedge clk);
    assert(door == 0 && floorSel == 'b10) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b10);
    @(negedge clk);
    assert(door == 0 && floorSel == 'b11) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b11);
    @(negedge clk);
    assert(door == 1 && floorSel == 'b11) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 1, floorSel, 'b11);
    
    // test 4 --> 1, not stop
    assert(door == 1) else $fatal("door should be open floor1");
    floorBtn = 'b0001;
    @(negedge clk);
    assert(door == 0 && floorSel == 'b11) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b11);
    @(negedge clk);
    assert(door == 0 && floorSel == 'b10) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b10);
    @(negedge clk);
    assert(door == 0 && floorSel == 'b01) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b01);
    @(negedge clk);
    assert(door == 0 && floorSel == 'b00) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b00);
    @(negedge clk);
    assert(door == 1 && floorSel == 'b00) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 1, floorSel, 'b00);
    
    
    // test 1 --> 3 --> 2 --> 4
    
    // test floorBtn == 0
    floorBtn = 'b0000;
    assert(floorSel == 'b00 & door == 1) else $fatal(1, "Failed for floorBtn == 0000   floorSel=%b, should be %b   door=%b, should be %b   ", floorSel, 'b00, door, 1);
    
    
    // test button press during transition
//    $display("Button change in transition test");
//    floorBtn = 'b0100;
//    assert(door == 1) else $fatal("door should be open floor1");
//    @(negedge clk);
//    assert(door == 0 && floorSel == 'b00) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b00);
//    floorBtn = 'b1000;
//    @(negedge clk);
//    assert(door == 0 && floorSel == 'b01) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b01);
//    @(negedge clk);
//    assert(door == 0 && floorSel == 'b10) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 0, floorSel, 'b10);
//    @(negedge clk);
//    assert(door == 1 && floorSel == 'b10) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 1, floorSel, 'b10);
//    @(negedge clk);
//    assert(door == 1 && floorSel == 'b10) else $fatal(1, "door=%b, should be %b & floorSel=%b, should be %b", door, 1, floorSel, 'b10);
//    assert(floorBtn == 'b0100) else $fatal(1, "floorBtn changed during transition... floorBtn=%b, should be %b", floorBtn, 'b0100);
//    @(negedge clk);
//    assert(floorBtn == 'b0100) else $fatal(1, "floorBtn changed during transition... floorBtn=%b, should be %b", floorBtn, 'b0100);
    

    $display("@@@Passed\n");
    $finish;
    
end




endmodule
