# ~/.zshrc — Zsh configuration
# Part of ~/dotfiles — managed via install.sh

# If not running interactively, don't do anything
[[ -o interactive ]] || return

# ══════════════════════════════════════════
# History
# ══════════════════════════════════════════
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY          # share across sessions
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE      # ignore commands starting with space
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY        # save timestamp

# ══════════════════════════════════════════
# Shell Options
# ══════════════════════════════════════════
setopt AUTO_CD                 # type dir name to cd
setopt CORRECT                 # autocorrect commands
setopt INTERACTIVE_COMMENTS    # allow # in interactive shell
setopt NO_BEEP
setopt GLOB_DOTS               # include dotfiles in glob
setopt EXTENDED_GLOB

# ══════════════════════════════════════════
# Environment
# ══════════════════════════════════════════
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="less"
export LESS="-FRXi"
export LANG="C.utf8"
export LC_ALL="C.utf8"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export PYTHONSTARTUP="$HOME/.pythonrc"

# ══════════════════════════════════════════
# Path additions
# ══════════════════════════════════════════
typeset -U path  # deduplicate
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/bin" ]] && path=("$HOME/bin" $path)
[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path)
[[ -d "$HOME/go/bin" ]] && path=("$HOME/go/bin" $path)

# ══════════════════════════════════════════
# Completion
# ══════════════════════════════════════════
autoload -Uz compinit
compinit -C

# Case-insensitive, partial-word, and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Menu selection
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{red}No matches found%f'

# ══════════════════════════════════════════
# Key bindings
# ══════════════════════════════════════════
bindkey -e  # emacs mode

# Arrow key history search (prefix-based)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

# Ctrl+arrow word movement
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Home/End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# Delete
bindkey '^[[3~' delete-char

# ══════════════════════════════════════════
# Two-line prompt via precmd
# ══════════════════════════════════════════
# ┌─[zach@host]─[🐍 venv]─[⭐ main *+]─[~/projects/myapp]─[✘ 130]
# └─❯

__dotfiles_git_info() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [ -z "$branch" ] && return

    local flags=""
    local status
    status=$(git status --porcelain 2>/dev/null)

    echo "$status" | grep -q '^.[MD]' && flags+="*"
    echo "$status" | grep -q '^[MADRC]' && flags+="+"
    echo "$status" | grep -q '^??' && flags+="?"
    git stash list 2>/dev/null | grep -q . && flags+='$'

    if [ -n "$flags" ]; then
        echo "${branch} ${flags}"
    else
        echo "${branch}"
    fi
}

precmd() {
    local last_exit=$?

    local line1="%F{8}┌─%f"

    # User@Host
    line1+="%F{7}[%f%B%F{cyan}%n%f%b@%B%F{cyan}%m%f%b%F{7}]%f%F{8}─%f"

    # Virtualenv
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name="${VIRTUAL_ENV:t}"
        line1+="%F{7}[%f%B%F{green}🐍 ${venv_name}%f%b%F{7}]%f%F{8}─%f"
    fi

    # Conda
    if [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        line1+="%F{7}[%f%B%F{green}🐍 ${CONDA_DEFAULT_ENV}%f%b%F{7}]%f%F{8}─%f"
    fi

    # Git
    local git_info
    git_info=$(__dotfiles_git_info)
    if [[ -n "$git_info" ]]; then
        line1+="%F{7}[%f%B%F{yellow}⭐ ${git_info}%f%b%F{7}]%f%F{8}─%f"
    fi

    # Directory
    line1+="%F{7}[%f%B%F{blue}%~%f%b%F{7}]%f"

    # Error segment
    if [[ $last_exit -ne 0 ]]; then
        line1+="%F{8}─%f%F{7}[%f%B%F{red}✘ ${last_exit}%f%b%F{7}]%f"
    fi

    # Second line
    local line2="%F{8}└─%f"
    if [[ $last_exit -eq 0 ]]; then
        line2+="%B%F{green}❯%f%b "
    else
        line2+="%B%F{red}❯%f%b "
    fi

    PROMPT="${line1}"$'\n'"${line2}"
}

# Disable default virtualenv prompt modification
export VIRTUAL_ENV_DISABLE_PROMPT=1

# ══════════════════════════════════════════
# Source shared aliases and functions
# ══════════════════════════════════════════
_dotfiles_dir="${${(%):-%x}:A:h:h}"

if [[ -f "${_dotfiles_dir}/shell/aliases.sh" ]]; then
    source "${_dotfiles_dir}/shell/aliases.sh"
fi
if [[ -f "${_dotfiles_dir}/shell/functions.sh" ]]; then
    source "${_dotfiles_dir}/shell/functions.sh"
fi
unset _dotfiles_dir

# Shell-specific reload
alias reload='source ~/.zshrc && echo "Zsh config reloaded."'

# ══════════════════════════════════════════
# Tool integrations
# ══════════════════════════════════════════
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
    fi
fi

# ══════════════════════════════════════════
# Local overrides (not tracked in dotfiles)
# ══════════════════════════════════════════
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
