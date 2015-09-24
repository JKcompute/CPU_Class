import lc3b_types::*;

module cache_control
(
// /* Input and output port declarations */
//     input clk,
// 	// Datapath controls
// 	input lc3b_opcode opcode,
// 	input logic instruction4,
// 	input logic instruction5,
// 	input logic instruction11,
// 	// Load 
// 	output logic load_pc,
// 	output logic load_ir,
// 	output logic load_mar,
// 	output logic load_mdr,
// 	output logic load_regfile,
// 	output logic load_cc,
// 	// Select
// 	output logic [1:0] marmux_sel,
// 	output logic mdrmux_sel,
// 	output logic offsetmux_sel,
// 	output logic [1:0] pcmux_sel,
// 	output logic [2:0] regfilemux_sel,
// 	output lc3b_aluop aluop,
// 	output logic storemux_sel,
// 	output lc3b_alumux_sel alumux_sel,
// 	input logic branch_enable,
// 	// Memory signals
// 	input mem_resp,
// 	output logic mem_read,
// 	output logic mem_write,
// 	output lc3b_mem_wmask mem_byte_enable,

// 	input mem_byte
);


// list of states
enum int unsigned {
fetch1,
stateddd
} state, next_state;


// State Actions
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
		default: /* Do nothing */;
	endcase
end

// Next State Logic Block
always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */

	case(state)
		fetch1: begin
			next_state <= fetch2; 
		end
	endcase

end

// Next State Assignment Block
always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control
