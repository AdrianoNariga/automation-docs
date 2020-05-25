#!/bin/bash
original_file_name=$1
acent_remove=$(echo $original_file_name | iconv -f UTF8 -t ASCII//TRANSLIT)
special_char_tr=$(echo $acent_remove | tr -s "[:punct:]" "_")
_dup_remove=$(echo $special_char_tr | tr " " "_" | sed 's/___/_/g' | sed 's/__/_/g')

remove_str=$(echo $_dup_remove | \
	sed -E 's/_BluRay|_BDrip|_Dublado|_WEB|_DUAL|_COMANDOTORRENTS|_WWW|_BLUDV|_x264|_HDChina|_Dual|_Audio|_TORRENTDOSFILMES|_COM|_LAPUMiA|_BRRip|_Audio|_Rip|_Thriller|_Terror//g'
)	


if [ -d "${original_file_name}" ]
then
	if [ "$2" == "-w" ]
	then
		mv "${original_file_name}" $(echo "$remove_str")
	else
		echo "$remove_str"
	fi
elif [ -f "${original_file_name}" ]
then
	n_total_char=$(echo ${#remove_str})
	menos_3=$(( $n_total_char - 3 ))
	multimedia_name=$(echo ${remove_str:0:$(( $menos_3 -1 ))})
	multimedia_extencion=$(echo ${remove_str:$menos_3})

	if [ "$2" == "-w" ]
	then
		mv "${original_file_name}" $(echo "$multimedia_name.$multimedia_extencion")
	else
		echo "$multimedia_name.$multimedia_extencion"
	fi
else
	echo "${original_file_name} - Nao eh arquivo e nem diretorio"
fi
