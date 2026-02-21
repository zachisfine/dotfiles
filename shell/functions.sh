# ~/.dotfiles/shell/functions.sh
# Shared functions for bash and zsh

# --- extract: universal archive extractor ---
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "extract: '$1' is not a file"
        return 1
    fi
    case "$1" in
        *.tar.bz2)  tar xjf "$1"    ;;
        *.tar.gz)   tar xzf "$1"    ;;
        *.tar.xz)   tar xJf "$1"    ;;
        *.tar.zst)  tar --zstd -xf "$1" ;;
        *.bz2)      bunzip2 "$1"    ;;
        *.rar)      unrar x "$1"    ;;
        *.gz)       gunzip "$1"     ;;
        *.tar)      tar xf "$1"     ;;
        *.tbz2)     tar xjf "$1"    ;;
        *.tgz)      tar xzf "$1"    ;;
        *.zip)      unzip "$1"      ;;
        *.Z)        uncompress "$1" ;;
        *.7z)       7z x "$1"       ;;
        *.xz)       xz -d "$1"     ;;
        *.zst)      zstd -d "$1"   ;;
        *)          echo "extract: '$1' — unknown archive format" ;;
    esac
}

# --- mkcd: create directory and cd into it ---
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# --- cheat: query cheat.sh for command help ---
cheat() {
    if [ -z "$1" ]; then
        echo "Usage: cheat <command>"
        return 1
    fi
    curl -s "cheat.sh/$1"
}

# --- weather: show weather for a location ---
weather() {
    local location="${1:-}"
    curl -s "wttr.in/${location}?format=3"
    echo
}

# --- colors256: display terminal color palette ---
colors256() {
    for i in {0..255}; do
        printf "\x1b[38;5;%sm%3d " "$i" "$i"
        if (( (i + 1) % 16 == 0 )); then
            printf "\x1b[0m\n"
        fi
    done
    printf "\x1b[0m\n"
}

# --- backup: create a timestamped backup of a file ---
backup() {
    if [ -z "$1" ]; then
        echo "Usage: backup <file>"
        return 1
    fi
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    cp -a "$1" "${1}.bak.${timestamp}"
    echo "Backed up: $1 → ${1}.bak.${timestamp}"
}

# --- gitignore: fetch .gitignore template from gitignore.io ---
gitignore() {
    if [ -z "$1" ]; then
        echo "Usage: gitignore <language,...>"
        echo "Example: gitignore python,node,macos"
        return 1
    fi
    curl -sL "https://www.toptal.com/developers/gitignore/api/$1"
}

# --- sysinfo: quick system summary ---
sysinfo() {
    echo "╔══════════════════════════════════════╗"
    echo "║          System Information          ║"
    echo "╠══════════════════════════════════════╣"
    printf "║ %-12s %s\n" "Hostname:" "$(hostname)"
    printf "║ %-12s %s\n" "User:" "$(whoami)"
    printf "║ %-12s %s\n" "Kernel:" "$(uname -r)"
    printf "║ %-12s %s\n" "Uptime:" "$(uptime -p 2>/dev/null || uptime)"
    printf "║ %-12s %s\n" "Shell:" "$SHELL"
    if command -v free &>/dev/null; then
        printf "║ %-12s %s\n" "Memory:" "$(free -h | awk '/^Mem:/{print $3 "/" $2}')"
    fi
    printf "║ %-12s %s\n" "Disk (/):" "$(df -h / | awk 'NR==2{print $3 "/" $2 " (" $5 ")"}')"
    echo "╚══════════════════════════════════════╝"
}

# --- tre: tree with sensible defaults, ignore common dirs ---
tre() {
    tree -aC -I '.git|node_modules|__pycache__|.venv|venv|.mypy_cache' \
        --dirsfirst "${@:-.}" | less -FRX
}

# --- up: go up N directories ---
up() {
    local count="${1:-1}"
    local path=""
    for ((i = 0; i < count; i++)); do
        path+="../"
    done
    cd "$path" || return
}

# --- prettypath: pretty-print PATH ---
prettypath() {
    echo "${PATH}" | tr ':' '\n' | nl
}

# --- take: create dir, cd into it (alias for mkcd) ---
take() {
    mkcd "$@"
}

# --- port: show what's running on a port ---
port() {
    if [ -z "$1" ]; then
        echo "Usage: port <number>"
        return 1
    fi
    ss -tulnp | grep ":$1 " || echo "Nothing found on port $1"
}

# --- note: quick notes to a file ---
note() {
    local notefile="$HOME/.notes"
    if [ -z "$1" ]; then
        cat "$notefile" 2>/dev/null || echo "No notes yet."
    else
        echo "$(date +"%Y-%m-%d %H:%M") — $*" >> "$notefile"
        echo "Note added."
    fi
}
