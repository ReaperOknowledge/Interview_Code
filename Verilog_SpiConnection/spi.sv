
`timescale 1ns/1ps

module spi(
    input               clk, 
    input               rst, 
    
    //SPI signals
    input               sck, 
    input               ss,  //acts like reset
    input               mosi, 
    output logic        miso, 

    //hw interface
    input        [7:0]  dout, //output to SPI
    output logic [7:0]  din,  //input from SPI
    output logic        done //logical 1 for 1 cycle indicating new data 
);
    logic rst_; //local reset


    //combine the chip and SPI resets 
    assign rst_ = rst | ss;


    logic [3:0]dec, next_dec, dec2, next_dec2;
    logic psck;
    enum {idle, read} state;
    logic [7:0]new_din;
    //tri-state miso when not in use.  
    // keep this line
    assign miso        = ( rst_ ? 'hz : dout[dec2]);
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    always_ff @(posedge clk) 
    begin
        if (rst_) 
        begin
            dec   <= 7; dec2 <= 7;
            state <= idle;
            psck <= sck;
        end 
       //////////////////////////////////////////////////////
        else
        begin
            psck <= sck;
            state <= read;
            dec <= next_dec; dec2 <= next_dec2;
            din <= new_din;
        end
    end
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

logic [7:0] next_din;
logic rising_edge;
assign rising_edge = 'h0;

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   // always_comb begin
    always_comb
    begin;
    next_dec  = dec;
    next_dec2 = dec2; 
    done = 1;
    new_din = din;
    if(dec == 15)
    begin
        next_dec = 7;  ///may need to change
        done = 1;
    end
    if(dec2 == 15) next_dec2 = 7;
    //$display("dec: %b, dec2: %b, pushing: %b", dec, dec2, pushing);
    case(state)
        read:
        begin
            done = 0;
            if(psck < sck)
            begin
                //$display("dec: %d", dec);
                //din[dec] = mosi;
                new_din[dec] = mosi;
                next_dec = next_dec - 1;
            end
            
            if(psck > sck)
            begin
                next_dec2 = next_dec2 - 1;
            end
    
            if(psck && sck == rising_edge) done = 1;
        end
    endcase
    
    end


endmodule

//////////////////Try to make a done state and use done in clk alawys block