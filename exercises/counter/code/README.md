Formal Verification : Counter
=============================

This folder contains an example of formal verification of a counter.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f counter.sby

or

sby --yosys "yosys -m ghdl" -f counter.sby proveX

or

sby --yosys "yosys -m ghdl" -f counter.sby bmcX

or

sby --yosys "yosys -m ghdl" -f counter.sby cover

When running the proveX or bmcX, replace the X by a numerical value between 0 and 4. For 0
the tests are expected to succeed, and for 1 to 4 they should fail, as the design will have internal
errors.

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
