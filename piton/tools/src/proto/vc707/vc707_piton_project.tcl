# Copyright (c) 2016 Princeton University
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Princeton University nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set MODEL_DIR $::env(MODEL_DIR)
set DV_ROOT $::env(DV_ROOT)
set origin_dir "$MODEL_DIR/vc707"

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

variable script_file
set script_file "vc707_piton_project.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir" { incr i; set origin_dir [lindex $::argv $i] }
      "--help"       { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/vc707_piton"]"

# Create project
create_project -force vc707_piton ./vc707_piton

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects vc707_piton]
set_property "board_part" "xilinx.com:vc707:part0:1.1" $obj
set_property "compxlib.activehdl_compiled_library_dir" "$proj_dir/vc707_piton.cache/compile_simlib/activehdl" $obj
set_property "compxlib.funcsim" "1" $obj
set_property "compxlib.ies_compiled_library_dir" "$proj_dir/vc707_piton.cache/compile_simlib/ies" $obj
set_property "compxlib.modelsim_compiled_library_dir" "$proj_dir/vc707_piton.cache/compile_simlib/modelsim" $obj
set_property "compxlib.overwrite_libs" "0" $obj
set_property "compxlib.questa_compiled_library_dir" "$proj_dir/vc707_piton.cache/compile_simlib/questa" $obj
set_property "compxlib.riviera_compiled_library_dir" "$proj_dir/vc707_piton.cache/compile_simlib/riviera" $obj
set_property "compxlib.timesim" "1" $obj
set_property "compxlib.vcs_compiled_library_dir" "$proj_dir/vc707_piton.cache/compile_simlib" $obj
set_property "corecontainer.enable" "0" $obj
set_property "default_lib" "xil_defaultlib" $obj
set_property "enable_optional_runs_sta" "0" $obj
set_property "ip_cache_permissions" "" $obj
set_property "ip_output_repo" "" $obj
set_property "managed_ip" "0" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "source_mgmt_mode" "All" $obj
set_property "target_language" "Verilog" $obj
set_property "target_simulator" "VCS" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/../../piton/design/include/dmbr_define.v"]"\
 "[file normalize "$origin_dir/../../piton/design/include/define.vh"]"\
 "[file normalize "$origin_dir/../../piton/design/include/l15.tmp.h"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/include/mc_define.h"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/include/uart16550_define.vh"]"\
 "[file normalize "$origin_dir/../../piton/design/include/network_define.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_stsm.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_shiftreg.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_rtsm.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_lfsr.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_htsm.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_counter.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/common/rtl/bw_r_irf_register.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/swrvr_clib.v"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_128x80/virtex7_bram_128x80.xci"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/swrvr_dlib.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_fsm.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rndrob.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_cnt6.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclcomp7.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluspr.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluor32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluadder64.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register8/rtl/bw_r_irf_register8.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register16/rtl/bw_r_irf_register16.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_128x80_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/u1.beh.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_rrobin_picker.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_prencoder16.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_addern_32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/sram_wrappers/sram_1rw_128x78.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_zcmp64.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_penc64.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_dec64.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_thrfsm.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_thrcmpl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_swpla.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_rndrob.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_par34.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_par32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_par16.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_milfsm.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_lru4.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_lfsr5.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_incr46.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_ctr5.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_cmp35.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_part_add32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_ctl_visctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rml_inc3.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rml_cwp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_reg.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_wb.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_mdqctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_eccctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_divcntl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclccr.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclbyplog_rs1.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclbyplog.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecc_dec.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_div_yreg.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_div_32eql.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_byp_eccgen.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_alu_16eql.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluzcmp64.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_alulogic.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluaddsub.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/mul64.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/m1.beh.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_rrobin_picker2.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_pcx_qmon.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dc_parity_gen.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dcache_lfsr.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_asi_decode.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/rtl/bw_r_irf.v"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_1024x64/virtex7_bram_1024x64.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_256x104/virtex7_bram_256x104.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_4096x144/virtex7_bram_4096x144.xci"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_4096x144_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_1024x64_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_tdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_tcl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_pib.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_mmu_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_mmu_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_misctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_incr64.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_hyperv.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_intdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_intctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_cntl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_wseldp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_swl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_sscan.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_invctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_imd.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_ifqdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_ifqctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_fdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_fcl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_errdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_errctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_dec.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_dcl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_vis.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_shft.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rml.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecc.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_div.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_byp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_alu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/one_of_five.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_tlbdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_tagdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_rwdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_rwctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_ctldp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qdp2.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qdp1.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qctl2.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qctl1.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_excpctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dctldp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dcdp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_priority_encoder.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_route_request_calc.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_scm.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_rf32x80.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_rf32x152b.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/srams/rtl/bw_r_rf16x160.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/rtl/bw_r_irf_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_icd.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_frf.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_dcd.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_256x104_wrapper.v"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_2p_256x176/virtex7_bram_2p_256x176.xci"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_tag.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_state.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_dir.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_data.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_top.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/common/rtl/space_avail_top.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/common/rtl/network_input_blk_multi_out.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_priority_encoder.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data_pgen.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data_ecc.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_home_encoder.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_hmc.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/flat_id_to_xy.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_output_datapath.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_output_control.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_control.v"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_512x32/virtex7_bram_512x32.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_512x128/virtex7_bram_512x128.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_128x160/virtex7_bram_128x160.xci"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_nospu_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/sram_wrappers/sram_l15_tag.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/sram_wrappers/sram_l15_hmt.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/sram_wrappers/sram_l15_data.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_top_nospu_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_nospu_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_nospu_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/simplenocbuffer.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/pcx_decoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/pcx_buffer.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/one_of_eight.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc3encoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc3buffer.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc2decoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc1encoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc1buffer.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/net_dff.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_nospu_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_tag.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_state.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_smc.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2_dpath.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2_ctrl.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2_buf_in.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_dpath.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_ctrl.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_buf_out.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_buf_in.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_mshr_decoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_mshr.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_encoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_dir.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_decoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_broadcast_counter.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_pipeline.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_mshr.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_csm.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_cpxencoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/flip_bus.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_output_top.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_top_4.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_top_16.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/rtl/cpx_spc_rpt.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/rtl/cpx_spc_buf.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/rtl/cfg_asi.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/bus_compare_equal.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_bus_out.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_bus_in.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mc/rtl/mig_addr_translator.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/rtl/synchronizer.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/rtl/sparc.v"]"\
 "[file normalize "$origin_dir/../../piton/design/include/jtag.vh"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/rtap/rtl/rtap_ucb_transmitter.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/rtap/rtl/rtap_ucb_receiver.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_tag_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_state_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_smc_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_mshr_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_dir_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_config_regs.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_broadcast_counter_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_interface_tap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/rtl/dynamic_node_top.v"]"\
 "[file normalize "$origin_dir/ip_cores/mem_uart_done/mem_uart_done.xci"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_256x512_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_writer.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_reader.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_mux.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/rtl/cpx_arbitrator.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/valrdy_to_credit.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/rtl/sparc_core.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/rtap/rtl/rtap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_ucb_transmitter.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_ucb_receiver.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_interface.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_ctap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_arb_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dynamic_node/rtl/dynamic_node_top_wrap.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/dmbr/rtl/dmbr.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/credit_to_valrdy.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/rtl/config_regs.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/clk_gating_latch.v"]"\
 "[file normalize "$origin_dir/ip_cores/uart_16550/uart_16550.xci"]"\
 "[file normalize "$origin_dir/ip_cores/atg_uart_init/atg_uart_init.xci"]"\
 "[file normalize "$origin_dir/bram_map.v"]"\
 "[file normalize "$origin_dir/../../piton/verif/env/common/fake_boot_ctrl.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_top.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mem_io_splitter/rtl/uart_boot_splitter.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/noc_axilite_bridge/rtl/noc_axilite_bridge.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/rtl/tile.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/rtl/OCI.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/jtag/rtl/jtag.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mem_io_splitter/rtl/mem_io_splitter.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/io_ctrl_top.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/blinker.v"]"\
 "[file normalize "$origin_dir/../../piton/verif/env/manycore/ciop_iob.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/verif/env/manycore/cross_module.tmp.h"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/rtl/chip.v.xlx.v"]"\
 "[file normalize "$origin_dir/ip_cores/clk_mmcm/clk_mmcm.xci"]"\
 "[file normalize "$origin_dir/../../piton/verif/env/manycore/manycore_top.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_3to1.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_3b.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_2b.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_denorm_3to1.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_denorm_3b.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl4.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl3.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl2.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl1.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_frac.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_denorm_frac.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_64b.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_53b.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_rptr_min_global.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_rptr_macros.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_out_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_out_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul_frac_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul_exp_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div_frac_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div_exp_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add_frac_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add_exp_dp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add_ctl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_rptr_groups.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_out.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_buf.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_arb.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_16384x512_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_map_obp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mc/rtl/pkt_trans_dp_wide.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mc/rtl/mig_mux.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mig_trans_intfc/mig_async_fifo.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mc/rtl/mc_top.v"]"\
 "[file normalize "$origin_dir/../../piton/verif/env/common/fake_mem_ctrl.v.xlx.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_512x64_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_2048x144_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_128x108_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_256x272_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_128x288_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/test_stub_scan.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/chip_bridge/rtl/sync_fifo.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_net_chooser_32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/chip_bridge/rtl/async_fifo.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/fpga_bridge/fpga_send/rtl/fpga_net_chooser_32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_bridge_send_32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_bridge_rcv_32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/fpga_bridge/fpga_send/rtl/fpga_bridge_send_32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/fpga_bridge/fpga_rcv/rtl/fpga_bridge_rcv_32.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/synchronizer_asr.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/synchronizer_asr_dup.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_128x512_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_flow_2buf.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_bridge.v"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/bram_sdp_4096x512_wrapper.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/fpga_bridge/rtl/fpga_bridge.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header_sync.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/sync_pulse_synchronizer.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/dbl_buf.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_flow_spi.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/test_stub_bist.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_flow_jbi.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header_dup.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_noflow.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/cmp_sram_redhdr.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header_ctu.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/iosplitter_axi_lite/rtl/iosplitter_axi_lite.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/iosplitter_axi_lite/rtl/iosplitter_axi_lite_updated.v"]"\
 "[file normalize "$origin_dir/test_proto.coe"]"\
 "[file normalize "$origin_dir/uart_data.coe"]"\
 "[file normalize "$origin_dir/uart_addr.coe"]"\
 "[file normalize "$origin_dir/mem_uart_done.coe"]"\
 "[file normalize "$origin_dir/../../piton/design/proto/fpga_top.v"]"\
 "[file normalize "$origin_dir/obp.coe"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_2048x144/virtex7_bram_2048x144.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_128x108/virtex7_bram_128x108.xci"]"\
 "[file normalize "$origin_dir/ip_cores/afifo_splitter_mem/afifo_splitter_mem.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_8192x512/virtex7_bram_8192x512.xci"]"\
 "[file normalize "$origin_dir/ip_cores/afifo_mem_splitter/afifo_mem_splitter.xci"]"\
 "[file normalize "$origin_dir/ip_cores/mig_7series_0/mig_7series_0.xci"]"\
 "[file normalize "$origin_dir/ip_cores/mig_7series_0/mig_a.prj"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_16384x512/virtex7_bram_16384x512.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_512x64/virtex7_bram_512x64.xci"]"\
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_2p_128x176/virtex7_bram_2p_128x176.xci"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/noc_axilite_bridge/rtl/noc_axilite_bridge_boot.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/axi_sd_bridge.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/spi_master.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/init_sd.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/read_write_sd_block.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/rwspi_wire_data.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sd_block_cache.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sd_cache_defines.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sd_wishbone_transaction_manager.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/send_cmd.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sm_dp_mem_dc.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sm_fifo_rtl.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sm_rx_fifo.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sm_rx_fifo_bi.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sm_tx_fifo.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/sm_tx_fifo_bi.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/spi_control.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/spi_master_defines.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/spi_master_wishbone_decoder.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/spi_tx_rx_data.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/axi_sd_bridge/rtl/status_register_control.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/rf_l15_wmt.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/rf_l15_lruarray.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/l15/rtl/rf_l15_mesi.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/include/ifu.tmp.h"]"\
 "[file normalize "$origin_dir/../../piton/design/include/lsu.tmp.h"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_itlb.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_ict.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/sram_l1i_val.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/sram_l1d_val.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_dct.v"]"\
 "[file normalize "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_dtlb.tmp.v"]"\
 "[file normalize "$origin_dir/../../piton/design/fpga/mem_io_splitter/rtl/iob_splitter.v"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/../../piton/design/include/dmbr_define.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "1" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/include/define.vh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "1" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/include/mc_define.h"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "1" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "include/ifu.tmp.h"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "1" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "include/l15.tmp.h"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "1" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "include/lsu.tmp.h"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "1" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/include/uart16550_define.vh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "1" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/include/network_define.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_stsm.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_shiftreg.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_rtsm.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_lfsr.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_htsm.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_counter.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/common/rtl/bw_r_irf_register.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/swrvr_clib.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_128x80/virtex7_bram_128x80.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/swrvr_dlib.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl_fsm.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rndrob.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_cnt6.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclcomp7.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluspr.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluor32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluadder64.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register8/rtl/bw_r_irf_register8.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/bw_r_irf_register16/rtl/bw_r_irf_register16.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_128x80_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/u1.beh.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_rrobin_picker.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_prencoder16.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_addern_32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/sram_wrappers/sram_1rw_128x78.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_zcmp64.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_penc64.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_dec64.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_thrfsm.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_thrcmpl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_swpla.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_rndrob.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_par34.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_par32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_par16.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_milfsm.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_lru4.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_lfsr5.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_incr46.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_esl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_ctr5.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_cmp35.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_part_add32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_ctl_visctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rml_inc3.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rml_cwp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_reg.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_wb.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_mdqctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_eccctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl_divcntl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclccr.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclbyplog_rs1.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_eclbyplog.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecc_dec.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_div_yreg.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_div_32eql.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_byp_eccgen.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_alu_16eql.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluzcmp64.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_alulogic.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_aluaddsub.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/mul64.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/m1.beh.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_rrobin_picker2.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_pcx_qmon.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dc_parity_gen.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dcache_lfsr.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_asi_decode.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/rtl/bw_r_irf.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_1024x64/virtex7_bram_1024x64.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_256x104/virtex7_bram_256x104.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_4096x144/virtex7_bram_4096x144.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_4096x144_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_1024x64_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_tdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_tcl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_pib.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_mmu_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_mmu_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_misctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_incr64.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_hyperv.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_intdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/sparc_tlu_intctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_cntl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_wseldp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_swl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_sscan.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_invctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_imd.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_ifqdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_ifqctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_fdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_fcl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_errdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_errctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_dec.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_dcl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_vis.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_shft.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_rml.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_ecc.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_div.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_byp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_alu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/one_of_five.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_tlbdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_tagdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_rwdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_rwctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_ctldp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_stb_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qdp2.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qdp1.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qctl2.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_qctl1.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_excpctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dctldp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_dcdp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_priority_encoder.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/rf_l15_wmt.tmp.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/sram_l1d_val.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/sram_l1i_val.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/bw_r_dct.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/bw_r_dtlb.tmp.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/bw_r_ict.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/bw_r_itlb.tmp.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/iob_splitter.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/rf_l15_lruarray.tmp.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "rtl/rf_l15_mesi.tmp.v"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_route_request_calc.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_scm.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_rf32x80.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_rf32x152b.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/srams/rtl/bw_r_rf16x160.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/bw_r_irf/rtl/bw_r_irf_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_icd.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_frf.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/srams/rtl/bw_r_dcd.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_256x104_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_2p_256x176/virtex7_bram_2p_256x176.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_tag.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_state.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_dir.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/sram_wrappers/sram_l2_data.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/common/rtl/space_avail_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/common/rtl/network_input_blk_multi_out.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_priority_encoder.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data_pgen.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data_ecc.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_home_encoder.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_hmc.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/flat_id_to_xy.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_output_datapath.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_output_control.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_control.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_512x32/virtex7_bram_512x32.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_512x128/virtex7_bram_512x128.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_128x160/virtex7_bram_128x160.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/tlu/rtl/tlu_nospu_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/sram_wrappers/sram_l15_tag.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/sram_wrappers/sram_l15_hmt.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/sram_wrappers/sram_l15_data.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/mul/rtl/sparc_mul_top_nospu_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ifu/rtl/sparc_ifu_nospu_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/ffu/rtl/sparc_ffu_nospu_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/exu/rtl/sparc_exu_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/simplenocbuffer.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/pcx_decoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/pcx_buffer.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/one_of_eight.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc3encoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc3buffer.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc2decoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc1encoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/noc1buffer.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/net_dff.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/lsu/rtl/lsu_nospu_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_tag.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_state.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_smc.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2_dpath.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2_ctrl.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2_buf_in.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_dpath.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_ctrl.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_buf_out.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1_buf_in.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_mshr_decoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_mshr.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_encoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_dir.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_decoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_broadcast_counter.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_pipeline.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_mshr.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_csm.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_cpxencoder.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/flip_bus.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_output_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_top_4.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/dynamic/rtl/dynamic_input_top_16.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/rtl/cpx_spc_rpt.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/rtl/cpx_spc_buf.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/rtl/cfg_asi.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/components/rtl/bus_compare_equal.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_bus_out.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_bus_in.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/mc/rtl/mig_addr_translator.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/rtl/synchronizer.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/rtl/sparc.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/include/jtag.vh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/rtap/rtl/rtap_ucb_transmitter.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/rtap/rtl/rtap_ucb_receiver.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_tag_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_state_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_smc_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe2.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_pipe1.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_mshr_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_dir_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_data_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_config_regs.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2_broadcast_counter_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_interface_tap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/rtl/dynamic_node_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/mem_uart_done/mem_uart_done.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_256x512_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_writer.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_reader.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_mux.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/rtl/cpx_arbitrator.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/valrdy_to_credit.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/sparc/rtl/sparc_core.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/rtap/rtl/rtap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l2/rtl/l2.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/l15/rtl/l15_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_ucb_transmitter.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_ucb_receiver.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_interface.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/jtag/rtl/jtag_ctap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_arb_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dynamic_node/rtl/dynamic_node_top_wrap.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/dmbr/rtl/dmbr.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/credit_to_valrdy.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/rtl/config_regs.tmp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/clk_gating_latch.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/uart_16550/uart_16550.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/atg_uart_init/atg_uart_init.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/bram_map.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/verif/env/common/fake_boot_ctrl.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/uart_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/mem_io_splitter/rtl/uart_boot_splitter.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/noc_axilite_bridge/rtl/noc_axilite_bridge.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/rtl/tile.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/rtl/OCI.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/jtag/rtl/jtag.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/mem_io_splitter/rtl/mem_io_splitter.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/io_ctrl/rtl/io_ctrl_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/blinker.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/verif/env/manycore/ciop_iob.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/verif/env/manycore/cross_module.tmp.h"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog Header" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/rtl/chip.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/clk_mmcm/clk_mmcm.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/verif/env/manycore/manycore_top.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_3to1.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_3b.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_2b.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_denorm_3to1.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_denorm_3b.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl4.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl3.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl2.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_lvl1.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in2_gt_in1_frac.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_denorm_frac.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_64b.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_cnt_lead0_53b.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_rptr_min_global.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_rptr_macros.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_out_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_out_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul_frac_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul_exp_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div_frac_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div_exp_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add_frac_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add_exp_dp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add_ctl.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_rptr_groups.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_out.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_mul.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_in.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_div.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_add.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_buf.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/fpu/rtl/fpu_arb.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_16384x512_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_map_obp.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/mc/rtl/pkt_trans_dp_wide.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/mc/rtl/mig_mux.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/mig_trans_intfc/mig_async_fifo.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/mc/rtl/mc_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/verif/env/common/fake_mem_ctrl.v.xlx.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_512x64_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_2048x144_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_128x108_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_256x272_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_128x288_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/test_stub_scan.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/chip_bridge/rtl/sync_fifo.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_net_chooser_32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/chip_bridge/rtl/async_fifo.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/fpga_bridge/fpga_send/rtl/fpga_net_chooser_32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_bridge_send_32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_bridge_rcv_32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/fpga_bridge/fpga_send/rtl/fpga_bridge_send_32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/fpga_bridge/fpga_rcv/rtl/fpga_bridge_rcv_32.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/synchronizer_asr.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/synchronizer_asr_dup.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_128x512_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_flow_2buf.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/chip_bridge/rtl/chip_bridge.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/bram_sdp_4096x512_wrapper.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/fpga_bridge/rtl/fpga_bridge.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header_sync.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/sync_pulse_synchronizer.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/dbl_buf.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_flow_spi.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/test_stub_bist.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_flow_jbi.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header_dup.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/ucb_noflow.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/cmp_sram_redhdr.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/chip/tile/common/rtl/cluster_header_ctu.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/iosplitter_axi_lite/rtl/iosplitter_axi_lite.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/fpga/iosplitter_axi_lite/rtl/iosplitter_axi_lite_updated.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/test_proto.coe"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/uart_data.coe"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/uart_addr.coe"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/mem_uart_done.coe"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/../../piton/design/proto/fpga_top.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "Verilog" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/obp.coe"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis simulation" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_2048x144/virtex7_bram_2048x144.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_128x108/virtex7_bram_128x108.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/afifo_splitter_mem/afifo_splitter_mem.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_8192x512/virtex7_bram_8192x512.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/afifo_mem_splitter/afifo_mem_splitter.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/mig_7series_0/mig_7series_0.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/mig_7series_0/mig_a.prj"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_16384x512/virtex7_bram_16384x512.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_512x64/virtex7_bram_512x64.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

set file "$origin_dir/ip_cores/virtex7_bram_2p_128x176/virtex7_bram_2p_128x176.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "design_mode" "RTL" $obj
set_property "edif_extra_search_paths" "" $obj
set_property "elab_link_dcps" "1" $obj
set_property "elab_load_timing_constraints" "1" $obj
set_property "generic" "" $obj
set_property "include_dirs" "" $obj
set_property "lib_map_file" "" $obj
set_property "loop_count" "1000" $obj
set_property "name" "sources_1" $obj
set_property "top" "cmp_top" $obj
set_property "verilog_define" "NO_SCAN FPGA_SYN FPGA_SYN_1THREAD NO_USE_IBM_SRAMS PITON_PROTO PITON_FPGA_SYNTH PITON_FPGA_NO_DMBR VC707_BOARD PITON_FPGA_MC_DDR3 PITON_FPGA_SD_BOOT" $obj
set_property "verilog_uppercase" "0" $obj

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/ip_cores/virtex7_bram_256x512/virtex7_bram_256x512.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/ip_cores/virtex7_bram_256x512/virtex7_bram_256x512.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/ip_cores/uart_mig_afifo/uart_mig_afifo.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/ip_cores/uart_mig_afifo/uart_mig_afifo.xci"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
if { ![get_property "is_locked" $file_obj] } {
  set_property "generate_synth_checkpoint" "1" $file_obj
}
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "used_in" "synthesis implementation simulation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_simulation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj


# Set 'sources_1' fileset file properties for local files
# None

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/constraints.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "$origin_dir/constraints.xdc"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj
set_property "is_enabled" "1" $file_obj
set_property "is_global_include" "0" $file_obj
set_property "library" "xil_defaultlib" $file_obj
set_property "path_mode" "RelativeFirst" $file_obj
set_property "processing_order" "NORMAL" $file_obj
set_property "scoped_to_cells" "" $file_obj
set_property "scoped_to_ref" "" $file_obj
set_property "used_in" "synthesis implementation" $file_obj
set_property "used_in_implementation" "1" $file_obj
set_property "used_in_synthesis" "1" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "name" "constrs_1" $obj
set_property "target_constrs_file" "[file normalize "$origin_dir/constraints.xdc"]" $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "generic" "" $obj
set_property "include_dirs" "" $obj
set_property "name" "sim_1" $obj
set_property "nl.cell" "" $obj
set_property "nl.incl_unisim_models" "0" $obj
set_property "nl.process_corner" "slow" $obj
set_property "nl.rename_top" "" $obj
set_property "nl.sdf_anno" "1" $obj
set_property "nl.write_all_overrides" "0" $obj
set_property "runtime" "" $obj
set_property "source_set" "sources_1" $obj
set_property "top" "fpga_top" $obj
set_property "unit_under_test" "" $obj
set_property "vcs.compile.load_glbl" "1" $obj
set_property "vcs.compile.vhdlan.more_options" "" $obj
set_property "vcs.compile.vlogan.more_options" -value "-v2005" -object $obj
set_property "vcs.elaborate.debug_pp" "1" $obj
set_property "vcs.elaborate.vcs.more_options" "" $obj
set_property "vcs.simulate.runtime" "1000ns" $obj
set_property "vcs.simulate.saif" "" $obj
set_property "vcs.simulate.uut" "" $obj
set_property "vcs.simulate.vcs.more_options" "" $obj
set_property "verilog_define" "NO_SCAN FPGA_SYN FPGA_SYN_1THREAD NO_USE_IBM_SRAMS PITON_PROTO PITON_FPGA_SYNTH PITON_FPGA_NO_DMBR VC707_BOARD PITON_FPGA_BRAM_TEST" $obj
set_property "verilog_uppercase" "0" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7vx485tffg1761-2 -flow {Vivado Synthesis 2015} -strategy "Flow_PerfOptimized_high" -constrset constrs_1
} else {
  set_property strategy "Flow_PerfOptimized_high" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2015" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property "constrset" "constrs_1" $obj
set_property "description" "Higher performance designs, resource sharing is turned off, the global fanout guide is set to a lower number, FSM extraction forced to one-hot, LUT combining is disabled, equivalent registers are preserved, SRL are inferred  with a larger threshold" $obj
set_property "flow" "Vivado Synthesis 2015" $obj
set_property "name" "synth_1" $obj
set_property "needs_refresh" "1" $obj
set_property "srcset" "sources_1" $obj
set_property "strategy" "Flow_PerfOptimized_high" $obj
set_property "incremental_checkpoint" "" $obj
set_property "include_in_archive" "1" $obj
set_property "steps.synth_design.tcl.pre" "" $obj
set_property "steps.synth_design.tcl.post" "" $obj
set_property "steps.synth_design.args.flatten_hierarchy" "rebuilt" $obj
set_property "steps.synth_design.args.gated_clock_conversion" "off" $obj
set_property "steps.synth_design.args.bufg" "12" $obj
set_property "steps.synth_design.args.fanout_limit" "400" $obj
set_property "steps.synth_design.args.directive" "Default" $obj
set_property "steps.synth_design.args.fsm_extraction" "one_hot" $obj
set_property "steps.synth_design.args.keep_equivalent_registers" "1" $obj
set_property "steps.synth_design.args.resource_sharing" "off" $obj
set_property "steps.synth_design.args.control_set_opt_threshold" "auto" $obj
set_property "steps.synth_design.args.no_lc" "1" $obj
set_property "steps.synth_design.args.shreg_min_size" "5" $obj
set_property "steps.synth_design.args.max_bram" "-1" $obj
set_property "steps.synth_design.args.max_dsp" "-1" $obj
set_property "steps.synth_design.args.cascade_dsp" "auto" $obj
set_property -name {steps.synth_design.args.more options} -value {} -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7vx485tffg1761-2 -flow {Vivado Implementation 2015} -strategy "Performance_Explore" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Performance_Explore" [get_runs impl_1]
  set_property flow "Vivado Implementation 2015" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "constrset" "constrs_1" $obj
set_property "description" "Uses multiple algorithms for optimization, placement, and routing to get potentially better results." $obj
set_property "flow" "Vivado Implementation 2015" $obj
set_property "name" "impl_1" $obj
set_property "needs_refresh" "1" $obj
set_property "srcset" "sources_1" $obj
set_property "strategy" "Performance_Explore" $obj
set_property "incremental_checkpoint" "" $obj
set_property "include_in_archive" "1" $obj
set_property "steps.opt_design.is_enabled" "1" $obj
set_property "steps.opt_design.tcl.pre" "" $obj
set_property "steps.opt_design.tcl.post" "" $obj
set_property "steps.opt_design.args.verbose" "0" $obj
set_property "steps.opt_design.args.directive" "Explore" $obj
set_property -name {steps.opt_design.args.more options} -value {} -objects $obj
set_property "steps.power_opt_design.is_enabled" "0" $obj
set_property "steps.power_opt_design.tcl.pre" "" $obj
set_property "steps.power_opt_design.tcl.post" "" $obj
set_property -name {steps.power_opt_design.args.more options} -value {} -objects $obj
set_property "steps.place_design.tcl.pre" "" $obj
set_property "steps.place_design.tcl.post" "" $obj
set_property "steps.place_design.args.directive" "Explore" $obj
set_property -name {steps.place_design.args.more options} -value {} -objects $obj
set_property "steps.post_place_power_opt_design.is_enabled" "0" $obj
set_property "steps.post_place_power_opt_design.tcl.pre" "" $obj
set_property "steps.post_place_power_opt_design.tcl.post" "" $obj
set_property -name {steps.post_place_power_opt_design.args.more options} -value {} -objects $obj
set_property "steps.phys_opt_design.is_enabled" "1" $obj
set_property "steps.phys_opt_design.tcl.pre" "" $obj
set_property "steps.phys_opt_design.tcl.post" "" $obj
set_property "steps.phys_opt_design.args.directive" "Explore" $obj
set_property -name {steps.phys_opt_design.args.more options} -value {} -objects $obj
set_property "steps.route_design.tcl.pre" "" $obj
set_property "steps.route_design.tcl.post" "" $obj
set_property "steps.route_design.args.directive" "Explore" $obj
set_property -name {steps.route_design.args.more options} -value {} -objects $obj
set_property "steps.post_route_phys_opt_design.is_enabled" "0" $obj
set_property "steps.post_route_phys_opt_design.tcl.pre" "" $obj
set_property "steps.post_route_phys_opt_design.tcl.post" "" $obj
set_property "steps.post_route_phys_opt_design.args.directive" "Default" $obj
set_property -name {steps.post_route_phys_opt_design.args.more options} -value {} -objects $obj
set_property "steps.write_bitstream.tcl.pre" "" $obj
set_property "steps.write_bitstream.tcl.post" "" $obj
set_property "steps.write_bitstream.args.raw_bitfile" "0" $obj
set_property "steps.write_bitstream.args.mask_file" "0" $obj
set_property "steps.write_bitstream.args.no_binary_bitfile" "0" $obj
set_property "steps.write_bitstream.args.bin_file" "0" $obj
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.logic_location_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj
set_property -name {steps.write_bitstream.args.more options} -value {} -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:vc707_piton"
