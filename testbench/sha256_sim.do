
vlib work

# libs

#vcom -explicit	-93 "sha256_w_gen.vhd"
#vcom -explicit	-93 "sha256_k_table.vhd"
#vcom -explicit	-93 "sha256_round.vhd"
#vcom -explicit	-93 "sha256_calc.vhd"
#vcom -explicit	-93 "tb_sha256.vhd"

# Sim

vsim -lib work -t 1ps tb_sha256

view wave
view signals
add wave -hex *

add wave {sim:/tb_sha256/uut0/state}
add wave -unsigned {sim:/tb_sha256/uut0/count_reg}

add wave -hex \
{sim:/tb_sha256/uut0/round_inst/?_out} \
{sim:/tb_sha256/uut0/round_inst/temp?_sig} \
{sim:/tb_sha256/uut0/round_inst/w_reg} \
{sim:/tb_sha256/uut0/round_inst/k_reg}


run 3 us

