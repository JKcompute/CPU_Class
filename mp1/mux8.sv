// 8 input mux

module mux8 #(parameter width = 16)
(
	input [1:0] sel,
	input [width-1:0] a, b, c, d, e, f, g, h,
	output logic [width-1:0] out
);

always_comb
	begin	
		if (sel == 0)
			out=a;
		else if (sel == 1)
			out=b;
		else if (sel == 2)
			out=c;
		else if (sel == 3)
			out=d;
		else if (sel == 4)
			out=e;
		else if (sel == 5)
			out=f;
		else if (sel == 6)
			out=g;
		else //(sel == 7)
			out=h;
	end
	
endmodule : mux8
