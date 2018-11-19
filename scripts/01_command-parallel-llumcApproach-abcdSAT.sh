#!/bin/bash
# $ chmod a+rx my-script.sh

echo 'Start of Script'
	f=$1
	# manually set the output (output of the tool ABCD) and the runlim (time and memory information) folders
	#outputFolder="00-LLUMC-Output-ABCD-FALSE"
	runlimFolder="00-LLUMC-RunLim-ABCD-FALSE"
	echo 'file: ' $f
	e=${f##*/}
	g=${e%.*}
	echo 'just file: ' $g
	now=$(date)
	time="$(echo -e "${now}" | tr -d '[:space:]')"
	mkdir -p "${runlimFolder}"
	#mkdir -p "${outputFolder}"
	folderName="$PWD/${runlimFolder}/${g}_${time}"
	mkdir ${folderName}
	cp $f ${folderName}/$g.c
	outputFile='runlim_'$g
	# copy all necessary binaries, scripts and header files into one folder
	cp llumc ${folderName}/llumc
	cp llbmc ${folderName}/llbmc
	cp assert.h ${folderName}/assert.h
	cp incplan-abcdsat_i17 ${folderName}/incplan-abcdsat_i17
	cp 02_runToolchain-ABCD.sh ${folderName}/02_runToolchain-ABCD-a.sh
	
	#rum Benchmark in the created setting
	runlim --kill --output-file=${folderName}/${outputFile} --real-time-limit=600 ${folderName}/02_runToolchain-ABCD-a.sh ${folderName}/$g.c ${folderName}

	cp ${folderName}/${outputFile} ${runlimFolder}/$g
echo "Finished Script"
