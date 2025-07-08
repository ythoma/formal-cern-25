Timer Example
=============

This folder contains an example of formal verification of a simple timer.
To run the example with QuestaFormal, open questaFormal, and go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f timer.sby prove

or

sby --yosys "yosys -m ghdl" -f timer.sby bmc

or

sby --yosys "yosys -m ghdl" -f timer.sby cover


The script will compile the DUV, the assertions, and
formally verify that the properties hold (using prove, bmc, or just checking coverage).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── timer.sby
├── src_vhdl
│   └── timer.vhd
└── src_tb
    └── timer_assertions.psl


Interesting fact: with BMC, it goes up to the detph defined in the .sby file. For this case,
prove seems more efficient.