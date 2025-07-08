Formal Verification : Axi4lite slave
====================================

This folder contains an example of formal verification of an axi4-lite slave.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f axi4lite_slave.sby

or

sby --yosys "yosys -m ghdl" -f axi4lite_slave.sby prove

or

sby --yosys "yosys -m ghdl" -f axi4lite_slave.sby bmc

or

sby --yosys "yosys -m ghdl" -f axi4lite_slave.sby cover


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, bmc, or just checking coverage or all three).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── axi4lite_slave.sby
├── src_duv
│   └── axi4lite_slave.vhd
└── src_tb
    └── axi4lite_slave.psl

3 directories, 4 files
