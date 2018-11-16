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
echo 'Result directory: ' $1
echo 'Correct File: ' $2
echo 'Output File: ' $3
fileResult=$1\*
correctFile=$2\*
outputFile=$3
correct=0
wrong=0

plotMinireach="${outputFile}"
if [ -e ${plotMinireach} ]
then
  rm ${plotMinireach}
fi
plotMinireachCpu="${outputFile}.cpu"
if [ -e ${plotMinireachCpu} ]
then
  rm ${plotMinireachCpu}
fi

for f in ${fileResult} ; do 
	((total++))
	e=${f##*/}
	g=${e%.*}
	#echo '----------------------------------'
	
	timeReal=$(grep '\[runlim\] real:' $f)
	timeCPU=$(grep '\[runlim\] time:' $f)
	if [ -z "${timeReal}" ] ; then
		real=""
	else
        real=$(echo ${timeReal} | cut -f 2 -d ':' | tr -d ' ')
	fi
	if [ -z "${timeCPU}" ] ; then
		cpu=""
	else
        cpu=$(echo ${timeCPU} | cut -f 2 -d ':' | tr -d ' ')
	fi
	
	statusFull=$(grep $g ${correctFile})
	if [ -n "${statusFull}" ] ; then
		echo "$g ${real::-7}" >> ${plotMinireach}
		echo "$g ${cpu::-7}" >> ${plotMinireachCpu}
		((correct++))
	fi
done 
echo '++++++++++++++++++++++++++++++++++++++++'
cat ${plotMinireach}
echo '++++++++++++++++++++++++++++++++++++++++'
cat ${plotMinireachCpu}
echo '++++++++++++++++++++++++++++++++++++++++'
echo 'total: ' ${total}
echo 'correct: ' ${correct}




