BPM Example
===========

This folder contains an example of formal verification of a CERN BPM.

To run the example with Symbiyosis, from the scripts folder, run the following commandd:

sby --yosys "yosys -m ghdl" -f bpm.sby 

To run the example with QuestaFormal, open questaFormal, and go into the
comp folder. Then run the following command:

qverify -do ../scripts/check.do

The script check.do will compile the DUV and the assertions, and
formally verify that the properties hold.



The structure of the folder is the following:

.
├── comp
├── README.md
├── scripts
│   ├── bpm.sby
│   └── check.do
├── src_duv
│   └── bpm.vhd
└── src_tb
    ├── bpm_pkg.vhd
    └── bpm.psl

The assertions are in PSL.
