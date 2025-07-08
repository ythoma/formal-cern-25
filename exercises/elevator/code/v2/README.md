Formal Verification : Elevator FSM
==================================

This folder contains formal verification of an elevator FSM.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby

or

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby bmc

or

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby prove

or

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby cover


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, bmc, just checking coverage or all three).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── elevator_fsm.sby
├── src
│   └── elevator_fsm.vhd
└── src_tb
    └── elevator_fsm.psl

3 directories, 4 files
