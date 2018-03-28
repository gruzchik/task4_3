#!/bin/bash

# highlights color
Red='\e[0;31m'
Green='\e[0;32m'
Yellow='\e[0;33m'
NC='\e[0m'

BACKUP_DIRECTORY="/tmp/backups/"

if [ $# -ne 2 ]; then
	echo "Number of parameters for script is $# and it is not correct" 1>&2
	exit 1
fi

if [ ! -d ${BACKUP_DIRECTORY} ]; then
	
	echo -e "Directory ${BACKUP_DIRECTORY} does not exists. ${Yellow}Installation of directory..${NC}"
	mkdir -p ${BACKUP_DIRECTORY}
	## exit case(if directory is not exists)
	#echo "Directory ${BACKUP_DIRECTORY} does not exists. Please create it" 1>&2
	#exit 1
fi

BACKUP_NAME=$(echo $1 | sed s%/%-%g | cut -c 2- )
#echo ${BACKUP_NAME}

BACKUP_COUNT=$(ls ${BACKUP_DIRECTORY} | grep "tar.gz" | grep "^${BACKUP_NAME}_"|wc -l)
#echo ${BACKUP_COUNT}

if [ ${BACKUP_COUNT} -gt $2 ]; then
	echo -e "A lot of backups. it is ${Red} ${BACKUP_COUNT} ${NC} files"
	let REMBKP=${BACKUP_COUNT}-$2
	echo -e "number backups to delete:${Green} $REMBKP ${NC}"
	ls -1t ${BACKUP_DIRECTORY} | grep "tar.gz" | grep "^${BACKUP_NAME}_"| tail -n $REMBKP | while read line; do
		echo -e "${Yellow}  rm ${line} ${NC}"
		/bin/rm ${BACKUP_DIRECTORY}$line
	done
fi

echo "tar -czf ${BACKUP_DIRECTORY}${BACKUP_NAME}_$(date '+%d.%m.%Y_%T').tar.gz ${1}"
tar -czf ${BACKUP_DIRECTORY}${BACKUP_NAME}_$(date '+%d.%m.%Y_%T').tar.gz ${1}
if [ $? != 0 ]; then
	echo -e "${Red} Backup does not created complete.${NC} Please check"
else
	echo -e "${Green} Backup complete! ${NC}"
fi
