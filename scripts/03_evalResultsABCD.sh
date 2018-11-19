#!/bin/bash
# $ chmod a+rx my-script.sh

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

failsTempFile="fails-ABCD.tmp"
if [ -e ${failsTempFile} ]
then
  rm ${failsTempFile}
fi
correctTempFile="correct-ABCD-FALSE.tmp"
if [ -e ${correctTempFile} ]
then
  rm ${correctTempFile}
fi
listToUse="listToUse-ABCD.txt"
if [ -e ${listToUse} ]
then
  rm ${listToUse}
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
	
	statusFull=$(grep '\[runlim\] status' $f)
	#echo 'StatusFull: ' ${statusFull}
	if [ -z "${statusFull}" ] ; then
		result="No Error found"
	else
        	status=$(echo ${statusFull} | cut -f 2 -d ':' | tr -d ' ')
		result=${status}
	fi
	fileName=$f
	echo 'result: ' ${result}
	if [[ ${result} == "signal(6)" ]] ; then
		((signal++))
	else

		if [ "${name}" -eq "0" ] ; then
			if [[ ${result} == "ok" ]] ; then
				((correct++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${correctTempFile}
				echo "${fileName}" >> ${listToUse}
			else
				((wrong++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${failsTempFile}
				#if [[ ${result} == "outoftime" ]] ; then
			#		echo "${fileName}" >> ${listToUse}
				#fi
				#if [[ ${result} == "segmentationfault" ]] ; then
				#	echo "${fileName}" >> ${listToUse}
				#fi	
			fi
		fi
		if [ "${name}" -eq "1" ] ; then
			if [[ ${result} == "ok" ]] ; then
				((wrong++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${failsTempFile}
			else
				((correct++))
				echo "${fileName} , ${result}, ${real} , ${cpu}" >> ${correctTempFile}
				echo "${fileName}" >> ${listToUse}
			fi
		
		fi
	fi

	
done 
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





