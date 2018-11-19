#!/bin/bash
# $ chmod a+rx my-script.sh
 
echo ' '
echo 'Start of Script'

	f=$1
	echo 'file: ' $f
	e=${f##*/}
	g=${e%.*}
	echo 'just file: ' $g
	now=$(date)
	time="$(echo -e "${now}" | tr -d '[:space:]')"
	mkdir -p Results-CBMC-TRUE-NEW
	folderName="$PWD/Results-CBMC-TRUE-NEW/${g}_${time}"
	echo 'folderName: ' ${folderName}
	mkdir ${folderName}
	cp $f ${folderName}/$g.c
	outputFile='runlim_'$g
	echo 'outputFile: '${outputFile}
		# e=${f##*/}; g=${e%.*}; echo 'filename1: ' $e ; echo 'filename2: ' $g
	#rmIfExists carj.json AIGtoCNF.txt Ausgabe.txt DimSpecFormula.cnf DimSpecFormulaPre.cnf NameToAIG.txt output_0.cnf output_1.cnf output_1.cnf output_2.cnf output_3.cnf
	cp cbmc ${folderName}/cbmc
	cp assert.h ${folderName}/assert.h
	cp 02_runCBMCC.sh ${folderName}/02_runCBMCC-a.sh
	echo '${folderName}'
	runlim --kill --output-file=${folderName}/${outputFile} --real-time-limit=600 ${folderName}/02_runCBMCC-a.sh ${folderName}/$g.c outputCBMC-TRUE-NEW.txt

	mkdir -p 00-CBMC-Results-TRUE-NEW; cp ${folderName}/${outputFile} 00-CBMC-Results-TRUE-NEW/$g

	echo "Finished Script"
