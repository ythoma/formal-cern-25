Formal Verification : Counter
=============================

This folder contains an example of formal verification of a counter.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f counter.sby

or

sby --yosys "yosys -m ghdl" -f counter.sby prove

or

sby --yosys "yosys -m ghdl" -f counter.sby bmc

or

sby --yosys "yosys -m ghdl" -f counter.sby cover


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, bmc, or just checking coverage or all three).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── counter.sby
├── src_duv
│   └── counter.vhd
└── src_tb
    └── counter.psl

3 directories, 4 files
