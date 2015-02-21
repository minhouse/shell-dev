#!/bin/bash
#===============================================================================
#
#          FILE: deadlock_search.sh
#
#         USAGE: ./deadlock_search.sh
#
#   DESCRIPTION: This shell script is to extract multiple lines by specifying starting# 								linenumber and end keyword
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: 
#  ORGANIZATION: 
#       CREATED: 2014/12/30
#      REVISION: 
#===============================================================================

#-------------------------------------------------------------------------------
# Variable Settings
#-------------------------------------------------------------------------------

#Please change the file name.the file has to be in the same directory.
file="hedb1_lmd0_18249.trc"

#Please change "word" for search condition.
line=`grep -n "user session for deadlock" $file |awk -F ':' '{print $1}'`

#-------------------------------------------------------------------------------
# Main Procedure
#-------------------------------------------------------------------------------

for i in $line
do
	#Please chage /word/ for end word search condition
	rnt=`sed -n "${i},/MERGE INTO/p" $file`
	echo -e "${rnt}/\n" >> deadlock.txt
	echo 
done
