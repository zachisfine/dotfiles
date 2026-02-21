# ~/.dotfiles/shell/aliases.sh
# Shared aliases for bash and zsh

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# --- ls variants ---
if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first'
    alias ll='eza -lahF --group-directories-first --git'
    alias la='eza -a --group-directories-first'
    alias lt='eza -T --group-directories-first --level=2'
else
    alias ls='ls --color=auto --group-directories-first 2>/dev/null || ls --color=auto'
    alias ll='ls -lahF'
    alias la='ls -A'
    alias lt='tree -L 2'
fi
alias l='ll'

# --- grep with color ---
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# --- bat/cat ---
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat'
elif command -v batcat &>/dev/null; then
    alias bat='batcat'
    alias cat='batcat --paging=never'
    alias catp='batcat'
fi

# --- git shortcuts ---
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -20'
alias glg='git log --graph --oneline --decorate --all'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch --all --prune'
alias gst='git stash'
alias gstp='git stash pop'
alias gcp='git cherry-pick'
alias grb='git rebase'
alias grbi='git rebase -i'

# --- docker ---
alias dk='docker'
alias dkc='docker compose'
alias dkps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dkimg='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'

# --- safety nets ---
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# --- quick edit/reload ---
alias edot='${EDITOR:-vim} ~/dotfiles'
alias ealias='${EDITOR:-vim} ~/dotfiles/shell/aliases.sh'
alias efunc='${EDITOR:-vim} ~/dotfiles/shell/functions.sh'

# Reload is shell-specific; defined in .bashrc/.zshrc
# alias reload='source ~/.bashrc'  # overridden per shell

# --- system info ---
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop 2>/dev/null || top'
alias psg='ps aux | grep -v grep | grep -i'

# --- network ---
alias myip='curl -s https://ifconfig.me && echo'
alias localip="hostname -I | awk '{print \$1}'"
alias ports='ss -tulnp'
alias ping='ping -c 5'

# --- WSL clipboard ---
if grep -qi microsoft /proc/version 2>/dev/null; then
    alias clip='clip.exe'
    alias pbcopy='clip.exe'
    alias pbpaste='powershell.exe -command "Get-Clipboard" 2>/dev/null'
    alias open='explorer.exe'
fi

# --- developer helpers ---
alias serve='python3 -m http.server 8000'
alias json='python3 -m json.tool'
alias path='echo -e "${PATH//:/\\n}"'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias sha='shasum -a 256'

# --- misc ---
alias cls='clear'
alias h='history'
alias j='jobs -l'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias diff='diff --color=auto'
