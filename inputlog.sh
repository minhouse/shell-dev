#!/bin/bash

inputlog{

	local check=0
	local flag=1
	local i=$_[0]
	declare -a data_line
	data_line=()
	
	MAINDIR=/home/scripts
	agent_group_name=${agent_group_name}-faild.out

	if [ -e "$MAINDIR/Faild_Attempts/$agent_group_name-faild.out" ];then
		$flag=0

		if [ ! -s "$MAINDIR/Faild_Attempts/$agent_group_name-faild.out" ];then

			$flag=1

		fi
		
	fi


}
