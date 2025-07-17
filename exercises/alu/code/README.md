Formal Verification : ALU
=========================

This folder contains an example of formal verification of an alu.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f alu.sby

or

sby --yosys "yosys -m ghdl" -f alu.sby proveX

or

sby --yosys "yosys -m ghdl" -f alu.sby cover

When running the proveX, replace the X by a numerical value: 0, 1, 3, 7, 9 or 12 for correct designs. For values from 16 to 24 the tests are expected to fail, as the design will have internal errors.


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, or just checking coverage or all three).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── alu.sby
├── src
│   └── alu.vhd
└── src_tb
    └── alu.psl

3 directories, 4 files
