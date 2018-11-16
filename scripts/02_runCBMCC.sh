#!/bin/bash

function check()
# takes two arguments: iter ($1, integer) and bounds_check ($2, boolean [0/1])
# returns: 10 (SAFE) or 20 (UNSAFE) or 30 (LOOP_BOUND) or 0 (UNKNOWN)
{
#cbmc t6.c --function foo --unwind 100  --unwinding-assertions
    iter=$1

        #echo "result=./cbmc ${output_file}.c --32 --error-label ERROR --no-assertions --unwinding-assertions --unwind $iter | tee out.txt"
	result=`./cbmc ${output_file}.c --32 --error-label ERROR --no-assertions --unwinding-assertions --unwind $iter | tee out.txt`
	#todo what to grep
	tmp=$(echo ${result} | grep 'unwinding assertion loop [0-9]*: FAILURE')
	#echo ${tmp}
    if [[ $result =~ "error label ERROR: FAILURE" ]]
        then
	echo '10'
        return 10   # UNSAFE
    elif [[ $result =~ "VERIFICATION SUCCESSFUL" ]]
        then
	echo '20'
        return 20   # SAFE (but only, if $bounds_check=1)
    elif [[ $result =~ 'unwinding assertion loop .* FAILURE' ]]
        then
	echo '30'
        return 30   # loop bound reached
    elif [ -n "${tmp}" ]
    	then 
	echo '30_2'
	return 30 # loop bound reached
    else
	echo '0'
        return 0    # UNKNOWN
    fi
}

# start of main program

outputCBMC="$2"
#if [ -e ${outputCBMC} ]
#then
  #rm ${outputCBMC}
#fi


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

# run CBMC
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
    check $iter
    result=$?

    if [ $result -eq 10 ]   # UNSAFE
        then
        echo "UNSAFE"
		echo "${output_file}:UNSAFE" >> ${outputCBMC}
        break
    elif [ $result -eq 20 ] # SAFE
        then
        # run LLBMC with loop bounds check
        check $iter
        result=$?
        if [ $result -eq 20 ]
            then echo "SAFE"
			echo "${output_file}:SAFE" >> ${outputCBMC}
            break
        elif [ $result -eq 0 ]
            then echo "UNKNOWN"
			echo "${output_file}:UNKNOWN" >> ${outputCBMC}
            break
        fi
        # else (i.e. loop bound reached) continue
    elif [ $result -eq 0 ]  # UNKNOWN
        then
        echo "UNKNOWN"
		echo "${output_file}:UNKNOWN" >> ${outputCBMC}
        break
    fi

    # increase bound
    if [ $iter -lt 10 ]
    then
        iter=10
    elif [ $iter -lt 1000 ]
    then
        iter=1000
    else
        echo "UNKNOWN"
		echo "${output_file}:UNKNOWN" >> ${outputCBMC}
        break 
    fi
    printf "$iter.."
done

# clean up and exit
#todo write result into a file: Benchmarksname: result 
cat ${outputCBMC}
#write 03 eval, from Benchmark grep result and then grep if it should be false or true
exit 0
