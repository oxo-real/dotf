#! /usr/bin/env sh

# --------------------------------------------------------------------
# dir-stack.sh


function dir-stack ()
{
    ## hist_cd: chronological list of unique directories from history
    hist_cd=$(\
		sed --regexp-extended 's/^:[[:space:]][[:digit:]]{10}:[[:digit:]]+;//' $HISTFILE | \
		    grep '^cd ' | \
		    sed --regexp-extended -e '/cd [\.]{1,2}$/d' -e '/cd -/d' -e 's|\.\./||' -e 's|^cd ||' -e 's|/$||' | \
		    sed "s|^~|$HOME|" | \
		    nl --number-format ln | \
		    sort --key 1,1 --numeric-sort --reverse | \
		    sed "1i 0 $OLDPWD" | \
		    awk '!seen[$2]++ {print $1, $2}' | \
		    awk '!($1="")' | \
		    sed --regexp-extended 's/^[[:space:]]+//' | \
		    grep --invert-match --line-regexp $(basename $PWD) | \
		    grep --invert-match --line-regexp $PWD | \
		    sed '/^\s*$/d'\
	   )

    ## sed extract commands from histfile
    ## grep only cd commands
    ## sed remove lines with cd .(.), cd -, erase ../, cd[space], and trailing slashes
    ## sed replace ~ with $HOME
    ## nl add linenumbers (for chronological order)
    ## sort chronological
    ## sed insert previous working directory on first line (most recent)
    ## awk only second column unique values (but show both columns)
    ## awk remove linenumbers
    ## sed remove leading spaces
    ## grep remove basename $PWD (can't move to it)
    ## grep remove full $PWD (can't move to it)
    ## sed remove empty lines (trailing backslash is for linebreak)

    ## from hist_cd show only show directories in reach from cwd
    dirs_in_reach_arr=()
    while read hist_cd_line; do

	if [ -d "$hist_cd_line" ]; then

	    dirs_in_reach_arr+=("$hist_cd_line")

	fi

    done <<< "$hist_cd"

    ## directoriies in reach (dir)stack
    dir_stack=$(printf "${fg_blue}${st_bold}%s${st_def}\n" "${dirs_in_reach_arr[@]}")
    #dir_stack=$(printf '%s\n' "${dirs_in_reach_arr[@]}")
}
