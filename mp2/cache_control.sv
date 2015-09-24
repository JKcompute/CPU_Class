import lc3b_types::*;

module cache_control
(
// /* Input and output port declarations */
    input clk,

	//cpu in outs
	output logic load_dirty_w1,
	output logic load_valid_w1,
	output logic load_tag_w1,
	output logic load_datastore_w1,

	output logic load_dirty_w2,
	output logic load_valid_w2,
	output logic load_tag_w2,
	output logic load_datastore_w2,

	output logic load_lru,
	output logic datastore_in_mux_sel,
	input lru_out,

	// inputs and outputs. 
	input logic ishit_w1,
	input logic ishit_w2,
	input logic isdirty_w1,
	input logic isdirty_w2,

	// Memory signals
    output logic mem_resp,
    input logic mem_read,
    input logic mem_write,

	input logic pmem_resp,
	output logic pmem_read,
	output logic pmem_write
);

// list of states
enum int unsigned {
idle,
evaluation,
evacuation,
load_store
} state, next_state;


// State Actions
always_comb
begin : state_actions
    /* Default output assignments */	
	load_dirty_w1 = 1'b0;
	load_valid_w1 = 1'b0;
	load_tag_w1 = 1'b0;
	load_datastore_w1 = 1'b0;
	load_dirty_w2 = 1'b0;
	load_valid_w2 = 1'b0;
	load_tag_w2 = 1'b0;
	load_datastore_w2 = 1'b0;
	load_lru = 1'b0;
	datastore_in_mux_sel = 1'b0;
    mem_resp = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	// input lru_out,
	// input logic ishit_w1,
	// input logic ishit_w2,
	// input logic isdirty_w1,
	// input logic isdirty_w2,
	// input logic mem_read,
	// input logic mem_write,
	// input logic pmem_resp,

	
	/* Actions for each state */
	case(state)
		idle: begin
			// I think we will do nothing in this state //
		end
		evaluation: begin
			// I DONT THINK WE NEED TO DO ANYTHING HERE EITHER>  
			// whether read or write, this state is more about determining the next one.  there is nothing to enable.
		end
		evacuation: begin
			// this state is fairly simple.  we will store cache into mem.  
			pmem_write = 1;
		end

///////// NOTE:  we might need another state that allows for the pmem to reset to 0 beforemoving to the load_store state

		load_store: begin
			// we are loading
			if(mem_read == 1) 
			begin
				
				if(ishit_w1 ==1 || ishit_w2 ==1)  // Hit!
				begin
					
					if(ishit_w1 ==1)  // Way 1 Hit!
					begin
						////// implement: way1 hit load
						// send mem_resp = 1;
						// set lru = 1;
						////// what we dont need
						// valid 
						// dirty
						// 
					end
					else /// Way 2 Hit!
					begin
						////// implement: way2 hit load
						// send mem_resp = 1;
						// set lru = 0;
					end

				end
				else // Miss :(
				begin
				
					if(lru_out == 0)  
					begin
						////// implement: way1 miss load (mem read needed)
					end
					else //(lru_out == 1)  
					begin
						////// implement: way2 miss load (mem read needed)
					end

				end
			
			end
			
			// we are storing
			else //(mem_write ==1 )
			begin
			
				if(ishit_w1 ==1 || ishit_w2 ==1)  // Hit!
				begin
					
					if(ishit_w1 ==1)  // Way 1 Hit!
					begin
						////// implement: way1 hit store
					end
					else /// Way 2 Hit!
					begin
						////// implement: way2 hit store
					end

				end
				else // Miss :(
				begin
				
					if(lru_out == 0)  
					begin
						////// implement: way1 miss store (mem read needed)
					end
					else //(lru_out == 1)  
					begin
						////// implement: way2 miss store (mem read needed)
					end

				end
			
			end		
		end
		default: /* Do nothing */;
	endcase
end

// Next State Logic Block
always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */

	// input lru_out,
	// input logic ishit_w1,
	// input logic ishit_w2,
	// input logic isdirty_w1,
	// input logic isdirty_w2,
	// input logic mem_read,
	// input logic mem_write,
	// input logic pmem_resp,


	case(state)
		idle: begin
			if(mem_read==0 && mem_write == 0)
				next_state <= idle; 
			else
				next_state = evaluation;
		end
		evaluation: begin
			// if we miss for both ways
			if(ishit_w1 == 0 && ishit_w2 == 0) begin
				//check LRU for one to replace
				if(lru_out == 0) begin
					// check if the LRU is dirty
					if(isdirty_w1 == 1)
						next_state = evacuation;
					else
						next_state = load_store;
				end
				else begin 
					// check if the LRU is dirty
					if(isdirty_w2 == 1)
						next_state = evacuation;
					else
						next_state = load_store;
				end
			end
			// we have a hit, no need to evacuate
			else
				next_state = load_store;
		end
		evacuation: begin
			if(pmem_resp == 0)
				next_state = evacuation;
			else
				next_state = load_store;
		end
		load_store: begin
			next_state <= idle; 
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
