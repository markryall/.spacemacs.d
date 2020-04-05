#!/usr/bin/env zsh

set -e

filename=$1
linenumber=$2
textbefore=$3
textafter=$4
workingdir=$5

debugfile=~/launches.log

echo "filename=$filename" >> $debugfile
echo "linenumber=$linenumber" >> $debugfile
echo "textbefore=$3" >> $debugfile
echo "textafter=$4" >> $debugfile
echo "workingdir=$5" >> $debugfile

# Handle the situation where the filename actually contains the line number
# eg. specs/blah_spec.rb:15
splitfilename=("${(@s/:/)filename}")
if [[ ${#splitfilename} == 2 ]]; then
    filename=$splitfilename[1]
    linenumber=$splitfilename[2]
fi

launchpath="$workingdir/$filename"

# Handle the situation where the filename is an absolute path (starting with a /)
# (in this case just completely ignore the current working directory)
if [[ $filename == (/)* ]]; then
    launchpath="$filename"
fi

echo "launching $launchpath" >> $debugfile

if [[ $linenumber == '' ]]
then
    echo $launchpath | pbcopy
    emacsclient -n "$launchpath"
else
    # when a line number is present then jump straight to that line
    echo "on line $linenumber" >> $debugfile
    echo "$launchpath:$linenumber" | pbcopy
    emacsclient -n +"$linenumber" "$launchpath"
fi

echo "----------------" >> $debugfile
