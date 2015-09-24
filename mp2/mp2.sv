import lc3b_types::*;

module mp2
(
    input clk,
    // /* Memory signals */
	input logic pmem_resp,
	output logic pmem_read,
	output logic pmem_write,
	output logic [15:0] pmem_address,
	input logic [127:0] pmem_rdata,
	output logic [127:0] pmem_wdata
);

// // internal logic 
logic mem_resp_wire;
logic mem_rdata_wire;
logic mem_read_wire;
logic mem_write_wire;
logic mem_byte_enable_wire;
logic mem_wdata_wire;
logic mem_address_wire;

cache cache 
(
	.clk,
    .mem_resp(mem_resp_wire),
    .mem_rdata(mem_rdata_wire),
    .mem_read(mem_read_wire),
    .mem_write(mem_write_wire),
    .mem_byte_enable(mem_byte_enable_wire),
    .mem_address(mem_address_wire),
    .mem_wdata(mem_wdata_wire),
	.pmem_resp(pmem_resp),
	.pmem_read(pmem_read),
	.pmem_write(pmem_write),
	.pmem_address(pmem_address),
	.pmem_rdata(pmem_rdata),
	.pmem_wdata(pmem_wdata)
);

cpu cpu 
(
	.clk,
    /* Memory signals */
    .mem_resp(mem_resp_wire),
    .mem_rdata(mem_rdata_wire),
    .mem_read(mem_read_wire),
    .mem_write(mem_write_wire),
    .mem_byte_enable(mem_byte_enable_wire),
    .mem_address(mem_address_wire),
    .mem_wdata(mem_wdata_wire)
);

endmodule : mp2
