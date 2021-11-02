
__Architecture Overview__
![Architecture Block Diagram](https://github.com/ARamachandran2000/universal-hw/blob/main/posit_to_fp_conversion/Register%20File.png)


__Waveform Output__
![Waveform](https://github.com/ARamachandran2000/universal-hw/blob/main/posit_to_fp_conversion/Waveform%20of%20Posit%20to%20FP.png)




This folder contains a preliminary version of a POSIT ALU.

Functionality Present : 

1. A register file with 2 reads and 1 write port that can store posit of any configuration.
2. A completely parametrised posit to IEEE single precision floating point conversion.
3. An integer to 16 bit es=0 posit convertor. The es=0 config allows the conversion to be realised with negligible delay.


Folders : 

__src -> Contains the design modules as follows :__

top_level_integration.v -> A top level wrapper that integrates the register file and converter.
data_extract.v, Posit_to_FP.v,lod_master.v,lod_sub.v,lzd_master.v,lzd_sub.v,register_reader_interface_module.v -> Implements the posit to floating point conversion
regfile.v -> Implementation of a triple ported register file.

__Testbench -> Containes the testbench and waveform output__ 

