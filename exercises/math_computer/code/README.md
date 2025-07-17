Formal Verification : Math computer
===================================

This folder contains an example of formal verification of a simple calculator.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f math_computer.sby

or

sby --yosys "yosys -m ghdl" -f math_computer.sby bmcX

or

sby --yosys "yosys -m ghdl" -f math_computer.sby proveX

or

sby --yosys "yosys -m ghdl" -f math_computer.sby coverX

Replace "X" by "d" for checking the datapath-control version, and by "p" for the
pipeline version.

The PSL assertions have been split into three files:

math_computer.psl is applied to both designs
math_computer_only_datapath.psl is only applied to the datapath-control version
math_computer_only_pipeline.psl is only applied to the pipeline version

The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, checking coverage or both).
