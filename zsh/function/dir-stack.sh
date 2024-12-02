#! /usr/bin/env sh


function dir-stack ()
{
    ## create chronological cd listing from history with unique lines only

    ## sed extract commands from histfile
    ## grep only cd commands
    ## sed remove lines with cd .(.), cd -, erase ../, cd[space], and trailing slashes
    ### ### marked lines are keeping last occurence of duplicates
    ### ### only relevant if also timestamps and or linenumbers are exported to dir_stack
    ### nl add linenumbers (for chronological order)
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

    dir_stack=$(\
		sed --regexp-extended 's/^:[[:space:]][[:digit:]]{10}:[[:digit:]]+;//' $HISTFILE | \
		    grep '^cd ' | \
		    sed --regexp-extended -e '/cd [\.]{1,2}$/d' -e '/cd -/d' -e 's|\.\./||' -e 's|^cd ||' -e 's|/$||' | \
		    sed "1i cd $OLDPWD" | \
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
		    #uniq --skip-fields 1 --unique | \
		    #uniq\
}

