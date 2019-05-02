# GhostSZ
GhostSZ lossy compression for Xilinx platform
2019, CAAD Lab, Boston University, MA

GhostSZ is a lossy compression framework targetting at HPC floating-point data; it is a hardware design based on SZ compressor (https://collab.cels.anl.gov/display/ESR/SZ). The original design and implementation for Altera FPGAs is described in our FCCM'19 paper: "GhostSZ: A Transparent FPGA-Accelerated Lossy Compression Framework"



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
  
  
Design： 

We describe the major steps of the GhostSZ FPGA framework:
1. Linearization: moves the to-be-compressed data to the FPGA designs based on the data location in memory. With the partitioning or blocking methods enabled, GhostSZ linearizes data in parallel to multiple pipelines by concatenating the read data from several blocks and sending them to different hardware pipelines.
2. Curve-fitting: After the to-be-compressed data arrives at the hardware, it first goes through the curve-fitting pipeline, which tries to predict the original data with 3 fitting models. If successful, the output is a 2-bit encoding. If the prediction cannot meet the error bound, then information about the current data, e.g. the error, gets passed to the next step. 
3. Error-bound Quantization: takes the error calculated from the previous stage and calculates the quantization code as the output. If the error cannot be quantized, then the (all-zero) quantization code and the original data value are stored.   
4. Gzip: hardware (IP) losslessly compresses all data. 
