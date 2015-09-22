onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 15 -label clk /mp2_tb/clk
add wave -noupdate -height 15 -label pc_out -radix hexadecimal /mp2_tb/dut/datapath/pc/out
add wave -noupdate -height 15 -label mem_address /mp2_tb/mem_address
add wave -noupdate -height 15 -label mem_read /mp2_tb/mem_read
add wave -noupdate -height 15 -label mem_rdata /mp2_tb/mem_rdata
add wave -noupdate -height 15 -label mem_write /mp2_tb/mem_write
add wave -noupdate -height 15 -label mem_byte_enable /mp2_tb/mem_byte_enable
add wave -noupdate -height 15 -label mem_wdata /mp2_tb/mem_wdata
add wave -noupdate -height 15 -label Registers -radix hexadecimal -childformat {{{/mp2_tb/dut/datapath/regfile/data[7]} -radix hexadecimal -childformat {{{/mp2_tb/dut/datapath/regfile/data[7][15]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][14]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][13]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][12]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][11]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][10]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][9]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][8]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][7]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][6]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][5]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][4]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][3]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][2]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][1]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][0]} -radix decimal}}} {{/mp2_tb/dut/datapath/regfile/data[6]} -radix hexadecimal} {{/mp2_tb/dut/datapath/regfile/data[5]} -radix hexadecimal} {{/mp2_tb/dut/datapath/regfile/data[4]} -radix hexadecimal} {{/mp2_tb/dut/datapath/regfile/data[3]} -radix hexadecimal} {{/mp2_tb/dut/datapath/regfile/data[2]} -radix hexadecimal} {{/mp2_tb/dut/datapath/regfile/data[1]} -radix hexadecimal} {{/mp2_tb/dut/datapath/regfile/data[0]} -radix hexadecimal}} -expand -subitemconfig {{/mp2_tb/dut/datapath/regfile/data[7]} {-height 15 -radix hexadecimal -childformat {{{/mp2_tb/dut/datapath/regfile/data[7][15]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][14]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][13]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][12]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][11]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][10]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][9]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][8]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][7]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][6]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][5]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][4]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][3]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][2]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][1]} -radix decimal} {{/mp2_tb/dut/datapath/regfile/data[7][0]} -radix decimal}}} {/mp2_tb/dut/datapath/regfile/data[7][15]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][14]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][13]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][12]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][11]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][10]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][9]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][8]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][7]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][6]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][5]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][4]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][3]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][2]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][1]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[7][0]} {-height 15 -radix decimal} {/mp2_tb/dut/datapath/regfile/data[6]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/datapath/regfile/data[5]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/datapath/regfile/data[4]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/datapath/regfile/data[3]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/datapath/regfile/data[2]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/datapath/regfile/data[1]} {-height 15 -radix hexadecimal} {/mp2_tb/dut/datapath/regfile/data[0]} {-height 15 -radix hexadecimal}} /mp2_tb/dut/datapath/regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 5} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 304
configure wave -valuecolwidth 131
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
WaveRestoreZoom {46958906 ps} {50160058 ps}
