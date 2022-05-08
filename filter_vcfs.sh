#!/bin/bash

SCRIPT="Filter VCFs based on Quality and Depth Script "
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

## Filter VCFs based on Quality and Depth
## -----------------------------------------------------------------------------
time {
echo -e "[   PROCESS   ] Filter VCFs..."

FILES=$(ls ${INPUT} | grep ".vcf")
for FILE in $FILES; do
    PREFIX=$(basename "$FILE" | cut -d. -f1)

    time cat ${INPUT}/${PREFIX}.vcf | java -jar ~/snpEff/SnpSift.jar filter " ((QUAL >= 20) && (DP >= 20))" > ${OUTPUT}/${PREFIX}_filtered.vcf

done

echo -e "[      OK     ] Filteration is done.\n"
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
LOG=$( { time main > "$(dirname "${OUTPUT}")"/Filter.log 2>&1; } 2>&1 )
echo -e "Duration:${LOG}" >> "$(dirname "${OUTPUT}")"/Filter.log 2>&1                    

exit 0

;;

	n|N ) echo -e "[      OK     ] Process stopped.";;
	* ) echo -e   "[     ERROR   ] invalid";;
esac