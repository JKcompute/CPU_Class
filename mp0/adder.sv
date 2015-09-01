module adder #(parameter width = 16)
(
	input [width-1:0] a, b, 
	output logic [width-1:0] result
);

always_comb
	begin 
		result = a + b;
	end
	
endmodule : adder
