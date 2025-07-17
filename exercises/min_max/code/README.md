Formal Verification : Min Max
=============================

This folder contains an example of formal verification of a linear display.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f min_max.sby

or

sby --yosys "yosys -m ghdl" -f min_max.sby proveX

or

sby --yosys "yosys -m ghdl" -f min_max.sby cover

When running the proveX, replace the X by a numerical value: 0, 1, 3, 7, 9 or 12 for correct designs. For values from 16 to 21 the tests are expected to fail, as the design will have internal errors.


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, checking coverage or both).

The structure of the folder is the following:

.
├── README.md
├── scripts
│   └── min_max.sby
├── src_duv
│   └── min_max.vhd
└── src_tb
    └── min_max.psl

3 directories, 4 files
