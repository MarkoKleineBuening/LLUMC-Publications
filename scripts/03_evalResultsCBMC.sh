#!/bin/bash
# $ chmod a+rx my-script.sh

echo ' '
echo 'Start of Eval'
echo 'OUTPUT ' $1
echo 'correct file output' $2
file=$1
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
			#continue
                else
                        fileName=$(echo $p | grep '..true..')
                        echo 'fileName: TRUE' ${fileName}
                        name=1
			
                fi
        else
                echo 'fileName: FALSE ' ${fileName}
                name=0
		#continue
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
done <${file}
cat ${correct}
echo '++++++++++++++++++++++++++++++++++++++++'
echo 'total: ' ${total}
echo 'correctNr: ' ${correctNr}
