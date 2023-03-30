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
                    printf "  %-9s" "default"
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
                            printf "  %-9s" "default"
                        end
                        printf " %sTEXT\e[m" $seq0
                        printf " \e[%s;1mBOLD\e[m" $vals
                    end
                    echo; echo
                end
            end
            echo; echo
        end
    end

    # Change the window title of X terminals
    switch $TERM
        case 'xterm*' 'rxvt*' 'Eterm*' 'aterm' 'kterm' 'gnome*' 'interix' 'konsole*'
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

    # disable greeting message
    set -g fish_greeting

    # aliases
    alias vim="nvim"
    alias cp="cp -i" # confirm before overwriting something
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    function git_log
        git log --graph --all --oneline
    end

    # run neofetch
    if type -q neofetch
        neofetch
    end

end

