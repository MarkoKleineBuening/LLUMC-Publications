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

 
#when usng the parallel command you have to delete the two for-loops and just write f=hardCodedPathToBenchmarks
echo ' '
echo 'Start of Script'

	f=$1
	echo 'file: ' $f
	e=${f##*/}
	g=${e%.*}
	echo 'just file: ' $g
	now=$(date)
	time="$(echo -e "${now}" | tr -d '[:space:]')"
	mkdir -p Results-Minireach-TRUE-eca
	mkdir -p 00-LLUMC-Output-Minireach-TRUE-eca
	folderName="$PWD/Results-Minireach-TRUE-eca/${g}_${time}"
	echo 'folderName: ' ${folderName}
	mkdir ${folderName}
	cp $f ${folderName}/$g.c
	outputFile='runlim_'$g
	echo 'outputFile: '${outputFile}
		# e=${f##*/}; g=${e%.*}; echo 'filename1: ' $e ; echo 'filename2: ' $g
	#rmIfExists carj.json AIGtoCNF.txt Ausgabe.txt DimSpecFormula.cnf DimSpecFormulaPre.cnf NameToAIG.txt output_0.cnf output_1.cnf output_1.cnf output_2.cnf output_3.cnf
	cp llumc ${folderName}/llumc
	cp llbmc ${folderName}/llbmc
	cp assert.h ${folderName}/assert.h
	cp minireachIC3_QUIP0.dat ${folderName}/minireachIC3_QUIP0.dat
	cp 02_runToolchain-Minireach.sh ${folderName}/02_runToolchain-Minireach-a.sh
	echo '${folderName}/02_runToolchain-Minireach-a.sh'
	runlim --kill --output-file=${folderName}/${outputFile} --real-time-limit=600 ${folderName}/02_runToolchain-Minireach-a.sh ${folderName}/$g.c ${folderName}

	mkdir -p 00-LLUMC-Results-Minireach-TRUE-eca; cp ${folderName}/${outputFile} 00-LLUMC-Results-Minireach-TRUE-eca/$g
	#rmIfExists carj.json AIGtoCNF.txt DimSpecFormulaPre.cnf NameToAIG.txt output_0.cnf output_1.cnf output_1.cnf output_2.cnf output_3.cnf
echo "Finished Script"
