#!/bin/bash
# $ chmod a+rx my-script.sh

echo 'Start of Script'
	f=$1
	# manually set the output (output of the tool MinireachIC3) and the runlim (time and memory information) folders
	outputFolder="00-LLUMC-Output-Minireach-FALSE"
	runlimFolder="00-LLUMC-RunLim-Minireach-FALSE"
	echo 'file: ' $f
	e=${f##*/}
	g=${e%.*}
	echo 'just file: ' $g
	now=$(date)
	time="$(echo -e "${now}" | tr -d '[:space:]')"
	mkdir -p "${runlimFolder}"
	mkdir -p "${outputFolder}"
	folderName="$PWD/${runlimFolder}/${g}_${time}"
	mkdir ${folderName}
	cp $f ${folderName}/$g.c
	outputFile='runlim_'$g
	# copy all necessary binaries, scripts and header files into one folder
	cp llumc ${folderName}/llumc
	cp llbmc ${folderName}/llbmc
	cp assert.h ${folderName}/assert.h
	cp minireachIC3_QUIP0.dat ${folderName}/minireachIC3_QUIP0.dat
	cp 02_runToolchain-Minireach.sh ${folderName}/02_runToolchain-Minireach-a.sh
	
	#rum Benchmark in the created setting
	runlim --kill --output-file=${folderName}/${outputFile} --real-time-limit=600 ${folderName}/02_runToolchain-Minireach-a.sh ${folderName}/$g.c ${folderName} ${outputFolder}

	cp ${folderName}/${outputFile} ${runlimFolder}/$g
echo "Finished Script"
