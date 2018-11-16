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
echo 'OUTPUT ' $1
echo 'RUNLIM' $2
files=$1\*
runlim=$2
correctNr=0
name=-1
total=0

correct="$2"
if [ -e ${correct} ]
then
  rm ${correct}
fi
while read p; do
	echo "------------------------------------"
	((total++))
	 fileName=$(echo $p | grep '[A-Za-z_-]*false[A-Za-z_-]*true[A-Za-z_-\ ]*')
        if [ -z "${fileName}" ] ; then
                fileName=$(echo $p | grep '..true..')
                if [ -z "${fileName}" ] ; then
                        fileName=$(echo $p | grep '..false..')
                        echo 'fileName: FALSE ' ${fileName}
                        name=0
                else
                        fileName=$(echo $p | grep '..true..')
                        echo 'fileName: TRUE' ${fileName}
                        name=1
                fi
        else
                echo 'fileName: FALSE ' ${fileName}
                name=0
        fi
	res=${p//*:}
	e=${p##*/}
	g=${e%:*}
	echo "NAME: $g"
	echo "${res}==${name}"
	if [ "${res}" == "UNKNOWN" ]; then
		echo 'UN'
	else
		if [ "${res}" == "UNSAFE" ]; then
			if [ ${name} -eq  0 ]; then
				echo 'CORRECT'
				echo "$g" >> ${correct}
				((correctNr++))
			else
				echo 'UNCORRECT'
			fi
		elif [ "${res}" == "SAFE" ]; then
			if [ ${name} -eq 1 ]; then
				echo 'CORRECT'
				echo "$g" >> ${correct}
				((correctNr++))
			else
				echo 'UNCORRECT'
			fi
		fi
	fi
done <$1
echo '++++++++++++++++++++++++++++++++++++++++'
#cat ${listToUse}
echo '++++++++++++++++++++++++++++++++++++++++'
#cat ${correctTempFile}
echo '++++++++++++++++++++++++++++++++++++++++'
#cat ${failsTempFile}
echo '++++++++++++++++++++++++++++++++++++++++'
echo 'total: ' ${total}
echo 'correctNr: ' ${correctNr}
