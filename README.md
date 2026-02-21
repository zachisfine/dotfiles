# dotfiles

Personal configuration files for bash, zsh, fish, and a suite of CLI tools. One command symlinks everything into place with automatic backup of existing files.

## Quick start

```bash
git clone https://github.com/YOUR_USER/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
exec bash  # or exec zsh / exec fish
```

Re-running `install.sh` is safe and idempotent. Existing files are backed up to `~/.dotfiles_backup/<timestamp>/` before being replaced.

## What's included

| Config | File(s) | Destination | Condition |
|---|---|---|---|
| **Bash** | `bash/.bashrc` | `~/.bashrc` | always |
| **Zsh** | `zsh/.zshrc` | `~/.zshrc` | always |
| **Fish** | `fish/config.fish`, `fish/functions/fish_prompt.fish` | `~/.config/fish/` | always |
| **Git** | `git/.gitconfig` | `~/.gitconfig` | always |
| **Vim** | `vim/.vimrc` | `~/.vimrc` | always |
| **Neovim** | `nvim/init.lua` | `~/.config/nvim/init.lua` | `nvim` installed |
| **Nano** | `nano/.nanorc` | `~/.nanorc` | `nano` installed |
| **Readline** | `inputrc/.inputrc` | `~/.inputrc` | always |
| **tmux** | `tmux/.tmux.conf` | `~/.tmux.conf` | `tmux` installed |
| **GNU Screen** | `screen/.screenrc` | `~/.screenrc` | `screen` installed |
| **EditorConfig** | `editorconfig/.editorconfig` | `~/.editorconfig` | always |
| **SSH** | `ssh/config` | `~/.ssh/config` | always |
| **wget** | `wget/.wgetrc` | `~/.wgetrc` | `wget` installed |
| **Starship** | `starship/starship.toml` | `~/.config/starship.toml` | `starship` installed |
| **ripgrep** | `ripgrep/.ripgreprc` | `~/.ripgreprc` | `rg` installed |
| **bat** | `bat/config` | `~/.config/bat/config` | `bat` or `batcat` installed |
| **htop** | `htop/htoprc` | `~/.config/htop/htoprc` | `htop` installed |
| **Alacritty** | `alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` | `alacritty` installed |
| **lazygit** | `lazygit/config.yml` | `~/.config/lazygit/config.yml` | `lazygit` installed |
| **direnv** | `direnv/direnvrc` | `~/.config/direnv/direnvrc` | `direnv` installed |
| **curl** | `curl/.curlrc` | `~/.curlrc` | `curl` installed |
| **less** | `less/.lesskey` | `~/.lesskey` | always |
| **npm** | `npm/.npmrc` | `~/.npmrc` | `npm` installed |
| **pip** | `pip/pip.conf` | `~/.config/pip/pip.conf` | `pip3` or `pip` installed |
| **psql** | `psql/.psqlrc` | `~/.psqlrc` | `psql` installed |
| **Global gitignore** | `git/.gitignore_global` | `~/.gitignore_global` | always |
| **GnuPG** | `gpg/gpg.conf` | `~/.gnupg/gpg.conf` | `gpg` installed |
| **GitHub CLI** | `gh/config.yml` | `~/.config/gh/config.yml` | `gh` installed |
| **Docker** | `docker/config.json` | `~/.docker/config.json` | `docker` installed |
| **tig** | `tig/.tigrc` | `~/.tigrc` | `tig` installed |
| **Python REPL** | `python/.pythonrc` | `~/.pythonrc` | `python3` installed |
| **SQLite** | `sqlite/.sqliterc` | `~/.sqliterc` | `sqlite3` installed |

Shared shell code lives in `shell/aliases.sh` and `shell/functions.sh`, sourced by both bash and zsh.

## Repository layout

```
dotfiles/
├── install.sh                 # Symlink installer (idempotent)
├── bash/.bashrc               # Bash config
├── zsh/.zshrc                 # Zsh config
├── fish/
│   ├── config.fish            # Fish config
│   └── functions/
│       └── fish_prompt.fish   # Two-line prompt for fish
├── shell/
│   ├── aliases.sh             # Shared aliases (bash + zsh)
│   └── functions.sh           # Shared functions (bash + zsh)
├── git/
│   ├── .gitconfig             # Git config
│   └── .gitignore_global      # Global gitignore patterns
├── vim/.vimrc                 # Vim config
├── nvim/init.lua              # Neovim config (Lua)
├── nano/.nanorc               # Nano config
├── inputrc/.inputrc           # Readline config
├── tmux/.tmux.conf            # tmux config
├── screen/.screenrc           # GNU Screen config
├── editorconfig/.editorconfig # EditorConfig
├── ssh/config                 # SSH client config
├── wget/.wgetrc               # wget config
├── starship/starship.toml     # Starship prompt config
├── ripgrep/.ripgreprc         # ripgrep config
├── bat/config                 # bat config
├── htop/htoprc                # htop config
├── alacritty/alacritty.toml   # Alacritty terminal config
├── lazygit/config.yml         # lazygit config
├── direnv/direnvrc            # direnv layout functions
├── curl/.curlrc               # curl defaults
├── less/.lesskey              # less key bindings
├── npm/.npmrc                 # npm defaults
├── pip/pip.conf               # pip defaults
├── psql/.psqlrc               # PostgreSQL client config
├── gpg/gpg.conf               # GnuPG config
├── gh/config.yml              # GitHub CLI config
├── docker/config.json         # Docker client config
├── tig/.tigrc                 # tig config
├── python/.pythonrc           # Python REPL startup
└── sqlite/.sqliterc           # SQLite3 defaults
```

## Shell features

All three shells (bash, zsh, fish) share a consistent experience:

- **Two-line prompt** showing `user@host`, git branch/status, virtualenv, working directory, and last exit code
- **Starship** integration (auto-detected; falls back to the built-in prompt if not installed)
- **direnv** hooks for automatic environment loading
- **Smart aliases** for `ls` (uses `eza` if available), `cat` (uses `bat` if available), and safety nets (`rm -i`, `mv -i`, `cp -i`)
- **Git shortcuts** (`gs`, `ga`, `gc`, `gd`, `gl`, `gp`, etc.)
- **Shared functions**: `extract` (any archive), `mkcd`, `cheat`, `weather`, `sysinfo`, `backup`, `tre`, `up`, `port`, `note`
- **fzf** integration with `FZF_DEFAULT_OPTS` and `FZF_DEFAULT_COMMAND` (uses `fd` if available)
- **WSL clipboard** support auto-detected

## Highlights by config

### Git

Rebase-by-default pulls, histogram diff algorithm, `diff3` merge conflicts, `rerere` enabled. Includes aliases like `git lg` (graph log), `git wip` (quick save), `git undo` (soft reset last commit), and `git cleanup` (delete merged branches). Local overrides via `~/.gitconfig.local`.

### Vim / Neovim

Sensible defaults with relative line numbers, persistent undo, and system clipboard. Neovim uses a Lua config (`init.lua`).

### tmux

Prefix remapped to `Ctrl+a`. Vim-style pane navigation (`hjkl`), intuitive splits (`|` and `-`), vi copy mode with system clipboard integration (X11, Wayland, WSL).

### Starship

Replicates the built-in two-line prompt style using Catppuccin Mocha colors. Disables noisy language-version modules to keep the prompt fast and clean.

### Alacritty

Full Catppuccin Mocha 16-color palette, `monospace` font at size 12, 10k scrollback, hides mouse while typing.

### lazygit

Catppuccin Mocha border/highlight colors, mouse enabled, auto-fetch and auto-refresh.

### SSH

Connection multiplexing via `ControlMaster` (sockets in `~/.ssh/sockets/`), keepalive every 60s, `AddKeysToAgent`, `IdentitiesOnly`. Local overrides via `~/.ssh/config.local` (`Include` at top).

### ripgrep

Smart-case search, follows symlinks, searches hidden files. Ignores `.git/`, `node_modules/`, `__pycache__/`, `vendor/`, build output, and lock files.

### bat

Catppuccin Mocha theme, line numbers + git change markers. Aliased as `cat` (no paging) and `catp` (with paging) across all shells.

### direnv

Custom layout functions: `layout python` (auto-creates `.venv`), `layout node` (reads `.nvmrc`), `layout poetry` (uses Poetry virtualenv).

### curl

Follow redirects, connection timeouts, retry transient failures, prefer HTTPS.

### GnuPG

Strong digest preferences (SHA-512), long key IDs with fingerprints, `hkps://keys.openpgp.org` keyserver, privacy flags (no version, no comments). The installer sets `~/.gnupg` to mode 700.

### pip

`require-virtualenv = true` prevents accidental global installs — `pip install` only works inside an activated virtualenv.

### Python REPL

Tab completion and persistent history (`~/.python_history`) via the `PYTHONSTARTUP` env var. Loaded automatically in all three shells.

### Global gitignore

OS junk (`.DS_Store`, `Thumbs.db`), editor temps (`.idea/`, `.vscode/`, `*.swp`), `.env` files, `__pycache__/`, and `node_modules/` are excluded from every repo via `core.excludesFile`.

### EditorConfig

4-space indent / UTF-8 / LF by default. 2-space for web files (`js`, `ts`, `css`, `html`, `json`, `yaml`). Tabs for `Makefile` and Go.

## Local overrides

Most configs support a local override file that is **not tracked** in the repo:

| Config | Override file |
|---|---|
| Bash | `~/.bashrc.local` |
| Zsh | `~/.zshrc.local` |
| Fish | `~/.config/fish/local.fish` |
| Git | `~/.gitconfig.local` |
| SSH | `~/.ssh/config.local` |

Use these for machine-specific settings (credentials, work email, host-specific SSH keys, etc.).

## CI

[![CI](../../actions/workflows/ci.yml/badge.svg)](../../actions/workflows/ci.yml)

Every push and pull request runs four parallel checks via GitHub Actions:

| Job | What it does |
|---|---|
| **lint** | ShellCheck on bash scripts, `fish --no-execute` on fish files |
| **validate-configs** | TOML (`taplo`), YAML (`yamllint`), JSON, and EditorConfig (`ec`) validation |
| **install-test** | End-to-end `install.sh` on Ubuntu — symlinks, permissions, idempotency, shell parse |
| **install-test-macos** | Same install verification on macOS (`macos-latest`) |

## Requirements

- **bash** (for `install.sh`)
- **git** (to clone)
- **GNU coreutils** on macOS (`brew install coreutils`) — needed for `readlink -f` used by the installer
- Everything else is optional; the installer skips configs for tools that aren't found on the system.

## Uninstalling

The installer only creates symlinks. To undo, delete the symlinks and restore from `~/.dotfiles_backup/` if needed:

```bash
rm ~/.bashrc ~/.zshrc ~/.gitconfig  # etc.
cp ~/.dotfiles_backup/<timestamp>/.bashrc ~/  # restore backup
```
