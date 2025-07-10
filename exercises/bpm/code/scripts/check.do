


proc check_psl { } {

  vcom -2008 -pslfile ../src_tb/bpm.psl ../src_tb/bpm_pkg.vhd ../src_duv/bpm.vhd

  formal compile -d bpm -work work

  formal verify
}


check_psl
