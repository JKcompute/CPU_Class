onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/tag
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/set
add wave -noupdate /mp2_tb/dut/cpu/cpu_datapath/alu/aluop
add wave -noupdate /mp2_tb/dut/cpu/cpu_datapath/alu/a
add wave -noupdate -radix hexadecimal /mp2_tb/dut/cpu/cpu_datapath/alu/b
add wave -noupdate /mp2_tb/dut/cpu/cpu_datapath/alu/f
add wave -noupdate /mp2_tb/dut/cpu/cpu_control/state
add wave -noupdate /mp2_tb/dut/cpu/cpu_control/next_state
add wave -noupdate /mp2_tb/dut/cache/cache_control/state
add wave -noupdate /mp2_tb/dut/cache/cache_control/next_state
add wave -noupdate /mp2_tb/dut/cpu/cpu_control/mem_resp
add wave -noupdate /mp2_tb/dut/cpu/cpu_control/mem_read
add wave -noupdate /mp2_tb/dut/cpu/cpu_control/mem_write
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/datastore_array_w1/data
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/datastore_array_w2/data
add wave -noupdate -expand /mp2_tb/dut/cpu/cpu_datapath/regfile/data
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_dirty_w1
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/lru/data
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/lru/write
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/lru/index
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/lru/datain
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/lru/dataout
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_valid_w1
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_tag_w1
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_datastore_w1
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_dirty_w2
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_valid_w2
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_tag_w2
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_datastore_w2
add wave -noupdate /mp2_tb/dut/cache/cache_control/load_lru
add wave -noupdate /mp2_tb/dut/cache/cache_control/datastore_in_mux_sel
add wave -noupdate /mp2_tb/dut/cache/cache_control/pmem_address_mux_sel
add wave -noupdate /mp2_tb/dut/cache/cache_control/lru_out
add wave -noupdate /mp2_tb/dut/cache/cache_control/lru_in
add wave -noupdate /mp2_tb/dut/cache/cache_control/dirty_array_w1_in
add wave -noupdate /mp2_tb/dut/cache/cache_control/dirty_array_w2_in
add wave -noupdate /mp2_tb/dut/cache/cache_control/dirty_compare_w1_out
add wave -noupdate /mp2_tb/dut/cache/cache_control/dirty_compare_w2_out
add wave -noupdate /mp2_tb/dut/cache/cache_control/ishit_w1
add wave -noupdate /mp2_tb/dut/cache/cache_control/ishit_w2
add wave -noupdate /mp2_tb/dut/cache/cache_control/isdirty_w1
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/tag
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/waytag
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/valid_in
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/dirty_in
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/hit_out
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/dirty_out
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/tag_compare
add wave -noupdate /mp2_tb/dut/cache/cache_control/isdirty_w2
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/tag
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/waytag
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/valid_in
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/dirty_in
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/hit_out
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/dirty_out
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/tag_compare
add wave -noupdate /mp2_tb/dut/cache/cache_control/mem_resp
add wave -noupdate /mp2_tb/dut/cpu/cpu_control/mem_read
add wave -noupdate /mp2_tb/dut/cache/cache_control/mem_read
add wave -noupdate /mp2_tb/dut/cache/cache_control/mem_write
add wave -noupdate /mp2_tb/dut/cache/cache_control/pmem_resp
add wave -noupdate /mp2_tb/dut/cache/cache_control/pmem_read
add wave -noupdate /mp2_tb/dut/cache/cache_control/pmem_write
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/dirty_array_w1/data
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/valid_array_w1/data
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/tag_array_w1/data
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/tag_compare
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/dirty_out
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w1/hit_out
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/dirty_array_w2/data
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/valid_array_w2/data
add wave -noupdate -expand /mp2_tb/dut/cache/cache_datapath/tag_array_w2/data
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/hit_out
add wave -noupdate /mp2_tb/dut/cache/cache_datapath/dirty_hit_w2/dirty_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7459848 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 388
configure wave -valuecolwidth 282
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {7225042 ps} {7583492 ps}
