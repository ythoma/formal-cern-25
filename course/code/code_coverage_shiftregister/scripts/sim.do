
# !/usr/bin/tclsh

# Main proc at the end #

#------------------------------------------------------------------------------
proc compile_duv { } {
  # do compile.do

  global Path_DUV
  puts "\nVHDL DUV compilation :"

  vcom +cover -2008 $Path_DUV/shiftregister.vhd
}

#------------------------------------------------------------------------------
proc compile_tb { } {
  global Path_TB
  global Path_DUV
  puts "\nVHDL TB compilation :"

  # Test Bench
  vcom -2008 $Path_TB/shiftregister_tb.vhd
}

#------------------------------------------------------------------------------
proc sim_start { DATASIZE TESTCASE} {

  vsim -coverage -t 1ns -GDATASIZE=$DATASIZE -GTESTCASE=$TESTCASE work.shiftregister_tb
#  do wave.do
  add wave -r *
  wave refresh
  run -all
}

#------------------------------------------------------------------------------
proc do_all {  DATASIZE TESTCASE} {
  compile_duv
  compile_tb
  sim_start $DATASIZE $TESTCASE
}

## MAIN #######################################################################

# Compile folder ----------------------------------------------------
if {[file exists work] == 0} {
  vlib work
}

puts -nonewline "  Path_VHDL => "
set Path_DUV     "../src"
set Path_TB       "../src_tb"

global Path_DUV
global Path_TB

# start of sequence -------------------------------------------------

if {$argc>0} {
  if {[string compare $1 "all"] == 0} {
    do_all $2 $3
  } elseif {[string compare $1 "comp_duv"] == 0} {
    compile_duv
  } elseif {[string compare $1 "comp_tb"] == 0} {
    compile_tb
  } elseif {[string compare $1 "sim"] == 0} {
    sim_start $2 $3
  }

} else {
  do_all 32 1
}
