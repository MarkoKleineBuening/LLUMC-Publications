
#!/bin/sh
# $ chmod a+rx my-script.sh
#echo Start Toolchain
echo $1
echo $2
file=$1
folder=$2
cd $2
e=${file##*/}
g=${e%.*}
#echo 'g: ' $g
f2=${file%?}
f2=${f2%?}
f3='BM'
f4=$f2$f3
#echo $f2
#echo $f4
~/software/bin/clang -c -emit-llvm -m32 $file -o $f2.bc
./llbmc $f2.bc -stacktrace -dont-unroll-loops -bitcodeDump -bitcodeFile=$f4.bc
~/software/bin/opt -inline -inline-threshold=9999999 $f4.bc -o $f4.bc
# additional optimaziation pass could be: -simplifycfg or opt -mem2reg -instnamer -inline -inline-threshold=9999999 $f2.bc -o $f4.bc
./llumc $f4.bc
./minireachIC3_QUIP0.dat -format=dimspec DimSpecFormula.cnf | tee ../../00-LLUMC-Output-Minireach-TRUE-eca/$g
#./incplan-abcdsat_i17 DimSpecFormula.cnf
#echo End of ToolChain
