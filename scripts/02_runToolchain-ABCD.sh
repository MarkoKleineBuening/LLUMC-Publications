#!/bin/sh
# $ chmod a+rx my-script.sh
#echo Start Toolchain
file=$1
folder=$2
cd $folder
f2=${file%?}
f2=${f2%?}
f3='BM'
f4=$f2$f3
./clang -c -emit-llvm -m32 $file -o $f2.bc
./llbmc $f2.bc -stacktrace -dont-unroll-loops -bitcodeDump -bitcodeFile=$f4.bc
./opt -inline -inline-threshold=9999999 $f4.bc -o $f4.bc
./llumc $f4.bc
./incplan-abcdsat_i17 DimSpecFormula.cnf
#echo End of ToolChain
