import lc3b_types::*;

module mp1
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

// internal logic 
logic load_pc_wire;
logic load_ir_wire;
logic load_cc_wire;
logic load_mar_wire;
logic load_mdr_wire;
logic load_regfile_wire;
logic [1:0] marmux_sel_wire;
logic mdrmux_sel_wire;
logic destmux_sel_wire;
logic offsetmux_sel_wire;
logic [1:0] pcmux_sel_wire;
logic [2:0] regfilemux_sel_wire;
logic storemux_sel_wire;
lc3b_alumux_sel alumux_sel_wire;
logic branch_enable_wire;
logic instruction4_wire;
logic instruction5_wire;
logic instruction11_wire;
lc3b_opcode opcode_wire;
lc3b_aluop aluop_wire;


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
	.offsetmux_sel(offsetmux_sel_wire),
	.pcmux_sel(pcmux_sel_wire),
	.regfilemux_sel(regfilemux_sel_wire),
	.aluop(aluop_wire),
	.storemux_sel(storemux_sel_wire),
	.alumux_sel(alumux_sel_wire),
	.branch_enable(branch_enable_wire),
	.instruction4(instruction4_wire),
	.instruction5(instruction5_wire),
	.instruction11(instruction11_wire),
	.mem_byte(mem_address[0]),
	/* Memory signals */
	.mem_resp(mem_resp),
	.mem_read(mem_read),
	.mem_write(mem_write),
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
		.offsetmux_sel(offsetmux_sel_wire),
    .regfilemux_sel(regfilemux_sel_wire),
    .load_pc(load_pc_wire),
    .load_cc(load_cc_wire),
    .load_ir(load_ir_wire),
    .load_mar(load_mar_wire),
    .load_mdr(load_mdr_wire),
    .load_regfile(load_regfile_wire),
    .aluop(aluop_wire),
	.branch_enable(branch_enable_wire),
    .opcode(opcode_wire),
	.instruction4(instruction4_wire),
	.instruction5(instruction5_wire),
	.instruction11(instruction11_wire),
   	/* Memory signals */
    .mem_rdata(mem_rdata),
    .mem_address(mem_address), 
    .mem_wdata(mem_wdata)
);

endmodule : mp1
