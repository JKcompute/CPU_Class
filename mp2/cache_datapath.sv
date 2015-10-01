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
	input datastore_in_mux_sel,
	input [1:0] pmem_address_mux_sel,
	input load_lru,
	input [8:0] tag,
	input [2:0] set,
	input [3:0] offset,
	input lru_in,
	input dirty_array_w1_in,
	input dirty_array_w2_in,
	input [127:0] pmem_rdata,
	input mem_write,
	input [15:0] mem_wdata,
	input [15:0] mem_address,
	input [1:0] mem_byte_enable,

	output logic lru_out,
	output logic dirty_compare_w1_out,
	output logic dirty_compare_w2_out,
	output logic ishit_w1,
	output logic ishit_w2,
	output logic isdirty_w1,
	output logic isdirty_w2,
	output logic [15:0] mem_rdata,
	output logic [127:0] pmem_wdata,
	output [15:0] pmem_address_mux_out

);

// internal signals

logic dirty_array_w1_out;
logic valid_array_w1_out;
logic [127:0] datastore_array_w1_out;
logic [127:0] data_way_mux_128_parser_out;
logic [15:0] datastore_out_mux_w1_out;
logic [8:0] tag_array_w1_out;
logic [127:0] datastore_parser_out;


logic dirty_array_w2_out;
logic valid_array_w2_out;
logic [127:0] datastore_array_w2_out;
logic [15:0] datastore_out_mux_w2_out;
logic [8:0] tag_array_w2_out;
logic [127:0] datastore_in_mux_out;

// block assignments. 

///////////////
// way 1 blocks 
///////////////
comparator #(.width(16)) dirty_compare_w1
(
	.a (mem_wdata),
	.b (datastore_out_mux_w1_out),
	.out (dirty_compare_w1_out)
);

array #(.width(1)) dirty_array_w1
(
	.clk,
	.write(load_dirty_w1),
	.index(set), 
	.datain(dirty_array_w1_in),
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
	.datain(datastore_in_mux_out),
	.dataout(datastore_array_w1_out)
);

mux8 #(.width(16)) datastore_out_mux_w1
(
	.sel(offset[3:1]),
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
	.hit_out(ishit_w1),
	.dirty_out(isdirty_w1)
); 
///////////////
// end of way 1
///////////////
///////////////
// way 2 blocks 
///////////////
comparator #(.width(16)) dirty_compare_w2
(
	.a (mem_wdata),
	.b (datastore_out_mux_w2_out),
	.out (dirty_compare_w2_out)
);

array #(.width(1)) dirty_array_w2
(
	.clk,
	.write(load_dirty_w2),
	.index(set), 
	.datain(dirty_array_w2_in),
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
	.datain(datastore_in_mux_out),
	.dataout(datastore_array_w2_out)
);

mux8 #(.width(16)) datastore_out_mux_w2
(
	.sel(offset[3:1]),
	.a(datastore_array_w2_out[15:0]),
	.b(datastore_array_w2_out[31:16]), 
	.c(datastore_array_w2_out[47:32]), 
	.d(datastore_array_w2_out[63:48]), 
	.e(datastore_array_w2_out[79:64]), 
	.f(datastore_array_w2_out[95:80]), 
	.g(datastore_array_w2_out[111:96]), 
	.h(datastore_array_w2_out[127:112]),
	.out(datastore_out_mux_w2_out)
);


dirty_hit dirty_hit_w2
(
	.tag(tag),
	.waytag(tag_array_w2_out),
	.valid_in(valid_array_w2_out),
	.dirty_in(dirty_array_w2_out),
	.hit_out(ishit_w2),
	.dirty_out(isdirty_w2)
); 

///////////////
// end of way 2
///////////////

///////////////
// shared / other
///////////////

mux2 data_way_mux_16
(
	.sel(ishit_w2),
	.a(datastore_out_mux_w1_out),
	.b(datastore_out_mux_w2_out),
	.f(mem_rdata)
);

mux2 #(.width(128)) data_way_mux_128_parser
(
	.sel(ishit_w2),
	.a(datastore_array_w1_out),
	.b(datastore_array_w2_out),
	.f(data_way_mux_128_parser_out)
);

mux2 #(.width(128)) data_way_mux_128_pmem
(
	.sel(lru_out),
	.a(datastore_array_w1_out),
	.b(datastore_array_w2_out),
	.f(pmem_wdata)
);

array #(.width(1)) lru
(
	.clk,
	.write(load_lru),
	.index(set), 
	.datain(lru_in),
	.dataout(lru_out)
);

mux2 #(.width(128)) datastore_in_mux
(
	.a(pmem_rdata), 			// input from pMEM
	.b(datastore_parser_out), 	// input from current way
	.sel(datastore_in_mux_sel),
	.f(datastore_in_mux_out)
);

mux4 #(.width(16)) pmem_address_mux
(
	.a({tag_array_w1_out, set, 4'b0}), // way 1
	.b({tag_array_w2_out, set, 4'b0}), // way 2
	.c(mem_address), // cpu
	.d(mem_address), // cpu
	// 00: evacuating way 1
	// 01: evacuating way 2
	// 10: loading from pmem
	// 11: loading from pmem


	// load DS high means we are reading from mem and want the 
	// CPU address, 
	// Otherwise we are storing into pmem and want the address
	// to be built from the way
	//.sel({(load_datastore_w1 ||load_datastore_w2) ,lru_out}),
	.sel(pmem_address_mux_sel),
	.f(pmem_address_mux_out)
);

datastore_parser datastore_parser
(
	.datain(data_way_mux_128_parser_out),
	.writedata(mem_wdata),
	.mem_byte_enable(mem_byte_enable),
	.offset(offset), 
	.mem_write(mem_write),
	.dataout(datastore_parser_out)
);

///////////////
// end of shared / other
///////////////

endmodule : cache_datapath
