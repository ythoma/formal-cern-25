Formal Verification : Elevator FSM
==================================

This folder contains formal verification of an elevator FSM.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby

or

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby bmcX

or

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby proveX

or

sby --yosys "yosys -m ghdl" -f elevator_fsm.sby cover

When running the proveX or bmcX, replace the X by a numerical value between 0 and 6. For 0
the tests are expected to succeed, and for 1 to 6 they should fail, as the design will have internal
errors.

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
