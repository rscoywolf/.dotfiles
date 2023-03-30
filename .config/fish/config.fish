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

                set seq0 (test -n "$vals"; and printf "\e[${vals}m")
                printf "  %-9s" "${seq0:-(default)}"
                printf " ${seq0}TEXT\e[m"
                printf " \e[${vals};1mBOLD\e[m"
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

    # Colorful prompt
    function fish_prompt
        set -l use_color true
        set -l safe_term (string replace -r "[^[:alnum:]]" "?" -- $TERM)

        if test $EUID -eq 0
            set_color -o red
            printf "[%s " (hostname)
            set_color -o cyan
            printf "%s" (prompt_pwd)
            set_color -o red
            printf "]# "
        else
            set_color -o green
            printf "[%s@%s " $USER (hostname)
            set_color -o white
            printf "%s" (prompt_pwd)
            set_color -o green
            printf "]$ "
        end
        set_color normal
    end

    # Enable colors for ls, etc.
    set -gx LS_COLORS (dircolors -c)

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'

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

    # aliases
    alias ls="ls -al"
    alias vim="nvim"
    alias cp="cp -i"                          # confirm before overwriting something

    # Run neofetch
    if type -q neofetch
        neofetch
    end

    # Run fish
    fish
end

