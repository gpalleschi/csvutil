# CSVutil

## Description
**CSVutil.sh** is a very effective bash shell to manage csv files by command line.  
Script permits to extract, remove, change separator, print and filter record from a csv file, all results will be generated in stdout or on a file.  

Use: `CSVutil.sh <CSV File Name> (options)`  

Parameters `(...)` are optional  
Parameters `<...>` are mandatory   

<table>
    <tr style="background-color:#A9A9A9">
        <td width="30%" style="text-align:center;color:black;font-weight:bold;border:1px solid black">Option</td>
        <td style="text-align:center;color:black;font-weight:bold;border:1px solid black">Description</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-h]</td>
        <td style="border:1px solid black">Display an Help</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-s(Separaror)]</td>
        <td style="border:1px solid black">To set field separator {default is ;}</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-e(Columns To Extract)]</td>
        <td style="border:1px solid black">List of columns to extract separated by , or a range of columns separated by - {example -e1,4,8-11 extract columns numbered 1 and 4 and from 8 to 11}</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-r(Columns To Extract)]</td>
        <td style="border:1px solid black">List of columns to remove separated by , or a range of columns separated by - {example -r1-3,5 remove columns numbered from 1 to 3 and 5}</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-d]</td>
        <td style="border:1px solid black">Debug Mode</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-c(New CSV Separator)]</td>
        <td style="border:1px solid black">Specify a new CSV separator</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-f(Filter Condition)]</td>
        <td style="border:1px solid black">Filter Condition is composed by number column and a regular expression diveded each other by : {example -f2:^Ab Filter will be apply at column 2 and if is true (starts with Ab) record will be filtered} You can specify more filter options and will be related each other in and condition</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-o(File Name Output)]</td>
        <td style="border:1px solid black">File Name Output to generate instead stdout</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-ff(File Name Filtered)]</td>
        <td style="border:1px solid black">File Name where are generated all filtered record in original format</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-t]</td>
        <td style="border:1px solid black">This option indicate that first row of csv file contains columns titles used specify with -v option</td>
    </tr>
    <tr>
        <td width="30%" style="font-weight:bold;border:1px solid black">[-v(separator)]</td>
        <td style="border:1px solid black">This option is used to show all records with a row for field, you can specify a separator between fields printed {default values is ;}</td>
    </tr>
</table>


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

