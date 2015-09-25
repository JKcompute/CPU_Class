//import lc3b_types::*;

module datastore_parser
(
	input [127:0] datain,
	input [15:0] writedata,
	input [1:0] mem_byte_enable,
	input [3:0] offset,
	input mem_write,
	output logic [127:0] dataout
);

logic [3:0] internal_offset;

//internal signals
assign internal_offset = {offset[3:1], 1'b0};

always_comb
	begin
	dataout[7:0] = datain[7:0];
	dataout[15:8] = datain[15:8];
	dataout[23:16] = datain[23:16];
	dataout[31:24] = datain[31:24];
	dataout[39:32] = datain[39:32];
	dataout[47:40] = datain[47:40];
	dataout[55:48] = datain[55:48];
	dataout[63:56] = datain[63:56];
	dataout[71:64] = datain[71:64];
	dataout[79:72] = datain[79:72];
	dataout[87:80] = datain[87:80];
	dataout[95:88] = datain[95:88];
	dataout[103:96] = datain[103:96];
	dataout[111:104] = datain[111:104];
	dataout[119:112] = datain[119:112];
	dataout[127:120] = datain[127:120];

	if(mem_write == 1)
	begin

		case (internal_offset)
			4'b0000 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[15:8] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[7:0] = writedata[7:0];
		        end
			end
			4'b0010 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[31:24] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[23:16] = writedata[7:0];
		        end
			end
			4'b0100 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[47:40] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[39:32] = writedata[7:0];
		        end
			end
			4'b0110 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[63:56] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[55:48] = writedata[7:0];
		        end
			end
			4'b1000 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[79:72] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[71:64] = writedata[7:0];
		        end
			end
			4'b1010 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[95:88] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[87:80] = writedata[7:0];
		        end
			end
			4'b1100 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[111:104] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[103:96] = writedata[7:0];
		        end
			end
			4'b1110 : begin
	            if (mem_byte_enable[1]) begin
		            dataout[127:120] = writedata[15:8];
		        end

		        if (mem_byte_enable[0]) begin
		            dataout[119:112] = writedata[7:0];
		        end
			end
			default: /* Do nothing */;
		endcase
	end
end

endmodule // datastore_parser

