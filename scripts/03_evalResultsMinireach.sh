#!/bin/bash
# $ chmod a+rx my-script.sh

function rmIfExists() {
  for file in $*
  do
    if [ -e ${file} ]; then
      rm ${file}
    fi
  done
}

 

echo ' '
echo 'Start of Eval'
echo 'Eval directory: ' $1
files=$1\*
result=""
correct=0
wrong=0
name=-1
total=0
signal=0

failsTempFile="fails.tmp"
if [ -e ${failsTempFile} ]
then
  rm ${failsTempFile}
fi
correctTempFile="correct.tmp"
if [ -e ${correctTempFile} ]
then
  rm ${correctTempFile}
fi
listToUse="listToUse-Minireach.txt"
if [ -e ${listToUse} ]
then
  rm ${listToUse}
fi
scatterMinireach="scatterplot-Minireach.txt"
if [ -e ${scatterMinireach} ]
then
  rm ${scatterMinireach}
fi
scatterMinireachCPU="scatterplot-Minireach-CPU.txt"
if [ -e ${scatterMinireachCPU} ]
then
  rm ${scatterMinireachCPU}
fi

for f in ${files} ; do 
	((total++))
	echo '----------------------------------'
	 fileName=$(echo $f | grep '[A-Za-z_-]*false[A-Za-z_-]*true[A-Za-z_-]*')
        if [ -n "${fileName}" ] ; then
                name=0
                echo 'FALSE' $f
        else
                fileName=$(echo $f | grep '[A-Za-z_-]*true[A-Za-z_-]*false[A-Za-z_-]*')
                if [ -n "${fileName}" ];then
                        name=1
                        echo 'TRUE' $f
                else
                        fileName=$(echo $f | grep '..false..')
                        if [ -n "${fileName}" ]; then
                                name=0
                                echo 'FALSE' $f
                        else
				fileName=$(echo $f | grep '..true..')
                                name=1
                                echo 'TRUE' $f
                        fi
                fi
        fi

	timeReal=$(grep '\[runlim\] real:' $f)
	timeCPU=$(grep '\[runlim\] time:' $f)
	if [ -z "${timeReal}" ] ; then
		real="no time given"
	else
        	real=$(echo ${timeReal} | cut -f 2 -d ':' | tr -d ' ')
	fi
	if [ -z "${timeCPU}" ] ; then
		cpu="no time given"
	else
        	cpu=$(echo ${timeCPU} | cut -f 2 -d ':' | tr -d ' ')
	fi
	
	statusFull=$(grep 'UNSAT' $f)
	#echo 'StatusFull: ' ${statusFull}
	if [ -n "${statusFull}" ] ; then
		result="UNSAT"
	else
		statusFull=$(grep 'SAT' $f)
		if [ -n "${statusFull}" ]; then
        		result="SAT"
		else
			result="signal(6)"
		fi
	fi
	fileName=$f
	echo 'result: ' ${result}
	#echo 'name: ' ${name}
	#signal=$(grep 'signal' ${result})
	if [[ ${result} == "signal(6)" ]] ; then
		((signal++))
	else

		if [ "${name}" -eq "0" ] ; then
			if [[ ${result} == "SAT" ]] ; then
				((correct++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${correctTempFile}
				echo "${fileName}" >> ${listToUse}
				echo "${real}" >> ${scatterMinireach}
				echo "${cpu}" >> ${scatterMinireachCPU}
			else
				((wrong++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${failsTempFile}
			fi
		fi
		if [ "${name}" -eq "1" ] ; then
			if [[ ${result} == "SAT" ]] ; then
				((wrong++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${failsTempFile}
			else
				((correct++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${correctTempFile}
				echo "${fileName}" >> ${listToUse}
				echo "${real}" >> ${scatterMinireach}
				echo "${cpu}" >> ${scatterMinireachCPU}
			fi
		
		fi
	fi
done 
#cat ${scatterMinireachCPU}
#echo '++++++++++++++++++++++++++++++++++++++++'
#cat ${scatterMinireach}
echo '++++++++++++++++++++++++++++++++++++++++'
cat ${listToUse}
echo '++++++++++++++++++++++++++++++++++++++++'
cat ${correctTempFile}
echo '++++++++++++++++++++++++++++++++++++++++'
cat ${failsTempFile}
echo '++++++++++++++++++++++++++++++++++++++++'
echo 'total: ' ${total}
echo 'correct: ' ${correct}
echo 'wrong: ' ${wrong}
echo 'signal(6): ' ${signal}




