# Environment

Personal dotfiles, application configs, Homebrew packages, and utility scripts.

## Project Structure

```
.
├── Makefile                 # Main entry: install, link, clean
├── Brewfile                 # Homebrew packages (default)
├── Brewfile-hk              # Homebrew packages (HK environment)
├── dotfiles/
│   ├── tmux/tmux.conf       # tmux config (prefix: C-z)
│   ├── nvim/                # Neovim config (LazyVim-based)
│   │   ├── init.lua
│   │   └── lua/{config,plugins}/
│   ├── vim/vimrc            # Vim config (Vundle)
│   ├── wezterm/wezterm.lua  # WezTerm terminal config
│   ├── ghostty/config       # Ghostty terminal config
│   ├── zshrc                # Zsh config (oh-my-zsh)
│   └── bashrc               # Bash config (oh-my-bash)
├── appfiles/                # Application config backups
├── scripts/
│   ├── trash.sh             # Safe delete (move to system trash)
│   ├── generate-secret.sh   # Random password + SHA256 generator
│   └── tmux-network-speed.sh # tmux status bar network speed
└── .github/workflows/       # CI: make test + ShellCheck
```

## Conventions

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/): `type(scope): description`
- Common types: `chore`, `fix`, `style`, `feat`
- Common scopes: `tmux`, `nvim`, `brew`, `zsh`

### Comment Style
- **Shell scripts**: English comments, POSIX function style `name() {`
- **tmux.conf**: Section headers use `# -- section name ---...` (76 chars total)
- **zshrc**: Section headers use `# -------------------------` / `# Title` / `# -------------------------`
- **Commented-out code**: Always use `# ` with a space after `#`

### Makefile Targets
- `make install` — Install all packages (depends on `dependencies`)
- `make xdg_config` — Symlink dotfiles to `~/.config/`
- `make bash` / `make zsh` — Install shell framework and link rc file
- `make clean` — Remove broken symlinks in `~/.config/`
- `make test` — Print environment variables for verification
- `make help` — Show targets with `##` descriptions

### Two Brewfile Strategy
- `Brewfile` — Default environment packages
- `Brewfile-hk` — HK environment packages (more DevOps tools: k8s, helm, argocd, etc.)
- Shared packages exist in both files independently (no shared base file)

## Key Details
- macOS only for daily use (Apple Silicon, Homebrew at `/opt/homebrew/`)
- Dotfiles are symlinked via `ln -svF` to `~/.config/<app>/`
- tmux prefix key: `C-z`
- Terminal font: MesloLGLDZ Nerd Font, font size 17
- Color scheme: Solarized Dark (across terminals)
- Shell scripts target: `#!/bin/bash` with `set -euo pipefail`
