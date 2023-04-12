# Check if the shell is interactive
if status is-interactive
    # Function to display colors
    function colors
        set -l fgc bgc vals seq0

        printf "Color escapes are %s\n" '\e[${value};...;${value}m'
        printf "Values 30..37 are \e[33mforeground colors\e[m\n"
        printf "Values 40..47 are \e[43mbackground colors\e[m\n"
        printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

        for fgc in (seq 30 37)
            for bgc in (seq 40 47)
                set fgc (math $fgc - 37) # white
                set bgc (math $bgc - 40) # black

                set vals (string join ";" $fgc $bgc)
                set vals (string trim $vals ";")

                set seq0 (test -n "$vals"; and printf "\e[%sm" $vals)
                if set -q seq0
                    printf "  %-9s" "$seq0"
                else
                    printf "  %-9s" default
                end
                for fgc in (seq 30 37)
                    for bgc in (seq 40 47)
                        set fgc (math $fgc - 37) # white
                        set bgc (math $bgc - 40) # black

                        set vals (string join ";" $fgc $bgc)
                        set vals (string trim $vals ";")

                        set seq0 (test -n "$vals"; and printf "\e[%sm" $vals)
                        if set -q seq0
                            printf "  %-9s" "$seq0"
                        else
                            printf "  %-9s" default
                        end
                        printf " %sTEXT\e[m" $seq0
                        printf " \e[%s;1mBOLD\e[m" $vals
                    end
                    echo
                    echo
                end
            end
            echo
            echo
        end
    end

    # Change the window title of X terminals
    switch $TERM
        case 'xterm*' 'rxvt*' 'Eterm*' aterm kterm 'gnome*' interix 'konsole*'
            function update_title
                echo -ne "\033]0;{$USER}@{$HOSTNAME%%.*}:{$PWD/#$HOME/\~}\007"
            end
            set -U fish_prompt_callback update_title
        case 'screen*'
            function update_title
                echo -ne "\033_{$USER}@{$HOSTNAME%%.*}:{$PWD/#$HOME/\~}\033\\"
            end
            set -U fish_prompt_callback update_title
    end


    # ex - archive extractor
    # usage: ex <file>
    function ex
        if test -f $argv[1]
            switch $argv[1]
                case '*.tar.bz2'
                    tar xjf $argv[1]
                case '*.tar.gz'
                    tar xzf $argv[1]
                case '*.bz2'
                    bunzip2 $argv[1]
                case '*.tar.xz'
                    tar -xf $argv[1]
                case '*.rar'
                    unrar x $argv[1]
                case '*.gz'
                    gunzip $argv[1]
                case '*.tar'
                    tar xf $argv[1]
                case '*.tbz2'
                    tar xjf $argv[1]
                case '*.tgz'
                    tar xzf $argv[1]
                case '*.zip'
                    unzip $argv[1]
                case '*.Z'
                    uncompress $argv[1]
                case '*.7z'
                    7z x $argv[1]
                case '*'
                    echo "'$argv[1]' cannot be extracted via ex()"
            end
        else
            echo "'$argv[1]' is not a valid file"
        end
    end

    # prompt
    function fish_prompt --description 'Write out the prompt'
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        set -l normal (set_color normal)
        set -q fish_color_status
        or set -g fish_color_status red

        # Color the prompt differently when we're root
        set -l color_cwd $fish_color_cwd
        set -l suffix '>'
        if functions -q fish_is_root_user; and fish_is_root_user
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            end
            set suffix '#'
        end

        # Write pipestatus
        # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
        set -l bold_flag --bold
        set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
        if test $__fish_prompt_status_generation = $status_generation
            set bold_flag
        end
        set __fish_prompt_status_generation $status_generation
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color $bold_flag $fish_color_status)
        set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        echo -n -s (prompt_login)' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
    end

    # disable greeting message
    set -g fish_greeting

    # aliases
    alias vim="nvim"
    alias cp="cp -i" # confirm before overwriting something
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias cls='clear'
    alias lg='lazygit'
    alias update='sudo pacman -Syu'
    # makes it so when ranger exits, it exits to the same directory it was in
    touch $HOME/.rangerdir
    alias ranger='ranger --choosedir=$HOME/.rangerdir; set LASTDIR (cat $HOME/.rangerdir); cd "$LASTDIR"'
    function git_log
        git log --graph --all --oneline
    end

    # run neofetch
    if type -q neofetch
        neofetch
    end

    # set default text editor
    set -gx VISUAL nvim
    set -gx EDITOR $VISUAL

end
