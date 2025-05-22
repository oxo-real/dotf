#! /usr/bin/env sh

# --------------------------------------------------------------------
# git.sh


function git-branch ()
{
    # Long form
    branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    # Short form
    # git rev-parse --abbrev-ref HEAD 2> /dev/null | sed -e 's/.*\/\(.*\)/\1/'

    git_status="$(git status 2> /dev/null)"

    if echo "${git_status}" | grep -c 'working tree clean' > /dev/null 2>&1; then

	## up-to-date branch (default grey)
	print "%F{#bbbbbb}$branch%f"

    else

	## changed branch (amber)
	print "%F{#ffbf00}$branch%f"

    fi
}


function git-dirty ()
{
    ## [Git - git-status Documentation](https://git-scm.com/docs/git-status#_short_format)
    # a ahead
    # b behind
    # c to be committed
    # + new
    # - deleted
    # m modified
    # r renamed
    # ? untracked

    # instead of vcs_info
    # [zsh: 26 User Contributions](https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#vcs_005finfo-Configuration)

    git_status="$(git status 2> /dev/null)"

    if echo "${git_status}" | grep -c 'branch is ahead' > /dev/null 2>&1; then

	ahead=$(git status | grep 'branch is ahead' | awk '{print $8}')
	printf 'a%s ' "$ahead"

    fi

    if echo "${git_status}" | grep -c 'branch is behind' > /dev/null 2>&1; then

	behind=$(git status | grep 'branch is behind' | awk '{print $8}')
	printf 'b%s ' "$behind"

    fi

    if echo "${git_status}" | grep -c 'new file:' > /dev/null 2>&1; then

	new=$(git status --porcelain > /dev/null 2>&1 | grep '^A\|^.A' | wc -l)
	printf "${fg_green}+%s${st_def} " "$new"

    fi

    if echo "${git_status}" | grep -c 'deleted:' > /dev/null 2>&1; then

	deleted=$(git status --porcelain > /dev/null 2>&1 | grep '^D\|^.D' | wc -l)
	printf "${fg_red}-%s${st_def} " "$deleted"

    fi

    if echo "${git_status}" | grep -c 'modified:' > /dev/null 2>&1; then

	modified=$(git status --porcelain > /dev/null 2>&1 | grep '^M\|^ M' | wc -l)
	printf 'm%s ' "$modified"

    fi

    if echo "${git_status}" | grep -c 'renamed:' > /dev/null 2>&1; then

	renamed=$(git status --porcelain > /dev/null 2>&1 | grep '^R\|^.R' | wc -l)
	printf 'r%s ' "$renamed"

    fi

    if echo "${git_status}" | grep -c 'Changes to be committed:' > /dev/null 2>&1; then

	tobeco=$(git diff --cached --numstat | wc -l)
	#tobeco=$(git rev-list --count --all)
	printf "${st_rev}c%s${st_def} " "$tobeco"

    fi

   if echo "${git_status}" | grep -c 'Untracked files:' > /dev/null 2>&1; then

	untracked=$(git status --porcelain > /dev/null 2>&1 | grep '^??' | wc -l)
	printf "${bg_red}${fg_black}?%s${st_def} " "$untracked"

    fi
}


function git-add-commit ()
{
    #nowdate="$(date +'%Y%m%d_%H%M%S')"
    #BUFFER="git add . && git commit --gpg-sign=7f462acc -a -m $nowdate (local_update)"
    BUFFER="git add . && git commit --gpg-sign=75AD7085 -a -m '`date +%Y%m%d_%H%M%S` (local_update)'"
    # BUFFER="git add . && git commit --gpg-sign=7f462acc -a -m '`date +%Y%m%d_%H%M%S` (local_update)'"

}

zle -N git-add-commit
