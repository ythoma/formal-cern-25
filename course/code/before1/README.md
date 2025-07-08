Formal Verification Example
===========================

This folder contains an example of formal verification.
To run the example with SymbiYosis, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f run.sby

or

sby --yosys "yosys -m ghdl" -f run.sby prove

or

sby --yosys "yosys -m ghdl" -f run.sby bmc

or

sby --yosys "yosys -m ghdl" -f run.sby cover


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, bmc, or just checking coverage or all three).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── run.sby
└── src_vhdl
    ├── psl_sequence.vhd
    └── sequencer.vhd

3 directories, 4 files
