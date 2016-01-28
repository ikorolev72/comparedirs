#						comparedirs


###  What is it?
  -----------
Command line tool for compare directories. 
Can be usefull to found differents in Sun explorers and so on.
Will produce diff output to STDOUT and messages about different files in STDERR.
Can check content or modification/size of files.

###  The Latest Version
  ------------------
	version 1.0

###  Documentation
  -------------
Script will compare first directory and second directory and show files which not existed
in second directory, differences in files with same filenames or print differences in
modification date and filesizes.
If you have the old and the new versions of sites, liraries, sources and so on this script will be useful to
search for differences

###  Installation
  ------------

###  Usage
  ------------

```
Usage:

D:\ > comparedirs.exe -?
Script will compare first directory and second directory and show files which not existed
in second directory, differences in files with same filenames or print differences in
modification date and filesizes.
If you have the old and the new Sun Explorer from any server, this script will be useful to
search for differences
-------------------------------------------------------------------------------------------
Usage:D:\client\TELE2\servers\runner\comparedirs.exe [-help|?] | [-dir1|d1=directory1 
-dir2|d2=directory2 [-size|s]|[-content|c]][-verbose|v]
-help     this help
-dir2     absolutly path to first directory
-dir2     absolutly path to second directory
-content  compare content of files with same names in dir1 and dir2
-size     compare only modification date and size of files with same names in dir1 and dir2
-verbose  verbose output
-------------------------------------------------------------------------------------------
Example:
D:\comparedirs.exe 
	-content 
	-d1=c:/explorer.8eeeeee.e25k-2008.05.28.17.56 \
	-d2=c:/explorer.8eeeeee.e25k-2009.01.20.11.24 \
	> c:/tmp/diff.log \
	2> c:/tmp/messages.log
```
	

###  Licensing
  ---------
	GNU

###  Contacts
  --------

     o korolev-ia [at] yandex.ru
     o http://www.unixpin.com















	