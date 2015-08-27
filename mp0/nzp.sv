module nzp_comparitor 
(
	input [2:0] nzp_input, branch_settings
	output jump 
);

always_comb
	begin
		jump = ((nzp_input[2] && branch_settings[2]) || (nzp_input[1] && branch_settings[1]) || (nzp_input[0] && branch_settings[0]));
	end 
	
endmodule : nzp_comparitor
