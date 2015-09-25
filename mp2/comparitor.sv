//import lc3b_types::*;

module comparator #(parameter width = 128)
(
	input [width-1:0] a, b, 
	output logic out
);

// internal signals

// Logic

always_comb
	begin 
		if (a == b)
			out = 1'b1;
		else 
			out = 1'b0;
	end // always_comb

endmodule : comparator
