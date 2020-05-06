#!/bin/bash

SRAs=$(cat SRA_IDs.txt)

if [[ ! -e "$SRAs" ]]; then
	for SRA in $SRAs ; do
		mkdir -p $SRA
		done
fi




