import lc3b_types::*;

module cache
(
    input clk,
    /* Memory signals */
    output logic mem_resp,
    output logic [15:0] mem_rdata,
    input mem_read,
    input mem_write,
    input [1:0] mem_byte_enable,
    input [15:0] mem_address,
    input [15:0] mem_wdata,

	input pmem_resp,
	output logic pmem_read,
	output logic pmem_write,
	output logic [15:0] pmem_address,
	input [127:0] pmem_rdata,
	output logic [127:0] pmem_wdata
);

logic load_dirty_w1_wire;
logic load_valid_w1_wire;
logic load_tag_w1_wire;
logic load_datastore_w1_wire;
logic load_dirty_w2_wire;
logic load_valid_w2_wire;
logic load_tag_w2_wire;
logic load_datastore_w2_wire;
logic load_lru_wire;
logic datastore_in_mux_sel_wire;
logic ishit_w1_wire;
logic ishit_w2_wire;
logic isdirty_w1_wire;
logic isdirty_w2_wire;
logic lru_out_wire;
logic [1:0] pmem_address_mux_sel_wire;
 

cache_datapath cache_datapath
(
	.clk,
	.load_dirty_w1(load_dirty_w1_wire),
	.load_valid_w1(load_valid_w1_wire),
	.load_tag_w1(load_tag_w1_wire),
	.load_datastore_w1(load_datastore_w1_wire),
	.load_dirty_w2(load_dirty_w2_wire),
	.load_valid_w2(load_valid_w2_wire),
	.load_tag_w2(load_tag_w2_wire),
	.load_datastore_w2(load_datastore_w2_wire),
	.load_lru(load_lru_wire),
	.datastore_in_mux_sel(datastore_in_mux_sel_wire),
	.lru_out(lru_out_wire),
	.tag(mem_address[15:7]),
	.set(mem_address[6:4]),
	.offset(mem_address[3:0]),
	.ishit_w1(ishit_w1_wire),
	.ishit_w2(ishit_w2_wire),
	.isdirty_w1(isdirty_w1_wire),
	.isdirty_w2(isdirty_w2_wire),
	.pmem_rdata(pmem_rdata),
	.mem_rdata(mem_rdata),
	.pmem_wdata(pmem_wdata),
	.mem_wdata(mem_wdata),
	.mem_address(mem_address),
	.pmem_address_mux_out(pmem_address),
	.mem_byte_enable(mem_byte_enable),

	.pmem_address_mux_sel(pmem_address_mux_sel_wire)
);

cache_control cache_control
(
	.clk,
	.load_dirty_w1(load_dirty_w1_wire),
	.load_valid_w1(load_valid_w1_wire),
	.load_tag_w1(load_tag_w1_wire),
	.load_datastore_w1(load_datastore_w1_wire),
	.load_dirty_w2(load_dirty_w2_wire),
	.load_valid_w2(load_valid_w2_wire),
	.load_tag_w2(load_tag_w2_wire),
	.load_datastore_w2(load_datastore_w2_wire),
	.load_lru(load_lru_wire),
	.datastore_in_mux_sel(datastore_in_mux_sel_wire),
	.ishit_w1(ishit_w1_wire),
	.ishit_w2(ishit_w2_wire),
	.isdirty_w1(isdirty_w1_wire),
	.isdirty_w2(isdirty_w2_wire),
	.lru_out(lru_out_wire),
	// Memory signals
    .mem_resp(mem_resp),
    .mem_read(mem_read),
    .mem_write(mem_write),
	.pmem_resp(pmem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),

	.pmem_address_mux_sel(pmem_address_mux_sel_wire)
);

endmodule : cache
