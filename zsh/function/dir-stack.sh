#! /usr/bin/env sh

# --------------------------------------------------------------------
# dir-stack.sh


function dir-stack ()
{
    ## create chronological cd listing from history with unique lines only

    ## sed extract commands from histfile
    ## grep only cd commands
    ## sed remove lines with cd .(.), cd -, erase ../, cd[space], and trailing slashes
    ## insert $OLDPWD to first line
    ## nl add linenumbers (for chronological order)
    ### sort chronological (1st sort; prepare unique)
    ### sort alphabetical and make unique (2nd sort; first unique pass)
    ### DEL####### uniq only unique lines (second unique pass)
    ### sort chronological (3rd final sort)
    ## awk remove linenumbers
    ## sed remove leading spaces
    ## this leaves us with a chronological list of unique directories from history

    ## final adjustments for cd-nav-dirs

    ## sed insert previous working directory on first line
    ## grep remove basename $PWD (can't move to it)
    ## grep remove full $PWD (can't move to it)
    ## sed remove empty lines
    ## DEL####### uniq remove repeated lines (third final unique pass)

    # NOTICE uniq works only with similar adjacent lines

    # dir_stack=$(\
    # 		sed --regexp-extended 's/^:[[:space:]][[:digit:]]{10}:[[:digit:]]+;//' $HISTFILE | \
    # 		    grep '^cd ' | \
    # 		    sed --regexp-extended -e '/cd [\.]{1,2}$/d' -e '/cd -/d' -e 's|\.\./||' -e 's|^cd ||' -e 's|/$||' | \
    # 		    sed "1i $OLDPWD" | \
    # 		    nl --number-format ln | \
    # 		    sort --reverse --numeric-sort --key 1 | \
    # 		    sort --unique --key 2 | \
    # 		    sort --reverse --numeric-sort --key 1 | \
    # 		    awk '!($1="")' | \
    # 		    sed --regexp-extended 's/^[[:space:]]+//' | \
    # 		    grep --invert-match --line-regexp $(basename $PWD) | \
    # 		    grep --invert-match --line-regexp $PWD | \
    # 		    sed '/^\s*$/d'\
    # 	     )

    hist_cd=$(\
		sed --regexp-extended 's/^:[[:space:]][[:digit:]]{10}:[[:digit:]]+;//' $HISTFILE | \
		    grep '^cd ' | \
		    sed --regexp-extended -e '/cd [\.]{1,2}$/d' -e '/cd -/d' -e 's|\.\./||' -e 's|^cd ||' -e 's|/$||' | \
		    sed "1i $OLDPWD" | \
		    nl --number-format ln | \
		    sort --reverse --numeric-sort --key 1 | \
		    sort --unique --key 2 | \
		    sort --reverse --numeric-sort --key 1 | \
		    awk '!($1="")' | \
		    sed --regexp-extended 's/^[[:space:]]+//' | \
		    grep --invert-match --line-regexp $(basename $PWD) | \
		    grep --invert-match --line-regexp $PWD | \
		    sed '/^\s*$/d'\
	   )

    dir_stack_arr=()

    while read hist_cd_line; do

	if [ -d "$hist_cd_line" ]; then

	    dir_stack_arr+=("$hist_cd_line")

	fi

    done <<< "$hist_cd"

    dir_stack=$(printf '%s\n' "${dir_stack_arr[@]}")
}
