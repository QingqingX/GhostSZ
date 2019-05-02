# GhostSZ
GhostSZ lossy compression for Xilinx platform
2019, CAAD Lab, Boston University, MA

The original design and implementation for Altera FPGAs is described in our FCCM'19 paper: "GhostSZ: A Transparent FPGA-Accelerated Lossy Compression Framework"



Four directories:
1. system:
  contains top file sz_wrapper.v that is wrapped as sz_wrapper kernel; can be used in hls environment
  contains sz_merger.v, which merges the output from the first few stages of ghostsz and connects to gzip hardware 
2. sz_first_steps:
  the main design files of ghostsz
  the top module is sz_inner.v
3. gzip:
  rtl design of gzip generated from Xilinx HLS with the modification to the input port (https://github.com/Xilinx/Applications/tree/master/GZip)
4. testbenches:
  testbenches to the main modules of sz_first_steps
