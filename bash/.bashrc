# ~/.bashrc — Bash configuration
# Part of ~/dotfiles — managed via install.sh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ══════════════════════════════════════════
# History
# ══════════════════════════════════════════
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:cls:h"
HISTTIMEFORMAT="%F %T  "
shopt -s histappend

# ══════════════════════════════════════════
# Shell Options
# ══════════════════════════════════════════
shopt -s globstar 2>/dev/null    # ** matches recursively
shopt -s cdspell                 # autocorrect cd typos
shopt -s autocd 2>/dev/null      # type dir name to cd
shopt -s dirspell 2>/dev/null    # autocorrect dir names in completion
shopt -s checkwinsize            # update LINES/COLUMNS after each command
shopt -s nocaseglob              # case-insensitive globbing
shopt -s cmdhist                 # save multi-line commands as one

# ══════════════════════════════════════════
# Environment
# ══════════════════════════════════════════
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="less"
export LESS="-FRX"
export LANG="C.utf8"
export LC_ALL="C.utf8"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# ══════════════════════════════════════════
# Path additions
# ══════════════════════════════════════════
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/go/bin" ]] && PATH="$HOME/go/bin:$PATH"

# ══════════════════════════════════════════
# Git prompt support
# ══════════════════════════════════════════
# Try to source git-prompt.sh for __git_ps1
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
elif [ -f /usr/lib/git-core/git-sh-prompt ]; then
    source /usr/lib/git-core/git-sh-prompt
elif [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
elif [ -f /etc/bash_completion.d/git-prompt ]; then
    source /etc/bash_completion.d/git-prompt
fi

# Bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# ══════════════════════════════════════════
# Two-line prompt via PROMPT_COMMAND
# ══════════════════════════════════════════
# ┌─[zach@host]─[🐍 venv]─[⭐ main *+]─[~/projects/myapp]─[✘ 130]
# └─❯

__dotfiles_git_info() {
    # Check if we're in a git repo
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [ -z "$branch" ] && return

    local flags=""
    local status
    status=$(git status --porcelain 2>/dev/null)

    # Unstaged changes
    echo "$status" | grep -q '^.[MD]' && flags+="*"
    # Staged changes
    echo "$status" | grep -q '^[MADRC]' && flags+="+"
    # Untracked files
    echo "$status" | grep -q '^??' && flags+="?"
    # Stashes
    git stash list 2>/dev/null | grep -q . && flags+="$"

    if [ -n "$flags" ]; then
        echo "${branch} ${flags}"
    else
        echo "${branch}"
    fi
}

__dotfiles_prompt() {
    local last_exit=$?

    # Colors
    local reset='\[\e[0m\]'
    local bold='\[\e[1m\]'
    local dim='\[\e[2m\]'
    local c_user='\[\e[1;36m\]'     # bold cyan
    local c_host='\[\e[1;36m\]'     # bold cyan
    local c_dir='\[\e[1;34m\]'      # bold blue
    local c_git='\[\e[1;33m\]'      # bold yellow
    local c_venv='\[\e[1;32m\]'     # bold green
    local c_err='\[\e[1;31m\]'      # bold red
    local c_ok='\[\e[1;32m\]'       # bold green
    local c_bracket='\[\e[0;37m\]'  # white
    local c_line='\[\e[0;90m\]'     # dark gray

    # Start building prompt
    local line1="${c_line}┌─"

    # User@Host segment
    line1+="${c_bracket}[${c_user}\u${reset}@${c_host}\h${c_bracket}]${c_line}─"

    # Virtualenv segment (only if active)
    if [ -n "$VIRTUAL_ENV" ]; then
        local venv_name
        venv_name=$(basename "$VIRTUAL_ENV")
        line1+="${c_bracket}[${c_venv}🐍 ${venv_name}${c_bracket}]${c_line}─"
    fi

    # Conda segment
    if [ -n "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
        line1+="${c_bracket}[${c_venv}🐍 ${CONDA_DEFAULT_ENV}${c_bracket}]${c_line}─"
    fi

    # Git segment (only in repos)
    local git_info
    git_info=$(__dotfiles_git_info)
    if [ -n "$git_info" ]; then
        line1+="${c_bracket}[${c_git}⭐ ${git_info}${c_bracket}]${c_line}─"
    fi

    # Directory segment
    line1+="${c_bracket}[${c_dir}\w${c_bracket}]"

    # Error segment (only on non-zero exit)
    if [ $last_exit -ne 0 ]; then
        line1+="${c_line}─${c_bracket}[${c_err}✘ ${last_exit}${c_bracket}]"
    fi

    # Second line
    local line2="${c_line}└─"
    if [ $last_exit -eq 0 ]; then
        line2+="${c_ok}❯${reset} "
    else
        line2+="${c_err}❯${reset} "
    fi

    PS1="${line1}\n${line2}"
}

PROMPT_COMMAND='__dotfiles_prompt'

# Disable default virtualenv prompt modification
export VIRTUAL_ENV_DISABLE_PROMPT=1

# ══════════════════════════════════════════
# Source shared aliases and functions
# ══════════════════════════════════════════
# Resolve the real location of this .bashrc (follows symlinks)
_dotfiles_dir="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"

if [ -f "${_dotfiles_dir}/shell/aliases.sh" ]; then
    source "${_dotfiles_dir}/shell/aliases.sh"
fi
if [ -f "${_dotfiles_dir}/shell/functions.sh" ]; then
    source "${_dotfiles_dir}/shell/functions.sh"
fi
unset _dotfiles_dir

# Shell-specific reload alias
alias reload='source ~/.bashrc && echo "Bash config reloaded."'

# ══════════════════════════════════════════
# Tool integrations
# ══════════════════════════════════════════
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

# ══════════════════════════════════════════
# Local overrides (not tracked in dotfiles)
# ══════════════════════════════════════════
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
