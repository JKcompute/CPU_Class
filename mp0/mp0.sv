import lc3b_types::*;

module mp0
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

logic load_pc_wire;
logic load_ir_wire;
logic load_cc_wire;
logic load_mar_wire;
logic load_mdr_wire;
logic load_regfile_wire;
logic marmux_sel_wire;
logic mdrmux_sel_wire;
logic pcmux_sel_wire;
logic regfilemux_sel_wire;
logic storemux_sel_wire;
logic alumux_sel_wire;
logic resp_wire;
logic read_wire;
logic write_wire;
logic branch_enable_wire;

lc3b_opcode opcode_wire;
lc3b_aluop aluop_wire;

lc3b_word wdata_wire;
lc3b_word address_wire;
lc3b_word rdata_wire;

/* Instantiate MP 0 top level blocks here */

control control 
(
	.clk,
	/* Datapath controls */
	.opcode(opcode_wire),
	.load_pc(load_pc_wire),
	.load_ir(load_ir_wire),
	.load_mar(load_mar_wire),
	.load_mdr(load_mdr_wire),
	.load_regfile(load_regfile_wire),
	.load_cc(load_cc_wire),
	
	.marmux_sel(marmux_sel_wire),
	.mdrmux_sel(mdrmux_sel_wire),
	.pcmux_sel(pcmux_sel_wire),
	.regfilemux_sel(regfilemux_sel_wire),
	
	.aluop(aluop_wire),
	/* et cetera */
	.storemux_sel(storemux_sel_wire),
	.alumux_sel(alumux_sel_wire),
	.branch_enable(branch_enable_wire),
	
	/* Memory signals */
	.mem_resp(resp_wire),
	.mem_read(read_wire),
	.mem_write(write_wire),
	.mem_byte_enable(mem_byte_enable)
);

datapath datapath
(
	.clk,

    /* control signals */
    .pcmux_sel(pcmux_sel_wire),
	.storemux_sel(storemux_sel_wire),
    .alumux_sel(alumux_sel_wire),
    .marmux_sel(marmux_sel_wire),
    .mdrmux_sel(mdrmux_sel_wire),
    .regfilemux_sel(regfilemux_sel_wire),

    .load_pc(load_pc_wire),
    .load_cc(load_cc_wire),
    .load_ir(load_ir_wire),
    .load_mar(load_mar_wire),
    .load_mdr(load_mdr_wire),
    .load_regfile(load_regfile_wire),

    .aluop(aluop_wire),

    /* declare more ports here */
    .mem_rdata(rdata_wire),

    .opcode(opcode_wire),
    .mem_address(address_wire), 
    .mem_wdata(wdata_wire),
    .branch_enable(branch_enable_wire)
);

magic_memory memory
(
	.clk,

    /* Port A */
    .read(read_wire),
    .write(write_wire),
    .wmask(mem_byte_enable),
    .address(address_wire),
    .wdata(wdata_wire),
    .resp(resp_wire),
    .rdata(rdata_wire)
);

endmodule : mp0
