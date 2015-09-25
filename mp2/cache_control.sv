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
	output logic [1:0] pmem_address_mux_sel,
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
	pmem_address_mux_sel = 0;
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

			if(lru_out == 0)  // we will evacuate way 1
			begin
				pmem_address_mux_sel = 0;
			end
			else //(lru_out == 1)  
			begin
				pmem_address_mux_sel = 1;
			end


		end

///////// NOTE:  we might need another state that allows for the pmem to reset to 0 beforemoving to the load_store state

		load_store: begin
			// we are loading
			if(mem_read == 1) 
			begin
				
				if(ishit_w1 ==1 || ishit_w2 ==1)  // Read:Hit!
				begin

					// looks like these will both behave the same.  
					if(ishit_w1 ==1)  // Way 1 Hit!
					begin
						////// implement: way1 hit load
						mem_resp = 1;
						//LRU needs to be way 1 now
						if(lru_out == 1)
							load_lru = 1;
						////// what we dont need
						// valid 	: if we had a hit, it must already be valid
						// dirty  	: data matches mem
						// tag 		: 
						// datastore / datastore in mux : we are not storeing, only reading
						// pmem_read : hit, no pmem interaction
						// pmem_write : hit, no pmem interation
					end
					else /// Way 2 Hit!
					begin
						////// implement: way2 hit load
						mem_resp = 1;
						//LRU needs to be way 2 now
						if(lru_out == 0)
							load_lru = 1;
						////// what we dont need
						// valid 	: if we had a hit, it must already be valid
						// dirty  	: data matches mem
						// tag 		: 
						// datastore / datastore in mux : we are not storeing, only reading
						// pmem_read : hit, no pmem interaction
						// pmem_write : hit, no pmem interation
					end

				end
				else // Read:Miss :(
				begin
				
					if(lru_out == 0)  // we will replace way 1
					begin
						////// implement: way1 miss load (mem read needed)
						mem_resp = pmem_resp;
						load_valid_w1 = 1;
						load_tag_w1 = 1;
						load_datastore_w1 = 1;
						datastore_in_mux_sel = 1;
						load_lru = 1;
						datastore_in_mux_sel = 1; // 0:parser; 1:pmem
						pmem_read = 1;
						pmem_address_mux_sel = 3;
						////// what we dont need
						// dirty : loaded mem matches physical
						// pmem_write : we will never need pmem_write in this state
					end
					else //(lru_out == 1)  
					begin
						////// implement: way2 miss load (mem read needed)
						mem_resp = pmem_resp;
						load_valid_w2 = 1;
						load_tag_w2 = 1;
						load_datastore_w2 = 1;
						datastore_in_mux_sel = 1;
						load_lru = 1;
						datastore_in_mux_sel = 1; // 0:parser; 1:pmem
						pmem_read = 1;
						pmem_address_mux_sel = 3;
						////// what we dont need
						// dirty : loaded mem matches physical
						// pmem_write : we will never need pmem_write in this state
					end

				end
			
			end
			
			// we are storing (into cache only)
			else // (mem_write ==1 )
			begin
			
				if(ishit_w1 ==1 || ishit_w2 ==1)  // Write: Hit!
				begin
					
					if(ishit_w1 ==1)  // Way 1 Hit!
					begin
						////// implement: way1 hit store
						load_dirty_w1 = 1;
						//LRU needs to be way 2 now
						if(lru_out == 0)
							load_lru = 1;
						mem_resp = 1;
						load_datastore_w1 = 1;
						datastore_in_mux_sel = 0; // 0:parser; 1:pmem
						////// what we dont need
						// valid 	: its a hit, should already be set.  
						// tag: 	: it is a hit, should already be set.
						// pmem not accessed for hit!
					end
					else /// Way 2 Hit!
					begin
						////// implement: way1 hit store
						load_dirty_w2 = 1;
						//LRU needs to be way 1 now
						if(lru_out == 1)
							load_lru = 1;
						mem_resp = 1;
						load_datastore_w2 = 1;
						datastore_in_mux_sel = 0; // 0:parser; 1:pmem
						////// what we dont need
						// valid 	: its a hit, should already be set.  
						// tag: 	: it is a hit, should already be set.
						// pmem not accessed for hit!
					end

				end
				else // Write: Miss :(
				begin
				
					if(lru_out == 0)  
					begin
						////// implement: way1 miss store (mem read needed)
						load_dirty_w1 =1;
						load_valid_w1 = 1;
						load_tag_w1 = 1;
						load_datastore_w1 = 1;
						load_lru = 1;
						datastore_in_mux_sel = 1; // 0:parser; 1:pmem
						mem_resp = pmem_resp;
						pmem_read = 0;
						pmem_address_mux_sel = 3;
						////// what we dont need
						// pmem_write : we did the write already.
					end
					else //(lru_out == 1)  
					begin
						////// implement: way2 miss store (mem read needed)
						load_dirty_w2 = 1;
						load_valid_w2 = 1;
						load_tag_w2 = 1;
						load_datastore_w2 = 1;
						load_lru = 1;
						datastore_in_mux_sel = 1; // 0:parser; 1:pmem
						mem_resp = pmem_resp;
						pmem_read = 0;
						pmem_address_mux_sel = 3;
						////// what we dont need
						// pmem_write : we did the write already.
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
	case(state)
		idle: begin
			if(mem_read==0 && mem_write == 0)
				next_state <= idle; 
			else
				next_state <= evaluation;
		end
		evaluation: begin
			// if we miss for both ways
			if(ishit_w1 == 0 && ishit_w2 == 0) begin
				//check LRU for one to replace
				if(lru_out == 0) begin
					// check if the LRU is dirty
					if(isdirty_w1 == 1)
						next_state <= evacuation;
					else
						next_state <= load_store;
				end
				else begin 
					// check if the LRU is dirty
					if(isdirty_w2 == 1)
						next_state <= evacuation;
					else
						next_state <= load_store;
				end
			end
			// we have a hit, no need to evacuate
			else
				next_state = load_store;
		end
		evacuation: begin
			if(pmem_resp == 0)
				next_state <= evacuation;
			else
				next_state <= load_store;
		end
		load_store: begin
			if(pmem_resp == 0)
				next_state <= load_store;
			else
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
