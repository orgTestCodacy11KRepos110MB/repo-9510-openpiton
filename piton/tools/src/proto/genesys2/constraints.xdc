# Clock signals
set_property IOSTANDARD LVDS [get_ports clk_p]
set_property PACKAGE_PIN AD12 [get_ports clk_p]
set_property PACKAGE_PIN AD11 [get_ports clk_n]
set_property IOSTANDARD LVDS [get_ports clk_n]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets clk_mmcm/inst/clk_in1_clk_mmcm]

# Constraint core clock

# Reset
set_property IOSTANDARD LVCMOS33 [get_ports pin_rst]
set_property PACKAGE_PIN R19 [get_ports pin_rst]

# False paths
set_false_path -to [get_cells -hierarchical *afifo_ui_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_sync_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_syn_rst_delayed*]
set_false_path -to [get_cells init_calib_complete_r*]


#### UART
#IO_L11N_T1_SRCC_35 Sch=uart_rxd_out
set_property IOSTANDARD LVCMOS33 [get_ports pin_rx]
set_property PACKAGE_PIN Y20 [get_ports pin_rx]
set_property IOSTANDARD LVCMOS33 [get_ports pin_tx]
set_property PACKAGE_PIN Y23 [get_ports pin_tx]

# Loopback control for UART
set_property IOSTANDARD LVCMOS12 [get_ports uart_lb_sw]
set_property PACKAGE_PIN G19 [get_ports uart_lb_sw]

# Soft reset
set_property IOSTANDARD LVCMOS12 [get_ports pin_soft_rst]
set_property PACKAGE_PIN E18 [get_ports pin_soft_rst]

# SD
set_property IOSTANDARD LVCMOS33 [get_ports spi_clk_out]
set_property PACKAGE_PIN R28 [get_ports spi_clk_out]
set_property IOSTANDARD LVCMOS33 [get_ports spi_data_in]
set_property PACKAGE_PIN R26 [get_ports spi_data_in]
set_property IOSTANDARD LVCMOS33 [get_ports spi_data_out]
set_property PACKAGE_PIN R29 [get_ports spi_data_out]
set_property IOSTANDARD LVCMOS33 [get_ports spi_cs_n]
set_property PACKAGE_PIN T30 [get_ports spi_cs_n]

## LEDs

set_property PACKAGE_PIN T28 [get_ports led_0]
set_property IOSTANDARD LVCMOS33 [get_ports led_0]
set_property PACKAGE_PIN V19 [get_ports led_1]
set_property IOSTANDARD LVCMOS33 [get_ports led_1]
set_property PACKAGE_PIN U30 [get_ports led_2]
set_property IOSTANDARD LVCMOS33 [get_ports led_2]
set_property PACKAGE_PIN U29 [get_ports led_3]
set_property IOSTANDARD LVCMOS33 [get_ports led_3]
set_property PACKAGE_PIN V20 [get_ports led_4]
set_property IOSTANDARD LVCMOS33 [get_ports led_4]
set_property PACKAGE_PIN V26 [get_ports fake_noc2_ored]
set_property IOSTANDARD LVCMOS33 [get_ports fake_noc2_ored]
set_property PACKAGE_PIN W24 [get_ports fake_noc3_ored]
set_property IOSTANDARD LVCMOS33 [get_ports fake_noc3_ored]
set_property PACKAGE_PIN W23 [get_ports init_calib_complete]
set_property IOSTANDARD LVCMOS33 [get_ports init_calib_complete]


### False paths
set_clock_groups -name sync_gr1 -logically_exclusive -group [get_clocks core_ref_clk_clk_mmcm] -group [get_clocks -include_generated_clocks mc_sys_clk_clk_mmcm]
set_false_path -from [get_clocks clk_p] -to [get_clocks clk_n]
set_false_path -from [get_clocks clk_n] -to [get_clocks clk_p]
set_false_path -from [get_clocks core_ref_clk_clk_mmcm] -to [get_clocks core_ref_clk_clk_mmcm_1]
set_false_path -from [get_clocks core_ref_clk_clk_mmcm_1] -to [get_clocks core_ref_clk_clk_mmcm]
set_false_path -from [get_clocks clk_pll_i_1] -to [get_clocks clk_pll_i]
set_false_path -from [get_clocks clk_pll_i] -to [get_clocks clk_pll_i_1]
set_false_path -from [get_clocks core_ref_clk_clk_mmcm] -to [get_clocks clk_pll_i_1]
set_false_path -from [get_clocks clk_pll_i_1] -to [get_clocks core_ref_clk_clk_mmcm]


###############################################################






set_false_path -from [get_clocks core_ref_clk_clk_mmcm_1] -to [get_clocks clk_pll_i]

set_false_path -from [get_clocks core_ref_clk_clk_mmcm_1] -to [get_clocks clk_pll_i_1]

set_property LOC ILOGIC_X1Y119 [get_cells {mc_top/mig_7series_0/u_mig_7series_0_mig/u_memc_ui_top_std/mem_intfc0/ddr_phy_top0/u_ddr_mc_phy_wrapper/gen_dqs_iobuf_HP.gen_dqs_iobuf[2].gen_dqs_diff.u_iddr_edge_det/u_phase_detector}]
set_property PACKAGE_PIN AG2 [get_ports {ddr3_dqs_p[2]}]
set_property PACKAGE_PIN AH1 [get_ports {ddr3_dqs_n[2]}]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
