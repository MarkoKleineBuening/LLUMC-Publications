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
	mkdir -p Results-LLBMC-FALSE-NEW
	folderName="$PWD/Results-LLBMC-FALSE-NEW/${g}_${time}"
	echo 'folderName: ' ${folderName}
	mkdir ${folderName}
	cp $f ${folderName}/$g.c
	outputFile='runlim_'$g
	echo 'outputFile: '${outputFile}
		# e=${f##*/}; g=${e%.*}; echo 'filename1: ' $e ; echo 'filename2: ' $g
	#rmIfExists carj.json AIGtoCNF.txt Ausgabe.txt DimSpecFormula.cnf DimSpecFormulaPre.cnf NameToAIG.txt output_0.cnf output_1.cnf output_1.cnf output_2.cnf output_3.cnf
	cp llbmcBench2 ${folderName}/llbmcBench2
	cp 02_runLLBMCC.sh ${folderName}/02_runLLBMCC-a.sh
	cp assert.h ${folderName}/assert.h
	echo ${folderName}/${outputFile}

	runlim --kill --output-file=${folderName}/${outputFile} --real-time-limit=600 ${folderName}/02_runLLBMCC-a.sh ${folderName}/$g.c outputLLBMC-FALSE-NEW.txt

	mkdir -p 00-LLBMC-Results-FALSE-NEW; cp ${folderName}/${outputFile} 00-LLBMC-Results-FALSE-NEW/$g
	#rmIfExists carj.json AIGtoCNF.txt DimSpecFormulaPre.cnf NameToAIG.txt output_0.cnf output_1.cnf output_1.cnf output_2.cnf output_3.cnf
echo "Finished Script"
