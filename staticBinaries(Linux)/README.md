# LLUMC-Publications - staticBinaries(Linux)
This folder includes all binaries that were used to benchmark LLUMC, CBMC, LLBMC. 
The binary of the tool clang version 3.7 had to be divided into 4 files using the command: "split -b 50M clang split_clang_".
When using the binaries one can simplay merge these files using: "cat split_clang_a* > clang".

Notice that the binaries of llbmc are only available under the llbmc-academic and llbmc-evaluation licence. 
The cbmc binary is taken from https://www.cprover.org/cbmc/.



 
