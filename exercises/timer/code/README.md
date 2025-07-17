Timer Example
=============

This folder contains an example of formal verification of a timer.
To run the example with SBY, go into the
scripts folder. Then run the following command:


sby --yosys "yosys -m ghdl" -f timer.sby

or

sby --yosys "yosys -m ghdl" -f timer.sby proveX

or

sby --yosys "yosys -m ghdl" -f timer.sby bmcX

or

sby --yosys "yosys -m ghdl" -f timer.sby cover


When running the proveX or bmcX, replace the X by a numerical value between 0 and 5. For 0
the tests are expected to succeed, and for 1 to 5 they should fail, as the design will have internal
errors.

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
    └── timer.psl


Interesting fact: with BMC, it goes up to the depth defined in the .sby file. For this case,
prove seems more efficient.

