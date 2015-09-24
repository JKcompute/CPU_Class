import lc3b_types::*;

module decoder
(
    input clk,
    input enable,
    input [2:0] binary_in,
    output logic [7:0] decoder_out
);

// Internal Signals

// Logic
//assign decoder_out = (enable) ? (1 << binary_in) : 16'b0 ;
assign decoder_out = (enable) ? (1 << binary_in) : 8'b0 ;

endmodule : decoder