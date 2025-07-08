Formal Verification : ALU
=========================

This folder contains an example of formal verification of an alu.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f alu.sby

or

sby --yosys "yosys -m ghdl" -f alu.sby prove

or

sby --yosys "yosys -m ghdl" -f alu.sby cover


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
