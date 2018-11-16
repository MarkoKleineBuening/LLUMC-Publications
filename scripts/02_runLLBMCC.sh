#!/bin/bash

function check()
# takes two arguments: iter ($1, integer) and bounds_check ($2, boolean [0/1])
# returns: 10 (SAFE) or 20 (UNSAFE) or 30 (LOOP_BOUND) or 0 (UNKNOWN)
{
    iter=$1
    bounds_check=$2
    
    if [ $bounds_check -eq 1 ]
        then
	#echo 'eq1'
        result=`./llbmcBench2 ${output_file}.bc -ignore-missing-function-bodies --only-custom-assertions --error-label=ERROR --max-loop-iterations=$iter | tee out.txt`
    else
	#echo 'eq2'
        result=`./llbmcBench2 ${output_file}.bc --ignore-missing-function-bodies --only-custom-assertions --error-label=ERROR --max-loop-iterations=$iter --no-max-loop-iterations-checks | tee out.txt`
    fi

    if [[ $result =~ "Error occurs in basic block \"ERROR\"" ]]
        then
	#echo '10'
        return 10   # UNSAFE
    elif [[ $result =~ "No error detected." ]]
        then
	#echo '20'
        return 20   # SAFE (but only, if $bounds_check=1)
    elif [[ $result =~ "--max-loop-iterations" ]]
        then
	#echo '30'
        return 30   # loop bound reached
    else
	#echo '0'
        return 0    # UNKNOWN
    fi
}

# start of main program

outputLLBMC="$2"
#if [ -e ${outputLLBMC} ]
#then
  #rm ${outputCBMC}
#fi
echo $source_file
source_file=$1
output_file=${source_file%?}
output_file=${output_file%?}

if [ ! -f $source_file ]
    then
    echo "Cannot open input C file. Exiting."
    exit -1
fi

# max. number of loop iterations
iter=10

# compile C program to LLVM IR
~/software/bin/clang -c -emit-llvm -m32 $source_file -o ${output_file}.bc

# run LLBMC
# the strategy is as follows:
# for each loop bound l=0..
#   check without loop bounds check
#     safe    -> check with loop bounds check
#                   safe    -> return "SAFE"
#                   unsafe  -> [ NOT POSSIBLE ]
#                   bound   -> continue
#                   unknown -> return "UNKNOWN"
#     unsafe  -> return "UNSAFE"
#     bound   -> [ NOT POSSIBLE ]
#     unknown -> return "UNKNOWN"

while true
do
    # no loop bounds check first
    check $iter 0
    result=$?

    if [ $result -eq 10 ]   # UNSAFE
        then
        echo "UNSAFE"
		echo "${output_file}:UNSAFE" >> ${outputLLBMC}
        break
    elif [ $result -eq 20 ] # SAFE
        then
        # run LLBMC with loop bounds check
        check $iter 1
        result=$?
        if [ $result -eq 20 ]
            then echo "SAFE"
			echo "${output_file}:SAFE" >> ${outputLLBMC}
            break
        elif [ $result -eq 0 ]
            then echo "UNKNOWN"
			echo "${output_file}:UNKNOWN" >> ${outputLLBMC}
            break
        fi
        # else (i.e. loop bound reached) continue
    elif [ $result -eq 0 ]  # UNKNOWN
        then
        echo "UNKNOWN"
		echo "${output_file}:UNKNOWN" >> ${outputLLBMC}
        break
    fi

    # increase bound
    if [ $iter -lt 10 ]
    then
	#echo '10'
        iter=100
    elif [ $iter -lt 1000 ]
    then
	#echo '1000'
        iter=1000
    else
        echo "UNKNOWN"
		echo "${output_file}:UNKNOWN" >> ${outputLLBMC}
        break 
    fi
    printf "$iter.."
done

# clean up and exit
cat ${outputLLBMC}
#todo write result in file : BenchmarkName: Result
exit 0
