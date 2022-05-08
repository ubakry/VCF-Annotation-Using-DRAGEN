#!/bin/bash

SCRIPT="DRAGEN Annotation Script"
AUTHOR="Copyright 2022 Usama Bakry (u.bakry@icloud.com)"

## Command line options
## -----------------------------------------------------------------------------
while getopts i:o: OPTION
do
case "${OPTION}"
in
# Input directory
i) INPUT=${OPTARG};;
# Output directory
o) OUTPUT=${OPTARG};;
esac
done
## -----------------------------------------------------------------------------

## Print user args
## -----------------------------------------------------------------------------                     
echo -e "[     INFO    ] Input Directory  : ${INPUT}"
echo -e "[     INFO    ] Output Directory : ${OUTPUT}"
## -----------------------------------------------------------------------------

## User confirmation
## -----------------------------------------------------------------------------
read -p "Continue (y/n)?" CHOICE
case "$CHOICE" in 
	y|Y ) 

main () {

## Print pipeline info
## -----------------------------------------------------------------------------                     
echo -e "[     INFO    ] ${SCRIPT}"
echo -e "[     INFO    ] ${AUTHOR}"
## -----------------------------------------------------------------------------  
echo -e "[     INFO    ] Input Directory  : ${INPUT}"
echo -e "[     INFO    ] Output Directory : ${OUTPUT}\n"
## -----------------------------------------------------------------------------

## Print start date/time
## -----------------------------------------------------------------------------                     
echo -e "[    START    ] $(date)\n"
## -----------------------------------------------------------------------------  

## Create output directory
## -----------------------------------------------------------------------------                     
echo -e "[   PROCESS   ] Creating output directory..."

# Check if output directory is exist
if [ -d "${OUTPUT}/" ] 
then
    echo -e "[    ERROR    ] The output directory already exists.\n"
    exit 0
else
    mkdir -p ${OUTPUT}/
fi

echo -e "[      OK     ] Output directory is ready on ${OUTPUT}/\n"
## ----------------------------------------------------------------------------- 

## Annotation using Nirvana on DRAGEN
## -----------------------------------------------------------------------------
time {
echo -e "[   PROCESS   ] Annotation..."

FILES=$(ls ${INPUT})
for FILE in $FILES; do
    PREFIX=$(basename "$FILE" | cut -d. -f1)
    
    S_DIR=${OUTPUT}/${PREFIX}/
    mkdir -p $S_DIR

    /opt/edico/share/nirvana/Nirvana -c /home/ecrrm/Data/Cache/GRCh38/Both -r /home/ecrrm/Data/References/Homo_sapiens.GRCh38.Nirvana.dat --sd /home/ecrrm/Data/SupplementaryAnnotation/GRCh38 -i ${INPUT}/$FILE -o ${S_DIR}/${PREFIX}

    dunzip ${S_DIR}/${PREFIX}.json.gz
done

echo -e "[      OK     ] Annotation is done.\n"
}
## -----------------------------------------------------------------------------

## Print end date/time
## -----------------------------------------------------------------------------                     
echo -e "[     END     ] $(date)\n"
## -----------------------------------------------------------------------------  

} ## End of main function
## -----------------------------------------------------------------------------                      

## Prepare output log file
## -----------------------------------------------------------------------------                     
LOG=$( { time main > "$(dirname "${OUTPUT}")"/output.log 2>&1; } 2>&1 )
echo -e "Duration:${LOG}" >> "$(dirname "${OUTPUT}")"/output.log 2>&1                    

exit 0

;;

	n|N ) echo -e "[      OK     ] Process stopped.";;
	* ) echo -e   "[     ERROR   ] invalid";;
esac