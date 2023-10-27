# Purpose
The goal of this script is to let you keeping some orginal text based on their key names (using regular expression to match them) and so override the translation existing in the translated/global.ini file

You can add any number of regex in the do-not-translate-pattern.ini file. 
* The key is just an helper for you
* The value is the regexp to apply
As soon as a key in the global.ini match one of those regexp, the original value will be kept instead of the translated one

For example to avoid translating all Stanton element except their respective description you can use this regex:
^(Stanton)(?!.\*_desc.\*)

This regexp will match all global.ini keys starting with "Stanton" and not containing "_desc" somewhere after that

# Configuration
1) Copy the most up-to-date global.ini (CIG original file) in the original directory
2) Copy your preferred translated global.ini file in the translated directory 
3) Edit the do-not-translate-pattern.ini file containing regex pattern defining what to keep as key name in the original file (key name can be anything, value are regexp)
# Powershell authorization
1) Open powershell and execute this command
2) Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
# Script execution
1) Now you can execute do-not-translate.ps1 scripts
2) the generated global.ini file will be aside the ps1 script