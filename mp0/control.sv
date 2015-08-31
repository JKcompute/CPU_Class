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
	output logic storemux_sel,
	output logic alumux_sel,
	input logic branch_enable,
	
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
s_add,
s_and,
s_break,
s_not,
s_branch,
s_calc_addr_ldr,
s_ldr1,
s_ldr2,
s_calc_addr_str,
s_str1,
s_str2
// currently only up to add instruction 
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */	
	load_pc = 1'b0;
	load_ir = 1'b0;
	load_regfile = 1'b0;
	load_mar = 1'b0;
	load_mdr = 1'b0;
	load_cc = 1'b0;
	pcmux_sel = 1'b0;
	storemux_sel = 1'b0;
	alumux_sel = 1'b0;
	regfilemux_sel = 1'b0;
	marmux_sel = 1'b0;
	mdrmux_sel = 1'b0;
	aluop = alu_add;
	mem_read = 1'b0;
	mem_write = 1'b0;
	mem_byte_enable = 2'b11;
	
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
			//regfilemux_sel = 0;
			load_cc = 1;
		end

		s_and: begin
			/* DR <= SRA & SRB */
			aluop = alu_and;
			load_regfile = 1;
			load_cc = 1;
		end

		s_not: begin
			/* DR <= NOT(SRA) */
			aluop = alu_not;
			load_regfile = 1;
			load_cc = 1;
		end

		s_branch: begin
			/* PC <= PC + SEXT(IR[8:0] << 1) */
			pcmux_sel = 1;
			load_pc = 1;
		end
		
		s_calc_addr_ldr: begin
			/* MAR <= + SEXT(IR[5:0] << 1) */
			alumux_sel = 1;
			aluop = alu_add;
			load_mar = 1;
		end

		s_ldr1: begin
			/* MDR <= M[MAR] */
			mdrmux_sel = 1;
			load_mdr = 1;
			mem_read = 1;
		end

		s_ldr2: begin
			/* DR <= MDR */
			regfilemux_sel = 1;
			load_regfile = 1;
			load_cc = 1;
		end

		s_calc_addr_str: begin
			/* MAR <= + SEXT(IR[5:0] << 1) */
			alumux_sel = 1;
			aluop = alu_add;
			load_mar = 1;
		end

		s_str1: begin
			/* MDR <= SR */
			storemux_sel = 1;
			aluop = alu_pass;
			load_mdr = 1;
		end

		s_str2: begin
			/* M[MAR] <= MDR */
			mem_write = 1;
		end
		
		default: /* Do nothing */;
	endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */

	case(state)
		fetch1: begin
			next_state <= fetch2; 
		end
		
		fetch2: begin
			next_state <= fetch3;
		end
		
		fetch3: begin
			next_state <= decode;
		end
		
		decode: 
			case(opcode)
				op_add: begin
					next_state <= s_add;
				end
				op_and: begin
					next_state <= s_and;
				end 
			    op_br   :begin
					next_state <= s_break;
			    end
			    op_jmp  :begin
					next_state <= s_and;
			    end   /* also RET */
			    op_jsr  :begin
					next_state <= s_and;
			    end   /* also JSRR */
			    op_ldb  :begin
					next_state <= s_and;
			    end
			    op_ldi  :begin
					next_state <= s_and;
			    end
			    op_ldr  :begin
					next_state <= s_calc_addr_ldr;
			    end
			    op_lea  :begin
					next_state <= s_and;
			    end
			    op_not  :begin
					next_state <= s_not;
			    end
			    op_rti  :begin
					next_state <= s_and;
			    end
			    op_shf  :begin
					next_state <= s_and;
			    end
			    op_stb  :begin
					next_state <= s_and;
			    end
			    op_sti  :begin
					next_state <= s_and;
			    end
			    op_str  :begin
					next_state <= s_calc_addr_str;
			    end
			    op_trap :begin
					next_state <= s_and;
			    end
				default: next_state <= fetch1; 
				// TODO, is this a safe defaul case?
			endcase
		
		s_add: begin
			next_state = fetch1;
		end

		s_and: begin
			next_state = fetch1;
		end

		s_not: begin
			next_state = fetch1;
		end

		s_calc_addr_ldr: begin
			next_state = s_ldr1;
		end

		s_ldr1: begin
			next_state = s_ldr2;
		end

		s_ldr2: begin
			next_state = fetch1;
		end

		s_calc_addr_str: begin
			next_state = s_str1;
		end

		s_str1: begin
			next_state = s_str2;
		end

		s_str2: begin
			next_state = fetch1;
		end
		
		default: next_state = fetch1;
	endcase

end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : control

//test