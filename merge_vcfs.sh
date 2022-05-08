#!/bin/bash

SCRIPT="Merge VCFs Script"
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

## Merge VCFs using BCFTools
## -----------------------------------------------------------------------------
time {
echo -e "[   PROCESS   ] Merge VCFs..."

FILES=$(ls ${INPUT} | grep ".vcf")
for FILE in $FILES; do
    PREFIX=$(basename "$FILE" | cut -d. -f1)

    bgzip -c ${INPUT}/${PREFIX}.vcf > ${OUTPUT}/${PREFIX}_bgzip.vcf.gz
    tabix -p vcf ${OUTPUT}/${PREFIX}_bgzip.vcf.gz

done

bcftools merge ${OUTPUT}/*_bgzip.vcf.gz > ${OUTPUT}/all.vcf

echo -e "[      OK     ] Merging is done.\n"
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