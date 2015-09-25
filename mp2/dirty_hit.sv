//import lc3b_types::*;

module dirty_hit 
(
	input [8:0] tag,
	input [8:0] waytag,
	input valid_in,
	input dirty_in,

	output logic hit_out,
	output logic dirty_out
); 

logic tag_compare;

always_comb
	begin
	hit_out = 1'b0;
	dirty_out = 1'b0;
	tag_compare = tag == waytag;
	
		begin
			if(tag_compare && valid_in)
			begin
				hit_out = 1'b1;
			end
			if(tag_compare && valid_in && dirty_in)
			begin
				dirty_out = 1'b1;
			end
		end

	end
endmodule // dirty_hit
