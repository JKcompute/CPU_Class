module nzp_comparitor 
(
	input [2:0] nzp_input, branch_cc,
	output out 
);

always_comb
	begin
		out = ((nzp_input[2] && branch_cc[2]) || (nzp_input[1] && branch_cc[1]) || (nzp_input[0] && branch_cc[0]));
	end 
	
endmodule : nzp_comparitor
