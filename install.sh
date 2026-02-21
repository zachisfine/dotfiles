#!/usr/bin/env bash
# install.sh — Symlink dotfiles into $HOME with backup
# Part of ~/dotfiles
#
# Usage: ./install.sh
# Re-running is safe (idempotent).

set -euo pipefail

# ══════════════════════════════════════════
# Config
# ══════════════════════════════════════════
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
BACKUP_NEEDED=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

# ══════════════════════════════════════════
# Helpers
# ══════════════════════════════════════════
info()    { printf "${BLUE}[INFO]${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}[ OK ]${RESET}  %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error()   { printf "${RED}[ERR ]${RESET}  %s\n" "$*"; }

backup_file() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ "$BACKUP_NEEDED" = false ]; then
            mkdir -p "$BACKUP_DIR"
            BACKUP_NEEDED=true
        fi
        mv "$target" "$BACKUP_DIR/"
        warn "Backed up: $target → $BACKUP_DIR/$(basename "$target")"
    fi
}

link_file() {
    local src="$1"
    local dest="$2"

    # Skip if already correctly linked
    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
        success "Already linked: $dest"
        return
    fi

    # Backup existing file
    backup_file "$dest"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    ln -sf "$src" "$dest"
    success "Linked: $dest → $src"
}

# ══════════════════════════════════════════
# Banner
# ══════════════════════════════════════════
echo
printf "${BOLD}╔══════════════════════════════════════════╗${RESET}\n"
printf "${BOLD}║        Dotfiles Installer                ║${RESET}\n"
printf "${BOLD}╚══════════════════════════════════════════╝${RESET}\n"
echo
info "Dotfiles directory: $DOTFILES_DIR"
echo

# ══════════════════════════════════════════
# Create symlinks
# ══════════════════════════════════════════
printf "${BOLD}── Shell configs ──${RESET}\n"
link_file "$DOTFILES_DIR/bash/.bashrc"     "$HOME/.bashrc"
link_file "$DOTFILES_DIR/zsh/.zshrc"       "$HOME/.zshrc"

printf "\n${BOLD}── Fish shell ──${RESET}\n"
mkdir -p "$HOME/.config/fish/functions"
link_file "$DOTFILES_DIR/fish/config.fish"                  "$HOME/.config/fish/config.fish"
link_file "$DOTFILES_DIR/fish/functions/fish_prompt.fish"    "$HOME/.config/fish/functions/fish_prompt.fish"

printf "\n${BOLD}── Git ──${RESET}\n"
link_file "$DOTFILES_DIR/git/.gitconfig"   "$HOME/.gitconfig"

printf "\n${BOLD}── Vim ──${RESET}\n"
link_file "$DOTFILES_DIR/vim/.vimrc"       "$HOME/.vimrc"

printf "\n${BOLD}── Neovim ──${RESET}\n"
if command -v nvim &>/dev/null; then
    mkdir -p "$HOME/.config/nvim"
    link_file "$DOTFILES_DIR/nvim/init.lua"    "$HOME/.config/nvim/init.lua"
else
    warn "nvim not found — skipping init.lua"
fi

printf "\n${BOLD}── Nano ──${RESET}\n"
if command -v nano &>/dev/null; then
    link_file "$DOTFILES_DIR/nano/.nanorc"     "$HOME/.nanorc"
else
    warn "nano not found — skipping .nanorc"
fi

printf "\n${BOLD}── Readline ──${RESET}\n"
link_file "$DOTFILES_DIR/inputrc/.inputrc" "$HOME/.inputrc"

printf "\n${BOLD}── Multiplexers ──${RESET}\n"
if command -v tmux &>/dev/null; then
    link_file "$DOTFILES_DIR/tmux/.tmux.conf"    "$HOME/.tmux.conf"
else
    warn "tmux not found — skipping .tmux.conf"
fi
if command -v screen &>/dev/null; then
    link_file "$DOTFILES_DIR/screen/.screenrc"   "$HOME/.screenrc"
else
    warn "screen not found — skipping .screenrc"
fi

printf "\n${BOLD}── EditorConfig ──${RESET}\n"
link_file "$DOTFILES_DIR/editorconfig/.editorconfig" "$HOME/.editorconfig"

printf "\n${BOLD}── SSH ──${RESET}\n"
mkdir -p "$HOME/.ssh/sockets"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/sockets"
link_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
success "Created ~/.ssh/sockets (mode 700)"

printf "\n${BOLD}── wget ──${RESET}\n"
if command -v wget &>/dev/null; then
    link_file "$DOTFILES_DIR/wget/.wgetrc" "$HOME/.wgetrc"
else
    warn "wget not found — skipping .wgetrc"
fi

printf "\n${BOLD}── Starship prompt ──${RESET}\n"
if command -v starship &>/dev/null; then
    mkdir -p "$HOME/.config"
    link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
else
    warn "starship not found — skipping starship.toml"
fi

printf "\n${BOLD}── ripgrep ──${RESET}\n"
if command -v rg &>/dev/null; then
    link_file "$DOTFILES_DIR/ripgrep/.ripgreprc" "$HOME/.ripgreprc"
else
    warn "rg not found — skipping .ripgreprc"
fi

printf "\n${BOLD}── bat ──${RESET}\n"
if command -v bat &>/dev/null || command -v batcat &>/dev/null; then
    mkdir -p "$HOME/.config/bat"
    link_file "$DOTFILES_DIR/bat/config" "$HOME/.config/bat/config"
else
    warn "bat/batcat not found — skipping bat config"
fi

printf "\n${BOLD}── htop ──${RESET}\n"
if command -v htop &>/dev/null; then
    mkdir -p "$HOME/.config/htop"
    link_file "$DOTFILES_DIR/htop/htoprc" "$HOME/.config/htop/htoprc"
else
    warn "htop not found — skipping htoprc"
fi

printf "\n${BOLD}── Alacritty ──${RESET}\n"
if command -v alacritty &>/dev/null; then
    mkdir -p "$HOME/.config/alacritty"
    link_file "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
else
    warn "alacritty not found — skipping alacritty.toml"
fi

printf "\n${BOLD}── lazygit ──${RESET}\n"
if command -v lazygit &>/dev/null; then
    mkdir -p "$HOME/.config/lazygit"
    link_file "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
else
    warn "lazygit not found — skipping lazygit config"
fi

printf "\n${BOLD}── direnv ──${RESET}\n"
if command -v direnv &>/dev/null; then
    mkdir -p "$HOME/.config/direnv"
    link_file "$DOTFILES_DIR/direnv/direnvrc" "$HOME/.config/direnv/direnvrc"
else
    warn "direnv not found — skipping direnvrc"
fi

# ══════════════════════════════════════════
# Create vim directories
# ══════════════════════════════════════════
printf "\n${BOLD}── Vim directories ──${RESET}\n"
mkdir -p "$HOME/.vim/undodir" "$HOME/.vim/swap"
success "Created ~/.vim/undodir and ~/.vim/swap"

# ══════════════════════════════════════════
# Summary
# ══════════════════════════════════════════
echo
if [ "$BACKUP_NEEDED" = true ]; then
    warn "Backups saved to: $BACKUP_DIR"
fi
printf "${GREEN}${BOLD}✓ Dotfiles installed successfully!${RESET}\n"
echo
info "Reload your shell to apply changes:"
info "  exec bash    # for bash"
info "  exec zsh     # for zsh"
info "  exec fish    # for fish"
echo
