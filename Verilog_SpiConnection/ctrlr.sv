`timescale 1ns/1ps

module ctrlr(
    input                   clk,
    input                   rst, // set on first byte only?

    //GPIO interface
    input           [15:0]  switches,
    output logic    [15:0]  leds,

    //MMIO interface 
    input                   new_data,       // done from spi... indicates new byte
    input           [7:0]   din,
    output logic    [7:0]   dout
);

localparam chip_id = 8'h07;

//
// How to intrepret the first byte:
//
// =====================================
// | W | - | - | - | - | A2 | A1 | A0 |
// =====================================

//What to do with the 2nd byte: 
// 
// IF W == 1 (READ)
//
// A2A1A0 == 'h0:  tx_dout = chip_id
// A2A1A0 == 'h1:  tx_dout = switches[7:0]
// A2A1A0 == 'h2:  tx_dout = switches[15:8]
// A2A1A0 == 'h3:  tx_dout = leds[7:0]
// A2A1A0 == 'h4:  tx_dout = leds[15:8]
//
// IF W == 0 (WRITE)
//
// A2A1A0 == 'h0:  ignore 
// A2A1A0 == 'h1:  ignore
// A2A1A0 == 'h2:  ignore
// A2A1A0 == 'h3:  set leds[7:0] = din
// A2A1A0 == 'h4:  set leds[15:8] = din

//states
enum { ST_BYTE_ONE, ST_WRITE, ST_READ} s, ns;
//local state
logic [7:0] op, n_op; 
logic [15:0] n_leds;
logic [7:0] n_dout;


always_ff @(posedge clk) begin
    if (rst) begin
        s   <= ST_BYTE_ONE;
        op  <= 8'h0;
        leds <= 'h0;
        dout <= chip_id;
    end else begin
        s   <= ns;
        op  <= n_op; 
        leds <= n_leds; 
        dout <= n_dout;
    end
end

always_comb begin
    //defaults
    ns = s;
    n_op = op;
    n_leds = leds;
    n_dout = chip_id;

    case (s) 
        ST_BYTE_ONE: begin
            ; //fixme
            // set op?
            // if byte one means getting address(first byte from controller)
//            n_op = din[7:0];    // first byte of data containing operation and address?
//            n_leds = 'h0;
            if(new_data) begin
                n_op = din;
                if(din[7] == 1) begin
                    ns = ST_READ;
                    n_dout = 8'b0;
                end
                 else if(din[7] == 0) begin
                    ns = ST_WRITE;
                    n_dout = 8'b0;
                 end
            end
            else begin
                ns = ST_BYTE_ONE;
                n_dout = 0;
            end            
        end

        ST_READ:  begin
            if(new_data) begin
//             $display("ST_READ new data... new_data:%b, op:%b, din:%b", new_data, op, din);
                n_op = din;
                if(op == 'b10000001) begin
                    n_dout = switches[7:0];
                    ns = ST_BYTE_ONE;
                 end
                 else if(op == 'b10000010) begin
                    n_dout = switches[15:8];
                    ns = ST_BYTE_ONE;
                 end
                 else if(op == 'b10000011) begin
                    n_dout = leds[7:0];
                    ns = ST_BYTE_ONE;
                 end
                 else if(op == 'b10000100) begin
                    n_dout = leds[15:8];
                    ns = ST_BYTE_ONE;
                 end
            end
            else begin
                ns = ST_READ;
                n_dout = 0;
            end
        end

        ST_WRITE: begin
            ; //fixme
            if(new_data) begin
                if(op == 'b00000011) begin
                    n_leds[7:0] = din;
                    n_dout = 0;
                    ns = ST_BYTE_ONE;
                end
                else if(op == 'b00000100) begin
                    n_leds[15:8] = din;
                    n_dout = 0;
                    ns = ST_BYTE_ONE;
                end
            end
            else begin
                ns = ST_WRITE;
                n_dout = 0;
            end
        end

    endcase 
end

endmodule