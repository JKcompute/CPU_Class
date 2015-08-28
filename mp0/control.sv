import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    /* Input and output port declarations */
    input clk,
	/* Datapath controls */
	input lc3b_opcode opcode,
	output logic load_pc,
	output logic load_ir,
	output logic load_mar,
	output logic load_mdr,
	output logic load_regfile,
	output logic load_cc,
	
	output logic marmux_sel,
	output logic mdrmux_sel,
	output logic pcmux_sel,
	output logic regfilemux_sel,
	
	output lc3b_aluop aluop,
	/* et cetera */
	
	/* Memory signals */
	input mem_resp,
	output logic mem_read,
	output logic mem_write,
	output lc3b_mem_wmask mem_byte_enable
);

// list of states
enum int unsigned {
fetch1,
fetch2,
fetch3,
decode,
s_add
// currently only up to add instruction 
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */	
	load_pc = 1'b0;
	load_ir = 1'b0;
	load_regfile = 1'b0;
	aluop = alu_add;
	mem_read = 1'b0;
	mem_write = 1'b0;
	mem_byte_enable = 2'b11;
	/* et cetera (see Appendix E) */
	
	/* Actions for each state */
	case(state)
		fetch1: begin
			/* MAR <= PC */
			marmux_sel = 1;
			load_mar = 1;
			/* PC <= PC + 2 */
			pcmux_sel = 0;
			load_pc = 1;
		end
		
		fetch2: begin
			/* Read memory */
			mem_read = 1;
			mdrmux_sel = 1;
			load_mdr = 1;
		end
		
		fetch3: begin
			/* Load IR */
			load_ir = 1;
		end
		
		decode: /* Do nothing */;
		
		s_add: begin
			/* DR <= SRA + SRB */
			aluop = alu_add;
			load_regfile = 1;
			regfilemux_sel = 0;
			load_cc = 1;
		end
		
		default: /* Do nothing */;
	endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : control
