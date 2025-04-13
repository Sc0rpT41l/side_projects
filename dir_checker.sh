#! /bin/bash

for every file in spec dir true; do
	1) checksum of every file in specified dir
	2) put checksum with corresponding filename in temp file
	3) compare last checksum of files with newer checksum of file 
	4) make backup of this new version of file and log this in log file with timestamp
	5) if file doesn't already have a checksum in temp file make a new one and backup this file


done
