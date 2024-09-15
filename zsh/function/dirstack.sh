#! /usr/bin/env sh


function dirstack ()
{
    ## create chronological cd history with unique lines only

    basename_cwd=$(basename $PWD)
    first_hist_line=1

    ## fc list history of cd commands
    ## sort chronological (prepare unique)
    ## sed remove trailing slashes (prepare unique)
    ## sort alphabetical (first unique pass)
    ## sort chronological (final sort)
    ## tr remove double spaces
    ## cut remove non-directory part of fc line
    ## sed insert previous working directory
    ## grep remove basename cwd
    ## grep remove full $PWD
    ## awk remove lines with more than one word
    ## sed remove '..'
    ## sed remove '.'
    ## sed remove empty lines
    ## uniq remove repeated lines (second pass)
    dir_stack=$(fc -l -d -t %Y%m%d_%H%M%S -D -m 'cd *' $first_hist_line | \
		   sort --reverse --numeric-sort --key 1 | \
		   sed 's|[/\t]$||' | \
		   sort --unique --key 5 | \
		   sort --reverse --numeric-sort --key 1 | \
		   tr -s ' ' | \
		   cut -d ' ' -f 6- | \
		   sed "1i $OLDPWD" | \
		   grep --invert-match --line-regexp $basename_cwd | \
		   grep --invert-match --line-regexp $PWD | \
		   sed '/^..$/d' | \
		   sed '/^.$/d' | \
		   awk 'NF<=1{print}' | \
		   sed '/^\s*$/d' | \
		   uniq \
	    )
}
