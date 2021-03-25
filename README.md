# CSVutil

## Description
**CSVutil.sh** is a very effective bash shell to manage csv files by command line.  
Script permits to extract, remove, change separator, print and filter record from a csv file, all results will be generated in stdout or on a file.  

Use: `CSVutil.sh <CSV File Name> [options]`  

Parameters `[...]` are optional  
Parameters `<...>` are mandatory   

<div class="foo">

Option|Description
---------------|------------------
**`[-h]`**|Display an Help  
**`[-s<Separaror>]`**|To set field separator {default is ;}  
**`[-e<Columns To Extract]`**|List of columns to extract separated by , or a range of columns separated by - {example -e1,4,8-11 extract columns numbered 1 and 4 and from 8 to 11}  
**`[-r<Columns To Extract>]`**|List of columns to remove separated by , or a range of columns separated by - {example -r1-3,5 remove columns numbered from 1 to 3 and 5}   
**`[-d]`**|Debug Mode    
**`[-c<New CSV Separator]`**|Specify a new CSV separator   
**`[-f<Filter Condition>]`**|Filter Condition is composed by number column and a regular expression diveded each other by : {example -f2:^Ab Filter will be apply at column 2 and if is true (starts with Ab) record will be filtered} You can specify more filter options and will be related each other in and condition   
**`[-o<File Name Output]`**|File Name Output to generate instead stdout   
**`[-ff<File Name Filtered]`**|File Name where are printed all filtered record    
**`[-t]`**|This option indicate that first row of csv file contains columns titles used with -v option   
**`[-v<separator>]`**|This option is used to show all records with a row for field, you have to specify or not a separator for fields printed {default values is ;}      

</div>

It's important clarify that for options -e, -r and -f column number start from 1.  

Example of executions :  


**CSVutil.sh filetest.csv -e1,3,6-8 -c,**                  [This execution extract from file filetest.csv columns 1,3 and from 6 to 8 and replace separator from ; to , and generate output in stdout].  

**CSVutil.sh filetest.csv -r4,7 -o./filetestRemoved.csv**  [This execution remove from file filetest.csv column 4 and 7 and generate output on file filetestRemoved.csv].  

**CSVutil.sh filetest.csv -f3:^Oct -ff./fileFiltered.csv** [This execution filter from filetest.csv all record where in column 3 start with Oct and generate a new file with record filtered and record not filtered are printed in stdout].  


### Prerequisites  

None  

## Built With  

* [Visual Code Editor](https://code.visualstudio.com)   

## Authors  

* **Giovanni Palleschi** - [gpalleschi](https://github.com/gpalleschi)  

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE 3.0 License - see the [LICENSE](LICENSE) file for details  

