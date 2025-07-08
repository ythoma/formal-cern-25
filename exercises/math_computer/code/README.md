Formal Verification : Math computer
===================================

This folder contains an example of formal verification of a simple calculator.
To run the example with SBY, go into the
scripts folder. Then run the following command:

sby --yosys "yosys -m ghdl" -f math_computer.sby

or

sby --yosys "yosys -m ghdl" -f math_computer.sby prove

or

sby --yosys "yosys -m ghdl" -f math_computer.sby cover


The script will compile the sequences, the assertions, and
formally verify that the properties hold (using prove, checking coverage or both).
