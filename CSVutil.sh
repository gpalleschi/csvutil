#!/bin/bash


function help()
{
echo '###   ____ ______     __     _   _ _       _'
echo '###  / ___/ ___\ \   / /   _| |_(_) |  ___| |__'
echo '### | |   \___ \\ \ / / | | | __| | | / __|  _ \'
echo '### | |___ ___) |\ V /| |_| | |_| | |_\__ \ | | |'
echo '###  \____|____/  \_/  \__,_|\__|_|_(_)___/_| |_|'
echo '###'
echo '### CSVutil.sh - GNU General Public License v3.0'
echo '### Version: 1.2, date: 25 Mar 2021'
echo '###'
echo '### Author : Giovanni Palleschi'
echo '###'
echo '### CSVutil.sh is a bash utility script to manage csv files : extract, remove, change separator, filter, '
echo '### all results will be generated in stdout or on file.'
echo '###'
echo '### CSVutil.sh <CSV File Name> [options]'
echo '###'
echo '### Options are : '
echo '###'
echo '###           -h for display this help'
echo '###           -s<separator> to set csv separator {default is ;}'
echo '###           -e for extract using -e1,4,8-11 [ extract columns numbered 1 4 and from 8 to 11 and print result in stdout] {numbering start from 1}'
echo '###           -r for remove using -r3,8 [ remove columns numbered 1 4 8 and print result in stdout] {numbering start from 1}'
echo '###           -d debug mode {this option will be inserted before others}'
echo '###           -c<new separator> change separator'
echo '###           -f<column number>:<regexp to filter> {you can specify more than one filter option, '
echo '###                                                 all filter are relationated each other in and condition.}'
echo '###           -o<output filename> for generate output in a file instead of stdout'
echo '###           -ff<filtered record filename> for generate in a file separated filtered records'
echo '###           -t indicate that it''s present first line with column titles'
echo '###           -v<separator> to show records a field for row you have to specify or not a separator for fields printed {default values is ;}'
echo '###'
echo '### Examples of executions :'
echo '###'
echo '###  CSVutil.sh filetest.csv -e1,3,6-8 -c,                  [This execution extract from file filetest.csv columns 1,3 and from 6 to 8 and replace '
echo '###                                                          separator from ; to , and generate output in stdout].'
echo '###'
echo '###  CSVutil.sh filetest.csv -r4,7 -o./filetestRemoved.csv  [This execution remove from file filetest.csv column 4 and 7 and generate '
echo '###                                                          output on file filetestRemoved.csv].'
echo '###'
echo '###  CSVutil.sh filetest.csv -f3:^Oct -ff./fileFiltered.csv [This execution filter from filetest.csv all record where in column 3 start with Oct and generate '
echo '###                                                          a new file with record filtered and record not filtered are printed in stdout].'
}

function clear_file
{
    if [ -f "$1" ]; then rm "$1"; fi
}

function vprint
{
  echo $1
}

function deb_msg
{
   if [[ $FDEBUG -eq 1 ]] ; then
      echo '[+] DEBUG:' $1
   fi
}

# Function to print error message
function err_msg
{
   echo
   echo '[-] ERROR:' $1
   echo
   exit 1
}

# Default Values
CSV_SEPARATOR=";"
NEW_SEPARATOR=";"
CSV_FILE=$1
REGEX_DIGITS="^[0-9]+$"
REMOVEVALUE="#*#ReMoVe*#*"
FDEBUG=0
FLAGE=0
FLAGR=0
FLAGF=0
FLAGO=0
FILEO=""
FLAGFF=0
FILEFF=""
fRules=()
FLAGCS=0
FLAGT=0
FLAGV=0
SEPV=";"

# Loop over arguments
for var in "$@"
do
   if [[ $var == -h ]]; then
      help
      exit 0
   elif [[ ${var:0:2} == -e ]] || [[ ${var:0:2} == -r ]] ; then
      if [[ ${var:0:2} == -e ]] ; then
         if [[ $FLAGR -eq 1 ]]; then
            err_msg 'Specified -e option with -r !'
         fi
         FLAGE=1
      fi
      if [[ ${var:0:2} == -r ]] ; then
         if [[ $FLAGE -eq 1 ]]; then
            err_msg 'Specified -r option with -e !'
         fi
         FLAGR=1
      fi
      PARAMS="${var:2}"
      IFS=':' read -r -a arrayV <<< "$PARAMS"

      if [ "${#arrayV[@]}" -eq 0 ]; then
         err_msg 'No values for -e option !'
      fi

      erArray=()
      # Loop to check values for -e option
      for val in "${arrayV[@]}"
      do
         if ! [[ $val =~ $REGEX_DIGITS ]] ; then
            # Check if is a range
            IFS='-' read -r -a arrayR <<< "$val"
            if [ ! "${#arrayR[@]}" -eq 2 ]; then
               err_msg 'Value <'$val'> in '${var:0:2}' option, range with more or 2 elements !'
            else   
                if [[ ! ${arrayR[0]} =~ $REGEX_DIGITS ]] || [[ ! ${arrayR[1]} =~ $REGEX_DIGITS ]] ; then
                   err_msg 'Value <'$val'> in '${var:0:2}' option, range not numeric !'
                else
                   if [ ${arrayR[0]} -gt ${arrayR[1]} ] ; then
                      err_msg 'Value <'$val'> in '${var:0:2}' option, value from greater than value to !'
                   fi
                   if [ ${arrayR[0]} -eq ${arrayR[1]} ] ; then
                      err_msg 'Value <'$val'> in '${var:0:2}' option, value from equal to value to !'
                   fi
                   if [ ${arrayR[0]} -eq 0 ] ; then
                      err_msg 'Value <'$val'> in '${var:0:2}' option, value from equal to 0 {Values start from 1} !'
                   fi
                   if [ ${arrayR[1]} -eq 0 ] ; then
                      err_msg 'Value <'$val'> in '${var:0:2}' option, value to equal to 0 {Values start from 1} !'
                   fi
                   for rangeValue in $(seq ${arrayR[0]} ${arrayR[1]}); 
                   do 
                     erArray+=($rangeValue)
                   done 
                fi
            fi
         else
            if [ $val -eq 0 ]; then
               err_msg 'Value <'$val'> in '${var:0:2}' option, equal to 0 {Values start from 1} !'
            fi
            erArray+=($val)
         fi
      done

      deb_msg 'Number of elements splitter for '${var:0:2}' option are '${#erArray[@]}'.'

   elif [[ ${var:0:2} == -d ]]; then     
      FDEBUG=1
   elif [[ ${var:0:2} == -t ]]; then     
      FLAGT=1
   elif [[ ${var:0:2} == -v ]]; then     
      FLAGV=1
      if [ ${var:2} ]; then
         SEPV="${var:2}"
      fi
   elif [[ ${var:0:2} == -s ]]; then     
      CSV_SEPARATOR="${var:2}"
   elif [[ ${var:0:2} == -c ]]; then     
      NEW_SEPARATOR="${var:2}"
      FLAGCS=1
   elif [[ ${var:0:2} == -o ]]; then     
      FLAGO=1
      FILEO="${var:2}"
      clear_file $FILEO
   elif [[ ${var:0:3} == -ff ]]; then     
      FLAGFF=1
      FILEFF="${var:3}"
      clear_file $FILEFF
   elif [[ ${var:0:2} == -f ]]; then     
      FLAGF=1
      PARAMS="${var:2}"
      IFS=':' read -r -a arrayF <<< "$PARAMS"

      if [ "${#arrayF[@]}" -eq 0 ]; then
         err_msg 'No values for -f option !'
      fi

      if [ ! "${#arrayF[@]}" -eq 2 ]; then
         err_msg '-f option <'$PARAMS'> accept two parameters <Column Number>:<Regular Expression to filter> !'
      fi

      if ! [[ ${arrayF[0]} =~ $REGEX_DIGITS ]] ; then
         err_msg ' For -f option <'$PARAMS'>, first parameter is not a number !'
      fi
      fRules+=($PARAMS)
   fi
done     

# Check over Parameters
if [ "$#" -eq 0 ]; then
  help
  exit 0
fi

if [ ! -f "$CSV_FILE" ]; then
    err_msg 'File \”$CSV_FILE\” not found !'
fi


# ----------- START HERE -----------
numRec=0
while read -r LINE; do
        LINE_TO_PRINT=""
        numRec=$((numRec+1))
        if [[ $FLAGT -eq 1 ]] && [[ $numRec -eq 1 ]]; then
           IFS=$CSV_SEPARATOR read -r -a TITLEFIELDS <<< "$LINE"
           continue
        else   
           IFS=$CSV_SEPARATOR read -r -a CSVFIELDS <<< "$LINE"
        fi
# ---------- VISION -----------
        if [ $FLAGV -eq 1 ]; then
           vprint '-------------------------------------------------------------------------------------------------------'
           vprint 'Record Number : '$numRec
           numCol=0
           for CSVFIELD in "${CSVFIELDS[@]}"
           do
             indA=$numCol 
             numCol=$((numCol+1))
             if [ $FLAGT -eq 1 ]; then
                vprint $numCol$SEPV${TITLEFIELDS[$indA]}$SEPV$CSVFIELD  
             else
                vprint $numCol$SEPV$CSVFIELD
             fi
           done
        fi
# ---------- FILTER -----------
        fToFilter=0
        if [ $FLAGF -eq 1 ]; then
           fFilter=0;
           for FILTERRULE in "${fRules[@]}"
           do
               IFS=':' read -r -a paramsF <<< "$FILTERRULE"
               if [ ${paramsF[0]} -lt ${#CSVFIELDS[@]} ]; then
                  colNum=${paramsF[0]}
                  colNum=$((colNum-1)) 
                  if [[ ${CSVFIELDS[$colNum]} =~ ${paramsF[1]} ]] ; then
                     fFilter=1    
                     break
                  fi
               fi
           done
           if [ $fFilter -eq 1 ]; then
              deb_msg 'Rec number '$numRec' Filtered.'
              if [ $FLAGFF -eq 1 ]; then
                 echo $LINE >> $FILEFF
              fi
              continue
           fi
        fi
# ---------- EXTRACT -----------
        if [ $FLAGE -eq 1 ]; then
           firstCol=1
           for EXTFIELD in "${erArray[@]}"
           do
               EXTFIELD=$((EXTFIELD-1)) 
               if [ $firstCol -eq 0 ]; then
                  LINE_TO_PRINT+=$CSV_SEPARATOR
               else   
                  firstCol=0
               fi   
               LINE_TO_PRINT+=${CSVFIELDS[EXTFIELD]}
           done    
        fi
# ---------- REMOVE -----------
        if [ $FLAGR -eq 1 ]; then
           for REMFIELD in "${erArray[@]}"
           do
             if [ $REMFIELD -lt ${#CSVFIELDS[@]} ]; then
                REMFIELD=$((REMFIELD-1)) 
                CSVFIELDS[REMFIELD]=$REMOVEVALUE
             fi
           done    

           firstCol=1
           for CSVFIELD in "${CSVFIELDS[@]}"
           do
               if [ $CSVFIELD != $REMOVEVALUE ]; then
                  if [ $firstCol -eq 0 ]; then
                     LINE_TO_PRINT+=$CSV_SEPARATOR
                  else   
                     firstCol=0
                  fi   
                  LINE_TO_PRINT+=$CSVFIELD
               fi
           done
        fi

        if [ -z $LINE_TO_PRINT ] ; then
           LINE_TO_PRINT=$LINE
        fi

# ---------- CHANGE SEPARATOR -----------
        if [ $FLAGCS -eq 1 ]; then
           LINE_TO_PRINT="${LINE_TO_PRINT//$CSV_SEPARATOR/$NEW_SEPARATOR}"
        fi

# ---------- PRINT OUTPUT -----------
        if [ $FLAGV -ne 1 ]; then
           if [ $FLAGO -eq 1 ]; then
              echo $LINE_TO_PRINT >> $FILEO
           else
              echo $LINE_TO_PRINT
           fi   
        fi   
done < "$CSV_FILE"
if [ $FLAGV -eq 1 ]; then
   vprint '-------------------------------------------------------------------------------------------------------'
   vprint 'Total Records :'$numRec
   vprint '-------------------------------------------------------------------------------------------------------'
fi   