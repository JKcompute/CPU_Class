import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cpu_control
(
    /* Input and output port declarations */
    input clk,
	// Datapath controls
	input lc3b_opcode opcode,
	input logic instruction4,
	input logic instruction5,
	input logic instruction11,
	// Load 
	output logic load_pc,
	output logic load_ir,
	output logic load_mar,
	output logic load_mdr,
	output logic load_regfile,
	output logic load_cc,
	// Select
	output logic [1:0] marmux_sel,
	output logic mdrmux_sel,
	output logic offsetmux_sel,
	output logic [1:0] pcmux_sel,
	output logic [2:0] regfilemux_sel,
	output lc3b_aluop aluop,
	output logic storemux_sel,
	output lc3b_alumux_sel alumux_sel,
	input logic branch_enable,
	// Memory signals
	input mem_resp,
	output logic mem_read,
	output logic mem_write,
	output lc3b_mem_wmask mem_byte_enable,

	input mem_byte
);

// list of states
enum int unsigned {
fetch1,
fetch2,
fetch3,
decode,
s_add,
s_and,
s_not,
s_br,
s_br_taken,
s_calc_addr,
s_calc_addr_sext,
s_ldr1,
s_ldr2,
s_str1,
s_str2,
s_jmp,
s_lea,
s_jsr,
s_jsrr,  
s_ldb1, // mem access
s_ldb2,
s_ldi1, // mem access
s_ldi2, 
s_ldi3, // mem access
s_ldi4, 
s_rti, /// NOT DOING THIS FOR MP1
s_shf, 
s_stb1,
s_stb2, // mem access
s_sti1, // mem access
s_sti2,
s_sti3,
s_sti4, // mem access
s_trap1,
s_trap2,
s_trap3,
s_storepc
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
	pcmux_sel = 2'b00;
	storemux_sel = 1'b0;
	alumux_sel = 3'b000;
	regfilemux_sel = 3'b000;
	marmux_sel = 2'b00;
	mdrmux_sel = 1'b0;
	offsetmux_sel = 1'b0;
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
			/* DR <= SRA + SEXT(imm5) */
			aluop = alu_add;
			load_regfile = 1;
			load_cc = 1;
			// this takes care of immidiate add.
			alumux_sel = {2'b00, instruction5};
		end

		s_and: begin
			/* DR <= SRA & SRB */
			/* DR <= SRA AND SEXT(imm5) */
			aluop = alu_and;
			load_regfile = 1;
			load_cc = 1;
			// this takes care of immidiate and.
			alumux_sel = {2'b00, instruction5};

		end

		s_not: begin
			/* DR <= NOT(SRA) */
			aluop = alu_not;
			load_regfile = 1;
			load_cc = 1;
		end

		s_br: begin
			/* Do nothing, we are checking if we should branch */
		end
		
		s_br_taken: begin 
			/* PC <= PC + SEXT(IR[8:0] << 1) */
			pcmux_sel = 1;
			load_pc = 1;
		end
		
		s_calc_addr: begin
			/* MAR <= base + SEXT(IR[5:0] << 1) */
			alumux_sel = 2;
			aluop = alu_add;
			load_mar = 1;
		end

		s_calc_addr_sext: begin
			// set up address before mem read
			alumux_sel = 4;
			aluop = alu_add;
			marmux_sel = 0;
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

		s_jmp: begin
			/* PC= BaseR = SR1 
				ret is same thing, hard coded to R7 */
			pcmux_sel = 2;
			load_pc = 1;
		end
		s_lea: begin
			regfilemux_sel = 2;
			load_regfile = 1;
		end
		s_storepc: begin 
			load_regfile = 1;
			regfilemux_sel = 3;
		end 
		s_jsr: begin
			load_pc = 1;
			offsetmux_sel = 1;
			pcmux_sel = 1;
		end

		s_ldb1: begin
			// read from mem
			load_mdr = 1;
			mdrmux_sel = 1; 
			mem_read = 1;
		end
		s_ldb2: begin
			// figure this out, need if else based on MAR[0] value
			if (mem_byte == 0)
				regfilemux_sel = 4;
			else
				regfilemux_sel = 5;
			// place data into register
			load_regfile = 1;
			load_cc = 1;
		end

		s_ldi1:begin
			// MDR <== M[MAR]
			mdrmux_sel = 1; 
			load_mdr = 1;
			mem_read = 1;
		end
		s_ldi2:begin
			// MAR <== MDR
			marmux_sel = 2;
			load_mar = 1;
		end
		s_ldi3:begin
			// MDR <== M[MAR]
			mdrmux_sel = 1; 
			load_mdr = 1;
			mem_read = 1;
		end
		s_ldi4:begin
			// MDR -> DR, setCC
			load_regfile = 1;
			regfilemux_sel = 1;
			load_cc = 1;
		end

		s_stb1: begin 
			//mem_byte_enable = 2'b01;
			storemux_sel = 1;
			aluop = alu_bitcopy;
			load_mdr = 1;
		end
		s_stb2: begin 
			if(mem_byte == 0)
				mem_byte_enable = 2'b01;
			else
				mem_byte_enable = 2'b10;
			mem_write = 1;
		end


		s_sti1:begin
			// MDR <== M[MAR]
			mdrmux_sel = 1; 
			load_mdr = 1;
			mem_read = 1;
		end
		s_sti2:begin
			// MAR <== MDR
			marmux_sel = 2;
			load_mar = 1;
		end
		s_sti3:begin
			// MDR <== SR
			storemux_sel = 1;
			load_mdr = 1;
			aluop = alu_pass;
		end
		s_sti4:begin
			// M[MAR] <== MDR = SR
			mem_write = 1;
		end

		s_shf: begin
			// 
			if(instruction4 == 0) // d bit
				aluop = alu_sll;
			else // if (instruction4 == 1)
			begin
				if(instruction5 == 0) // a bit
					aluop = alu_srl;
				else // if instruction5 = 1)
					aluop = alu_sra;
			end
			alumux_sel = 3;
			regfilemux_sel = 0;
			load_regfile = 1;
			load_cc = 1;
		end

		s_trap1: begin
			marmux_sel = 3; 
			load_mar =1; 
		end
		s_trap2: begin 
			load_mdr = 1;
			mem_read = 1;
			mdrmux_sel = 1;
		end
		s_trap3: begin
			pcmux_sel = 3; 
			load_pc = 1;
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
			if (mem_resp == 0)
				next_state <= fetch2;
			else
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
					next_state <= s_br;
			    end
			    op_jmp  :begin
					next_state <= s_jmp;
			    end   /* also RET */
			    op_jsr  :begin
					next_state <= s_storepc;
			    end   /* also JSRR */
			    op_ldb  :begin
					next_state <= s_calc_addr_sext;
			    end
			    op_ldi  :begin
					next_state <= s_calc_addr;
			    end
			    op_ldr  :begin
					next_state <= s_calc_addr;
			    end
			    op_lea  :begin
					next_state <= s_lea;
			    end
			    op_not  :begin
					next_state <= s_not;
			    end
			    op_rti  :begin
					next_state <= decode; //not doing this today
			    end
			    op_shf  :begin
					next_state <= s_shf; 
			    end
			    op_stb  :begin
					next_state <= s_calc_addr_sext;
			    end
			    op_sti  :begin
					next_state <= s_calc_addr;
			    end
			    op_str  :begin
					next_state <= s_calc_addr;
			    end
			    op_trap :begin
					next_state <= s_storepc;
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

		s_ldr1: begin
			if(mem_resp == 0)
				next_state = s_ldr1;
			else
				next_state = s_ldr2;
		end
		s_ldr2: begin
			next_state = fetch1;
		end

		s_str1: begin
			next_state = s_str2;
		end
		s_str2: begin
			if(mem_resp == 0)
				next_state = s_str2;
			else
				next_state = fetch1;
		end
		
		s_br: begin 
			if(branch_enable == 0)
				next_state = fetch1;
			else
				next_state = s_br_taken;
		end	
		s_br_taken: begin
			next_state = fetch1;
		end

		s_jmp: begin
			next_state = fetch1;
		end

		s_lea: begin
			next_state = fetch1;
		end

		s_storepc: begin
			if(opcode == op_jsr && instruction11 == 0) //jsrr
				next_state = s_jmp;
			else if (opcode == op_jsr && instruction11 == 1) //jsr
				next_state = s_jsr;
			else // if (opcode == op_trap)
				next_state = s_trap1;
		end

		s_jsr: begin 
			next_state = fetch1;
		end

		s_ldb1: begin 
			if(mem_resp == 0)
				next_state = s_ldb1;
			else
				next_state = s_ldb2;
		end
		s_ldb2: begin 
			next_state = fetch1;
		end

		s_ldi1: begin 
			if(mem_resp == 0)
				next_state = s_ldi1;
			else
				next_state = s_ldi2;
		end
		s_ldi2: begin 
			next_state = s_ldi3;
		end
		s_ldi3: begin 
			if(mem_resp == 0)
				next_state = s_ldi3;
			else
				next_state = s_ldi4;
		end
		s_ldi4: begin 
			next_state = fetch1;
		end

		// start of a lot of functions. 
		s_calc_addr: begin
			if(opcode == op_ldr)
				next_state = s_ldr1;
			else if(opcode == op_str)
				next_state = s_str1;
			else if(opcode == op_ldi)
				next_state = s_ldi1;
			else //if ( opcode == op_sti)
				next_state = s_sti1;
		end

		s_calc_addr_sext: begin 
			if(opcode == op_ldb)
				next_state = s_ldb1;
			else //if (opcode = op_stb)
				next_state = s_stb1;
		end

		s_stb1: begin 
			next_state = s_stb2;
		end
		s_stb2: begin 
			if(mem_resp == 0)
				next_state = s_stb2;
			else
				next_state = fetch1;
		end

		s_sti1: begin 
			if(mem_resp == 0)
				next_state = s_sti1;
			else
				next_state = s_sti2;
		end
		s_sti2: begin 
			next_state = s_sti3;
		end
		s_sti3: begin 

				next_state = s_sti4;
		end
		s_sti4: begin 
			if(mem_resp == 0)
				next_state = s_sti4;
			else
				next_state = fetch1;
		end

		s_shf: begin
			next_state = fetch1;
		end

		s_trap1: begin
			next_state = s_trap2;
		end
		s_trap2: begin 
			if(mem_resp == 0)
				next_state = s_trap2;
			else
				next_state = s_trap3;
		end
		s_trap3: begin
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

endmodule : cpu_control

//test