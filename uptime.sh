#!/bin/bash

cmd='date'
ct=1

while [ $ct -lt 11 ]
	do
		$cmd	
		sleep 1
		ct=`expr $ct + 1`
	done
