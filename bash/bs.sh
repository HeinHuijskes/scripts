#!/bin/bash
foo=(1 2 3)
bar="yes"

# Prints -$ 1 yes
echo $foo ${bar[0]}
# Prints -$ 1 2 3 yes
echo ${foo[*]} ${bar[@]}

# Copying a variable:
bar=("${foo[@]}")
echo $bar

# Print script name
echo $0
# Print first argument
echo $1
# Print 10th argument
echo ${10}
# Print number of arguments
echo $#
# Print exit status of previous executed process
# 0 is success, others are errors
echo $?
# Print the pid of the current shell
echo $$
# Print the pid of the most recently backgrounded process
echo $!

# String replacement
var="good dog, good dog"
echo ${var/dog/boy}
echo $var
echo ${var//dog/boy}
echo ${var/ dog}

# ${name#pattern} operation removes the shortest prefix of ${name} matching pattern, ## the longest
minipath="/usr/bin:/bin:/sbin"
echo ${minipath#/usr}    # prints /bin:/bin:/sbin
echo ${minipath#*/bin}   # prints :/bin:/sbin
echo ${minipath##*/bin}  # prints :/sbin
# % does the same for suffixes
echo ${minipath%/usr*}   # prints nothing
echo ${minipath%/bin*}   # prints /usr/bin:
echo ${minipath%%/bin*}  # prints /usr

echo ${minipath#/usr}

# # counts the elements in a string or array
ARRAY=(ab cd ef)
echo ${#ARRAY}    # 2
echo ${#ARRAY[@]} # 3

# String and array slicing with :
string="Hello world"
array=(a b c d e f g)
echo ${string:6:3}   # wor
echo ${array[@]:3:2} # d e

# Test variable existence
unset usrname
echo ${usrname-default} # default
usrname=admin
echo ${usrname-default} # admin
# Test exists AND not empty with :-
usrname=""
echo ${usrname:123}  #
echo ${usrname:-123} # 123
# use := to also set the variable if it had no value
unset usrname
echo ${usrname:=100} # 100
echo ${usrname}      # 100
# + prints if the variable DOES exist
echo ${usrname+1}    # 1
# ? crashes the program if the variable is not set
# unset usrname && echo ${usrname?fail} # crashes and prints fail

# Indirect variable lookup with !
foo=(1 2 3)
bar=foo[1]
echo ${!bar} # 2

# Strings print variables with "", and do not with ''
echo "one is $foo" # one is 1
echo 'one is $foo' # one is $foo

# Variables can be exported to child processes with -$ export [varname]

# Use $((expression)) for arithmetic
(( x = 3 * 12 )); echo $x
echo $(( 3 * 12 ))

# Variables CAN be assigned
declare -i number
number=2+4*10
number2=2+4*10
echo $number  # 42
echo $number2 # 2+4*10



# Characters
# & - append to run script in the background
# > - redirect output of a script (echo "a" > file.txt) --> writes "a" to file.txt
# < - redirect input to a script (grep "a" < file.txt) --> finds "a" in file.txt output
# >> - append to file rather than overwrite
# <<endmarker - mark end (cat <<UNTIL print print UNTIL) prints "print print"
# 2> - redirect error outputm in fact all channels have a number, so 1> is equal to >
# M>&N - redirects channel M to N (2>&1) prints errors to output
# `` - drops the output of the command (echo user: `<config/USER`) prints contents of config/USER
# `<path` - shorthand for `cat path`



# Glob notation
# * - matches any string
# ? - matches a single character
# [chars] - matches any character in chars
# [a-b] matches any character between a and b
# {a,b} matches a or b


# Conditionals
if true;
then	echo 'True!';
else	echo 'False!';
fi;
# Use also -$ test (see -$ help test)
# This is also written as [ args ]
if [ -z "$var" ];
then echo '$var is not empty!';
fi;


# Loops
#while true
#do
#   httpd
#done
#for f in *.c
#do
#   gcc -0 ${f%.c} $f
#done


# Subroutines
function name {
    echo 'funky'
}
funky () {
    echo 'funk'
}
# Subroutines have their arguments as $n where n is the nth argument



# Commands
# wait [pid] - wait for a process
# cat - concatenate (cat file1 file2 > file3) concatenates file1 and file2 and puts it in file3
# date - current date and time
# whoami - prints current user
# test - very useful to test many different things such as file existence. See -$ help test
# expand - replace tabs/spaces in files


# Ideas
# - run db reset in the background when initialising test
