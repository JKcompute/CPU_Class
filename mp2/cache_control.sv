//import lc3b_types::*;

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
	output logic lru_in,

	output logic dirty_array_w1_in,
	output logic dirty_array_w2_in,

	input logic dirty_compare_w1_out,
	input logic dirty_compare_w2_out,

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
idle_hit,
write_to_pmem,
read_from_pmem
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
	datastore_in_mux_sel = 1'b0;  // 0:pmem, 1:parser(way)
    mem_resp = 1'b0;
	pmem_read = 0;
	pmem_write = 0;
	pmem_address_mux_sel = 0;
	lru_in = 0;
	dirty_array_w1_in = 0;
	dirty_array_w2_in = 0;
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
		idle_hit: 
		begin
			// 
			if(ishit_w1 == 1 || ishit_w2 == 1)
			begin
				if(mem_read == 1)
				begin
					
					if(ishit_w1 == 1)
					begin
						mem_resp = 1;
						load_lru = 1;
						lru_in = 1;
					end
					if(ishit_w2 == 1)
					begin
						mem_resp = 1;
						load_lru = 1;
						lru_in = 0;
					end
				
				end
				if(mem_write == 1)
				begin
					if(ishit_w1 == 1)
					begin
						load_dirty_w1 = 1;
						dirty_array_w1_in = 1;
						load_datastore_w1 = 1;
						datastore_in_mux_sel = 1;
						mem_resp = 1;
						load_lru = 1;
						lru_in = 1;
					end
					if(ishit_w2 == 1)
					begin
						load_dirty_w2 = 1;
						dirty_array_w2_in = 1;
						load_datastore_w2 = 1;
						datastore_in_mux_sel = 1;
						mem_resp = 1;
						load_lru = 1;
						lru_in = 0;
					end
				end
			end

		end

		write_to_pmem: 
		begin
			//
			pmem_write = 1;
			if(lru_out == 0)
			begin
				pmem_write = 1;
				pmem_address_mux_sel = 0;
			end
			else
			begin
				pmem_write = 1;
				pmem_address_mux_sel = 1;
			end
		end

		read_from_pmem: 
		begin
			//
			pmem_read = 1;
			pmem_address_mux_sel = 3;
			if(lru_out == 0)
			begin
				load_tag_w1 = 1;
				load_valid_w1 = 1;
				load_datastore_w1 = 1;
				load_dirty_w1 = 1;
				dirty_array_w1_in = 0;
				//load_lru = 1;
				//lru_in = 1;
			end
			else
			begin
				load_tag_w2 = 1;
				load_valid_w2 = 1;
				load_datastore_w2 = 1;
				load_dirty_w2 = 1;
				dirty_array_w2_in = 0;
				//load_lru = 1;
				//lru_in = 0;
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

	// input lru_out,
	// input logic ishit_w1,
	// input logic ishit_w2,
	// input logic isdirty_w1,
	// input logic isdirty_w2,
	// input logic mem_read,
	// input logic mem_write,
	// input logic pmem_resp,

		idle_hit: 
		begin
			// we have a miss
			if(ishit_w1 == 0 && ishit_w2 == 0)
			begin
				// what is the Least recent used?
				if( (lru_out == 0 && isdirty_w1 == 1) || (lru_out == 1 && isdirty_w2 ==1) )
				begin
					next_state = write_to_pmem;
				end
				else
				begin
					next_state = read_from_pmem;
				end
			end
			// we have a hit (stay in same state.)
			else
			begin
				next_state = idle_hit;
			end
		end

		write_to_pmem: 
		begin
			if(pmem_resp == 0)
			begin
				next_state = write_to_pmem;
			end
			else
			begin
				next_state = read_from_pmem;
			end
		end

		read_from_pmem: 
		begin
			if(pmem_resp == 0)
			begin
				next_state = read_from_pmem;
			end
			else
			begin
				next_state = idle_hit;
			end
		end
		
		default: next_state = idle_hit;
	endcase

end

// Next State Assignment Block
always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    state <= next_state;
end

endmodule : cache_control
