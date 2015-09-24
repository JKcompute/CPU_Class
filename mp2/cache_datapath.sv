import lc3b_types::*;

module cache_datapath
(
	input clk,
	// inputs and outputs. 
	input load_dirty_w1,
	input load_valid_w1,
	input load_tag_w1,
	input load_datastore_w1,

	input load_dirty_w2,
	input load_valid_w2,
	input load_tag_w2,
	input load_datastore_w2,

	input load_lru,
	output logic lru_out,

	input datastore_in_mux_sel,

	input [8:0] tag,
	input [2:0] set,
	input [3:0] offset,

	output logic ishit_w1,
	output logic ishit_w2,

	output logic isdirty_w1,
	output logic isdirty_w2,

	input [127:0] pmem_rdata,
	output logic [15:0] mem_rdata,
	output logic [127:0] pmem_wdata,
	input [15:0] mem_wdata

);

// internal signals
logic dirty_compare_w1_out;
logic dirty_array_w1_out;
logic valid_array_w1_out;
logic lru_w1_out;
logic [127:0] datastore_array_w1_out;
logic [127:0] data_way_mux_128_out;
logic [15:0] datastore_out_mux_w1_out;
logic tag_array_w1_out;
logic [127:0] datastore_parser_out;
logic dirty_hit_w1_hit;
logic dirty_hit_w1_dirty;

logic dirty_compare_w2_out;
logic dirty_array_w2_out;
logic valid_array_w2_out;
logic lru_w2_out;
logic [127:0] datastore_array_w2_out;
logic [15:0] datastore_out_mux_w2_out;
logic tag_array_w2_out;
logic dirty_hit_w2_hit;
logic dirty_hit_w2_dirty;

// block assignments. 

///////////////
// way 1 blocks 
///////////////
comparator dirty_compare_w1
(
	.a (mem_rdata),
	.b (datastore_out_mux_w1_out),
	.out (dirty_compare_w1_out)
);

array #(.width(1)) dirty_array_w1
(
	.clk,
	.write(load_dirty_w1),
	.index(set), 
	.datain((dirty_compare_w1_out || dirty_array_w1_out)),
	.dataout(dirty_array_w1_out)
);

array #(.width(1)) valid_array_w1
(
	.clk,
	.write(load_valid_w1),
	.index(set), 
	.datain(1'b1),
	.dataout(valid_array_w1_out)
);

array #(.width(9)) tag_array_w1
(
	.clk,
	.write(load_tag_w1),
	.index(set), 
	.datain(tag),
	.dataout(tag_array_w1_out)
);

array #(.width(128)) datastore_array_w1
(
	.clk,
	.write(load_datastore_w1),
	.index(set), 
	.datain(datastore_parser_out),
	.dataout(datastore_array_w1_out)
);

mux8 #(.width(16)) datastore_out_mux_w1
(
	.sel(offset),
	.a(datastore_array_w1_out[15:0]),
	.b(datastore_array_w1_out[31:16]), 
	.c(datastore_array_w1_out[47:32]), 
	.d(datastore_array_w1_out[63:48]), 
	.e(datastore_array_w1_out[79:64]), 
	.f(datastore_array_w1_out[95:80]), 
	.g(datastore_array_w1_out[111:96]), 
	.h(datastore_array_w1_out[127:112]),
	.out(datastore_out_mux_w1_out)
);

dirty_hit dirty_hit_w1
(
	.tag(tag),
	.waytag(tag_array_w1_out),
	.valid_in(valid_array_w1_out),
	.dirty_in(dirty_array_w1_out),
	.hit_out(dirty_hit_w1_hit),
	.dirty_out(dirty_hit_w1_dirty)
); 
///////////////
// end of way 1
///////////////
///////////////
// way 2 blocks 
///////////////
comparator dirty_compare_w2
(
	.a (mem_rdata),
	.b (datastore_out_mux_w2_out),
	.out (dirty_compare_w2_out)
);

array #(.width(1)) dirty_array_w2
(
	.clk,
	.write(load_dirty_w2),
	.index(set), 
	.datain((dirty_compare_w2_out || dirty_array_w2_out)),
	.dataout(dirty_array_w2_out)
);

array #(.width(1)) valid_array_w2
(
	.clk,
	.write(load_valid_w2),
	.index(set), 
	.datain(1'b1),
	.dataout(valid_array_w2_out)
);

array #(.width(9)) tag_array_w2
(
	.clk,
	.write(load_tag_w2),
	.index(set), 
	.datain(tag),
	.dataout(tag_array_w2_out)
);

array #(.width(128)) datastore_array_w2
(
	.clk,
	.write(load_datastore_w2),
	.index(set), 
	.datain(datastore_parser_w2_out),
	.dataout(datastore_array_w2_out)
);

mux8 #(.width(16)) datastore_out_mux_w2
(
	.sel(offset),
	.a(datastore_array_w1_out[15:0]),
	.b(datastore_array_w1_out[31:16]), 
	.c(datastore_array_w1_out[47:32]), 
	.d(datastore_array_w1_out[63:48]), 
	.e(datastore_array_w1_out[79:64]), 
	.f(datastore_array_w1_out[95:80]), 
	.g(datastore_array_w1_out[111:96]), 
	.h(datastore_array_w1_out[127:112]),
	.out(datastore_out_mux_w2_out)
);

// mux2 #(.width(16)) datastore_in_mux_w2
// (
// 	.a(datastore_array_w2_out),
// 	.b(pmem_rdata), //input from pMEM
// 	.sel(datastore_in_mux_w2_sel),
// 	.f(datastore_in_mux_w2_out)
// );

dirty_hit dirty_hit_w2
(
	.tag(tag),
	.waytag(tag_array_w2_out),
	.valid_in(valid_array_w2_out),
	.dirty_in(dirty_array_w2_out),
	.hit_out(dirty_hit_w2_hit),
	.dirty_out(dirty_hit_w2_dirty)
); 

///////////////
// end of way 2
///////////////

///////////////
// shared / other
///////////////

assign pmem_wdata = data_way_mux_128_out;

mux2 data_way_mux_16
(
	.sel(dirty_hit_w2_hit),
	.a(datastore_out_mux_w1_out),
	.b(datastore_out_mux_w2_out),
	.f(mem_wdata)
);

mux2 data_way_mux_128
(
	.sel(lru_out),
	.a(datastore_array_w1_out),
	.b(datastore_array_w2_out),
	.f(data_way_mux_128_out)
);

array lru
(
	.clk,
	.write(load_lru),
	.index(set), 
	.datain(~lru_out),
	.dataout(lru_out)
);

mux2 #(.width(16)) datastore_in_mux
(
	.a(datastore_parser_out),
	.b(data_way_mux_128_out), //input from pMEM
	.sel(datastore_in_mux_sel),
	.f(datastore_in_mux_out),
);

datastore_parser datastore_parser
(
	.datain(data_way_mux_128_out),
	.writedata(mem_rdata),
	.mem_byte_enable(mem_byte_enable),
	.offset(offset), 
	.dataout(datastore_parser_out)
);

///////////////
// end of shared / other
///////////////

endmodule : cache_datapath
