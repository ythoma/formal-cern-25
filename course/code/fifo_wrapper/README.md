FIFO Example
============

This folder contains an example of formal verification of a simple FIFO.
To run the example with SymbiYosis, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f fifo.sby

or

sby --yosys "yosys -m ghdl" -f fifo.sby prove

or

sby --yosys "yosys -m ghdl" -f fifo.sby bmc

or

sby --yosys "yosys -m ghdl" -f fifo.sby cover


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, bmc, or just checking coverage or all three).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── fifo.sby
├── src_tb
│   ├── fifo_wrapper.vhd
│   └── fifo.psl
└── src_vhdl
    └── fifo.vhd
