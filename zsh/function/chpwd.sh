#! /usr/bin/env sh


# pwd, statistics and ls when cwd changes
function chpwd ()
{
    ## prompt path color
    if [[ -w $PWD ]]; then

	local left_bar="%F{blue}%B%~%f%b"

    else

	# no write permission directory color #ffbf00
	local left_bar="%F{#000000}%K{#ffbf00}%B %~ %b%k%f"

    fi

    ## directory count
    d_cnt=$(find . -maxdepth 1 -type d | tail -n +2 | wc -l)
    ## hidden directory count
    dh_cnt=$(find . -maxdepth 1 -type d -name '.*' | tail -n +2 | wc -l)
    ## visible directory count
    dv_cnt=$(( d_cnt - dh_cnt ))

    ## file count
    f_cnt=$(find . -maxdepth 1 -type f | wc -l)
    ## hidden file count
    fh_cnt=$(find . -maxdepth 1 -type f -name '.*' | wc -l)
    ## visible file count
    fv_cnt=$(( f_cnt - fh_cnt ))

    ## symlink count
    l_cnt=$(find . -maxdepth 1 -type l | wc -l)
    ## hidden symlink count
    lh_cnt=$(find . -maxdepth 1 -type l -name '.*' | wc -l)
    ## visible symlink count
    lv_cnt=$(( l_cnt - lh_cnt ))

    ## total item count
    ti_cnt=$(( d_cnt + f_cnt + l_cnt ))

    ## right bar
    ### sigma
    rb1=$(printf "\e[1;90m∑\e[0m")
    ### total count
    rb2=$(printf "\e[1;90m $ti_cnt \e[0m")
    ### directories
    rb3=$(printf "\e[1;94;100m $dv_cnt.$dh_cnt \e[0m")
    ### files
    rb4=$(printf "\e[0;39;49m $fv_cnt.$fh_cnt \e[0m")
    ### symlinks
    rb5=$(printf "\e[1;36;100m $lv_cnt.$lh_cnt \e[0m")

    ### synthesized
    right_bar=$(printf $rb1$rb2$rb3$rb4$rb5)

    ## position, alignment and correction parameters
    ### alacritty
    local lb_corr=0
    local rb_corr=-66
    local lb_length=$(( ${#${(S%%)left_bar//(\%([KF1]|)\{*\}|\%[Bbkf])}} + lb_corr ))
    local rb_length=$(( ${#${(S%%)right_bar//(\%([KF1]|)\{*\}|\%[Bbkf])}} + rb_corr ))
    local bar_filler_spaces=$(( COLUMNS - lb_length - rb_length ))

    print -Pr "$left_bar  $right_bar"
    #print -Pr "$left_bar${(l:$bar_filler_spaces:)}$right_bar"

    ## testing alignment
    #print $COLUMNS $lb_length $bar_filler_spaces $rb_length
    ## end testing alignment

    # NOTICE presumes ls alias with eza_wrapper.sh
    ls -A

    #eza --all --group-directories-first
    #ls -A
}
