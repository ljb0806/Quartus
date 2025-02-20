transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave {D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/DDS_Sinwave.v}
vlog -vlog01compat -work work +incdir+D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave {D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/PLL_200M.v}
vlog -vlog01compat -work work +incdir+D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave {D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/SINROM.v}
vlog -vlog01compat -work work +incdir+D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave {D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/get_phase.v}
vlog -vlog01compat -work work +incdir+D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/db {D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/db/pll_200m_altpll.v}

vlog -vlog01compat -work work +incdir+D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/simulation/modelsim {D:/datas/project/Quartus_project/FPGA_modules/DDS_Sinwave/simulation/modelsim/DDS_Sinwave.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  DDS_Sinwave_vlg_tst

add wave *
view structure
view signals
run -all
