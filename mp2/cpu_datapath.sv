 import lc3b_types::*;

module cpu_datapath
(
    input clk,

    /* control signals */
    input [1:0] pcmux_sel,
	input storemux_sel,
    input [2:0] alumux_sel,
    input [1:0] marmux_sel,
    input mdrmux_sel,
    input offsetmux_sel,
    input [2:0] regfilemux_sel,

    input load_pc,
    input load_cc,
    input load_ir,
    input load_mar,
    input load_mdr,
    input load_regfile,

    input lc3b_aluop aluop,
    input lc3b_word mem_rdata,
    output lc3b_opcode opcode,
    output logic instruction4,
    output logic instruction5,
    output logic instruction11,

    output lc3b_word mem_address, 
    output lc3b_word mem_wdata,

    output logic branch_enable

);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word alumux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word regfilemux_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word alu_out;
lc3b_word regfile_sr1_out;
lc3b_word regfile_sr2_out;
lc3b_word adj11_out;
lc3b_word adjzext8_out;
lc3b_word adj9_out;
lc3b_word adj6_out;
lc3b_word offsetmux_out;
lc3b_word sext6_out;
lc3b_word sext5_out;
lc3b_word zext4_out;
lc3b_word imm4_out;
lc3b_word zextupper_out;
lc3b_word zextlower_out;

lc3b_reg ir_sr1_out;
lc3b_reg ir_sr2_out;
lc3b_reg ir_dest_out;
lc3b_reg storemux_out;

lc3b_nzp cc_out;
lc3b_nzp gencc_out;

lc3b_offset11 ir_offset11_out;
lc3b_offset9 ir_offset9_out;
lc3b_offset8 ir_offset8_out;
lc3b_offset6 ir_offset6_out;
lc3b_imm5 ir_imm5_out;
lc3b_imm4 ir_imm4_out;

/*
 * PC
 */
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .c(regfile_sr1_out),
    .d(adjzext8_out),
    .f(pcmux_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

plus2 plus2
(
    .in(pc_out),
    .out(pc_plus2_out)
);

adder bradder 
(
    .a(offsetmux_out),
    .b(pc_out),
    .result(br_add_out)
);

/*
 * MAR
 */
mux4 marmux
(
    .sel(marmux_sel),
    .a(alu_out),
    .b(pc_out),
    .c(mem_wdata),
    .d(adjzext8_out),
    .f(marmux_out)
);

register mar
(
    .clk,
    .load(load_mar),
    .in(marmux_out),
    .out(mem_address)
);

/*
 * MDR
 */
mux2 mdrmux
(
    .sel(mdrmux_sel),
    .a(alu_out),
    .b(mem_rdata),
    .f(mdrmux_out)
);

register mdr
(
    .clk,
    .load(load_mdr),
    .in(mdrmux_out),
    .out(mem_wdata)
);

/*
 * Reg file
*/
mux2 #(.width(3)) storemux
(
	.sel(storemux_sel),
	.a(ir_sr1_out),
	.b(ir_dest_out),
	.f(storemux_out)
);

mux8 regfilemux
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b(mem_wdata),
    .c(br_add_out),
    .d(pc_out),
    .e(zextlower_out),
    .f(zextupper_out),
    .g(),
    .h(),
    .out(regfilemux_out)
);

regfile regfile 
(
    .clk,
    .load(load_regfile), 
    .in(regfilemux_out), 
    .src_a(storemux_out), 
    .src_b(ir_sr2_out),
    .dest(ir_dest_out),
    .reg_a(regfile_sr1_out),
    .reg_b(regfile_sr2_out)
);

/*
 * Condition Codes
*/
nzp_comparitor cccomp 
(
    .nzp_input(ir_dest_out),
    .branch_cc(cc_out),
    .out(branch_enable)
);

register #(.width(3)) cc
(
    .clk,
    .load(load_cc),
    .in(gencc_out),
    .out(cc_out)
);

gencc gencc
(
    .in(regfilemux_out),
    .out(gencc_out)
);

/*
 * ALU
*/
alu alu 
(
    .aluop(aluop),
    .a(regfile_sr1_out),
    .b(alumux_out),
    .f(alu_out)
);

mux8 alumux 
(
    .sel(alumux_sel),
    .a(regfile_sr2_out),
    .b(sext5_out),
    .c(adj6_out),
    .d(zext4_out),
    .e(sext6_out), 
    .f(),
    .g(),
    .h(),
    .out(alumux_out)
);

/*
 * Instruction Register
*/
ir ir 
(
    .clk,
    .load(load_ir),
    .in(mem_wdata),
    .opcode(opcode),
    .instruction4(instruction4),
    .instruction5(instruction5),
    .instruction11(instruction11),
    .dest(ir_dest_out),
    .src1(ir_sr1_out),
    .src2(ir_sr2_out),
    .offset11(ir_offset11_out),
    .offset9(ir_offset9_out),
    .offset8(ir_offset8_out),
    .offset6(ir_offset6_out),
    .imm5(ir_imm5_out),
    .imm4(ir_imm4_out)
);

mux2 offsetmux
(
    .sel(offsetmux_sel),
    .a(adj9_out),
    .b(adj11_out),
    .f(offsetmux_out)
);

adj #(.width(11)) adj11
(
    .in(ir_offset11_out),
    .out(adj11_out)
);

adj #(.width(9)) adj9
(
    .in(ir_offset9_out),
    .out(adj9_out)
);

adj #(.width(6)) adj6
(
    .in(ir_offset6_out),
    .out(adj6_out)
);

// Sext
sext #(.width(5)) sext5
(
    .in(ir_imm5_out),
    .out(sext5_out)
);

sext #(.width(6)) sext6
(
    .in(ir_offset6_out),
    .out(sext6_out)
);

//Zext
adjzext #(.width(8)) trapvect8
(
    .in(ir_offset8_out),
    .out(adjzext8_out)
);

zext #(.width(4)) zext4
(
    .in(ir_imm4_out),
    .out(zext4_out)
);

zext #(.width(8)) zextlower
(
    .in(mem_wdata[7:0]),
    .out(zextlower_out)
);

zext #(.width(8)) zextupper
(
    .in(mem_wdata[15:8]),
    .out(zextupper_out)
);

endmodule : cpu_datapath
