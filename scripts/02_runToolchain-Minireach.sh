
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
./clang -c -emit-llvm -m32 $file -o $f2.bc
./opt -inline -inline-threshold=9999999 $f4.bc -o $f4.bc
./llumc $f4.bc
./minireachIC3_QUIP0.dat -format=dimspec DimSpecFormula.cnf | tee ../../$3/$g
#echo End of ToolChain
