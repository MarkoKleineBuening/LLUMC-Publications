# LLUMC-Publications
Repository for static binaries, benachmarks, scripts, etc. for execution LLUMC and related approaches for the TACAS 2019. 
Every folder contains further information in a seperate README file.
Following the set up for the benchmarks as performed by the autors are described. The main  execution of the different tools are in the 02_* scripts.

0)	The benchmarks were performed on a Linux (Ubuntu) 64 bit system and are construced accordingly. 
0)	Clone the complete git repository

1)	Create folder and copy both the binaries and the scripts into the same folder.
2)	Run the 01_command-parallel-* scripts for the different tools you want to test. 

	Example for running LLUMC-Minireach 
	parallel -j 8 ./01_command-parallel-llumcApproach-Minireach.sh ::: <path-to-benchmarks>/* & 
	
3)	The results can be evaluated using the 03_* scipts, details are in the scripts folder

	Example for summarizing the results for LLUMC-Minireach	
	./03_evalResultsMinireach.sh 00-LLUMC-Output-Minireach-FALSE
	
4)	Creating file that can be read-in by gnuplot using the 07_ script
	
	Example, runlim times
	 ./07_createTimeTable.sh <folder with runlim results> <file created by 03_* of benchmarks with correct results> <name of output file you want>

This four steps can be performed for LLUMC-MinireachIC3, LLUMC-abcdSAT, LLBMC and CBMC. 

