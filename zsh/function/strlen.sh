function strlen ()
{
    # calculate string length
    ## called by preexec
    ## original
    arg=$1
    #local excl_pttrn='%([KF1]|)([BSUbfksu]|([FB]|){*})' ## errors
    #local excl_pttrn='%([BSUbfksu]|([FK]|){*})'
    local excl_pttrn='%([KF1]|)({*\}|[Bbkf])}'
    #local excl_pattrn='%([BSUbfksu]|([FB]|){*})'
    ## ~excl_pttrn ensures that excl_pttrn,
    ##  is treated as a pattern rather than as a plain string
    ## ${(S%%)arg//$~excl_pttrn/} matches ${arg//pattern/repl}
    ## S makes matching non-greedy shortest possible match
    ## repl is empty, basically removing the shorteest possible match
    local length=${#${(S%%)arg//$~excl_pttrn/}}
    echo $length
}


function xstrlen ()
{
    ## alternative strlen fuction
    ## https://github.com/romkatv/powerlevel10k/blob/master/internal/p10k.zsh
    : '
This function, strlen, calculates the length of a given string in bash.
It uses a loop to double the size of a variable y, until it is larger
than the length of the string.
Then it repeatedly halves y and checks if the substring of the
input string from 0 to y is equal to y.
If it is, it sets x to y and repeats the process until
it finds the length of the string.

    # '
    # calculate $1 string length
    ## alternative

    ## initialize variables
    ## y is the length of $1
    local -i x y=${#1} m

    if (( y )); then

	# loop until y is larger than the length of the string
	## the condition is checking if the first argument passed
	## to the command is less than or equal to 1, and if it is not, the loop will exit
	while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do

            # double the size of y
	    x=y
	    (( y *= 2 ))

	done

        # binary search to find the length of the string
	while (( y > x + 1 )); do

	    ## calculate the midpoint of the range x to y
	    (( m = x + (y - x) / 2 ))
	    ## check if the length of the string is equal to the
	    ## midpoint m. If it is, then the length of the string is m
	    (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))

	done

    fi

    echo $x
}

