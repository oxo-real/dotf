#! /usr/bin/env sh


function dirstack ()
{
    ## create chronological cd history with unique lines only

    basename_cwd=$(basename $PWD)

    ## sed --regexp-extended get history commands only
    ## grep only cd commands
    ## sed remove lines with cd .(.), cd - and erase cd ../
    ## nl add linenumbers (for chronological order)
    ## sed remove trailing slashes (prepare unique)
    ## sort chronological (prepare unique)
    ## sort alphabetical and make unique (first unique pass)
    ## sort chronological (final sort)
    ## awk remove column 1 and 2 (linenumber and cd)
    ## sed remove leading spaces
    #### this leaves us with a chronological list of unique directories

    #### final adjustments
    ## grep remove basename cwd (can't move to it)
    ## grep remove full $PWD (can't move to it)
    ## sed insert previous working directory on first line
    ## sed remove empty lines
    ## uniq remove repeated lines (second unique pass)
    dir_stack=$(sed --regexp-extended 's/^:[[:space:]][[:digit:]]{10}:[[:digit:]]+;//' $HISTFILE | \
		    grep '^cd ' | \
		    sed --regexp-extended -e '/cd [\.]{1,2}$/d' -e '/cd -/d' -e 's|\.\./||' | \
		    nl --number-format ln | \
		    sed 's|/$||' | \
		    sort --reverse --numeric-sort --key 1 | \
		    sort --unique --key 2 | \
		    sort --reverse --numeric-sort --key 1 | \
		    awk '!($1=$2="")' | \
		    sed --regexp-extended 's/^[[:space:]]+//' | \
		    grep --invert-match --line-regexp $basename_cwd | \
		    grep --invert-match --line-regexp $PWD | \
		    sed "1i $OLDPWD" | \
		    sed '/^\s*$/d' | \
		    uniq\
	     )
}
