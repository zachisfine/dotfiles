# ~/.config/fish/config.fish — Fish shell configuration
# Part of ~/dotfiles — managed via install.sh

# ══════════════════════════════════════════
# Greeting
# ══════════════════════════════════════════
set -g fish_greeting ""

# ══════════════════════════════════════════
# Environment
# ══════════════════════════════════════════
set -gx EDITOR vim
set -gx VISUAL vim
set -gx PAGER less
set -gx LESS "-FRXi"
set -gx LANG "C.utf8"
set -gx LC_ALL "C.utf8"
set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
set -gx PYTHONSTARTUP "$HOME/.pythonrc"

# ══════════════════════════════════════════
# Path
# ══════════════════════════════════════════
fish_add_path -g ~/.local/bin
fish_add_path -g ~/bin
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/go/bin

# ══════════════════════════════════════════
# Abbreviations (fish idiom — expand on space)
# ══════════════════════════════════════════
# Navigation
abbr -a -- - 'cd -'

# Git
abbr -a g     git
abbr -a gs    'git status -sb'
abbr -a ga    'git add'
abbr -a gc    'git commit'
abbr -a gcm   'git commit -m'
abbr -a gca   'git commit --amend'
abbr -a gco   'git checkout'
abbr -a gsw   'git switch'
abbr -a gb    'git branch'
abbr -a gd    'git diff'
abbr -a gds   'git diff --staged'
abbr -a gl    'git log --oneline -20'
abbr -a glg   'git log --graph --oneline --decorate --all'
abbr -a gp    'git push'
abbr -a gpl   'git pull'
abbr -a gf    'git fetch --all --prune'
abbr -a gst   'git stash'
abbr -a gstp  'git stash pop'
abbr -a gcp   'git cherry-pick'
abbr -a grb   'git rebase'

# Docker
abbr -a dk    docker
abbr -a dkc   'docker compose'

# Common
abbr -a cls   clear
abbr -a h     history
abbr -a j     'jobs -l'

# ══════════════════════════════════════════
# Aliases (non-expanding)
# ══════════════════════════════════════════
alias ..    'cd ..'
alias ...   'cd ../..'
alias ....  'cd ../../..'

# ls variants
if command -q eza
    alias ls  'eza --group-directories-first'
    alias ll  'eza -lahF --group-directories-first --git'
    alias la  'eza -a --group-directories-first'
    alias lt  'eza -T --group-directories-first --level=2'
else
    alias ll  'ls -lahF'
    alias la  'ls -A'
end
alias l ll

# Grep
alias grep  'grep --color=auto'

# bat/cat
if command -q bat
    alias cat  'bat --paging=never'
    alias catp bat
else if command -q batcat
    alias bat  batcat
    alias cat  'batcat --paging=never'
    alias catp batcat
end

# Safety
alias rm    'rm -i'
alias mv    'mv -i'
alias cp    'cp -i'

# System
alias df    'df -h'
alias du    'du -h'
alias free  'free -h'

# Network
alias myip  'curl -s https://ifconfig.me; and echo'

# Developer
alias serve 'python3 -m http.server 8000'
alias json  'python3 -m json.tool'
alias now   'date +"%Y-%m-%d %H:%M:%S"'

# Quick edit
alias edot  "$EDITOR ~/dotfiles"

# Disable virtualenv prompt
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# ══════════════════════════════════════════
# Functions
# ══════════════════════════════════════════
function mkcd -d "Create directory and cd into it"
    mkdir -p $argv[1]; and cd $argv[1]
end

function extract -d "Extract any archive"
    if test (count $argv) -eq 0
        echo "Usage: extract <file>"
        return 1
    end
    switch $argv[1]
        case '*.tar.bz2';  tar xjf $argv[1]
        case '*.tar.gz';   tar xzf $argv[1]
        case '*.tar.xz';   tar xJf $argv[1]
        case '*.bz2';      bunzip2 $argv[1]
        case '*.gz';       gunzip $argv[1]
        case '*.tar';      tar xf $argv[1]
        case '*.tbz2';     tar xjf $argv[1]
        case '*.tgz';      tar xzf $argv[1]
        case '*.zip';      unzip $argv[1]
        case '*.7z';       7z x $argv[1]
        case '*.xz';       xz -d $argv[1]
        case '*'
            echo "extract: '$argv[1]' — unknown archive format"
    end
end

function up -d "Go up N directories"
    set -l count (math max 1, $argv[1])
    set -l path ""
    for i in (seq $count)
        set path "$path../"
    end
    cd $path
end

function backup -d "Create timestamped backup"
    if test (count $argv) -eq 0
        echo "Usage: backup <file>"
        return 1
    end
    set -l ts (date +%Y%m%d_%H%M%S)
    cp -a $argv[1] "$argv[1].bak.$ts"
    echo "Backed up: $argv[1] → $argv[1].bak.$ts"
end

function cheat -d "Query cheat.sh"
    curl -s "cheat.sh/$argv[1]"
end

function weather -d "Show weather"
    curl -s "wttr.in/$argv[1]?format=3"; and echo
end

function sysinfo -d "Quick system summary"
    echo "Hostname: "(hostname)
    echo "User:     "(whoami)
    echo "Kernel:   "(uname -r)
    echo "Shell:    $SHELL"
    echo "Disk (/): "(df -h / | awk 'NR==2{print $3 "/" $2 " (" $5 ")"}')
end

# ══════════════════════════════════════════
# WSL clipboard support
# ══════════════════════════════════════════
if test -f /proc/version; and grep -qi microsoft /proc/version
    alias clip    clip.exe
    alias pbcopy  clip.exe
    alias open    explorer.exe
end

# ══════════════════════════════════════════
# Tool integrations
# ══════════════════════════════════════════
if command -q starship
    starship init fish | source
end

if command -q direnv
    direnv hook fish | source
end

if command -q fzf
    set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --info=inline"
    if command -q fd
        set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    end
end

# ══════════════════════════════════════════
# Local overrides
# ══════════════════════════════════════════
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
