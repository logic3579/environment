---
description: Environment init and install application.
icon: bullseye-arrow
---

# Environment

[![make-test](https://github.com/logic3579/environment/actions/workflows/make-test.yml/badge.svg)](https://github.com/logic3579/environment/actions/workflows/make-test.yml)

Personal dotfiles, Homebrew packages, application configs, and utility scripts. Driven by a single `Makefile` — bootstrap a fresh machine (macOS / Debian / Fedora) with a few targets.

## Quick Start

```bash
# macOS — install Homebrew packages from Brewfile, link dotfiles, clean broken symlinks
make all

# Pick your shell framework
make zsh        # oh-my-zsh + plugins, link ~/.zshrc
make bash       # oh-my-bash, link ~/.bashrc

# AI coding agent configs (AtomCode / Claude Code / Codex / Gemini CLI / Kimi CLI / OpenCode / Pi)
make coding_agent_config
```

> Work environment: `brew bundle --file=Brewfile-work` for DevOps-heavy tooling (k8s, helm, argocd, ...).

## Makefile Targets

Run `make help` for the live list. Current targets:

| Target                | Description                                                                |
| --------------------- | -------------------------------------------------------------------------- |
| `all`                 | `test` → `install` → `xdg_config` → `clean`                                |
| `install`             | Install packages (Brewfile on macOS, apt/dnf on Linux)                     |
| `dependencies`        | Install Homebrew (macOS) / `fonts-powerline` (Linux)                       |
| `xdg_config`          | Symlink tmux / nvim / vim / wezterm / ghostty to `~/.config`               |
| `bash`                | Install oh-my-bash, link `~/.bashrc`                                       |
| `zsh`                 | Install oh-my-zsh + autosuggestions + syntax-highlighting, link `~/.zshrc` |
| `coding_agent_config` | Symlink AtomCode / Claude / Codex / Gemini / Kimi / OpenCode / Pi configs  |
| `clean`               | Remove broken symlinks under `~/.config`                                   |
| `test`                | Print resolved Makefile variables                                          |

## Project Layout

```
.
├── Makefile                # Entry point — run `make help` for targets
├── Brewfile                # Homebrew packages (default)
├── Brewfile-work           # Homebrew packages (work / DevOps)
├── dotfiles/               # Symlinked to ~/.config/ or $HOME
│   ├── tmux/               # tmux.conf — prefix C-z, catppuccin macchiato
│   ├── nvim/               # Neovim — lazy.nvim, LSP, treesitter, fzf-lua
│   ├── vim/                # Vim — Vundle, fallback editor
│   ├── wezterm/            # WezTerm terminal
│   ├── ghostty/            # Ghostty terminal
│   ├── zshrc               # Zsh — oh-my-zsh + autosuggestions + syntax-highlighting
│   ├── bashrc              # Bash — oh-my-bash, cross-platform (macOS + Linux)
│   ├── atomcode/           # AtomCode — config.toml
│   ├── claude/             # Claude Code — settings.json
│   ├── codex/              # Codex CLI — config.toml, env.example
│   ├── gemini/             # Gemini CLI — settings.json
│   ├── kimi/               # Kimi CLI — config.toml, env.example
│   ├── opencode/           # OpenCode — opencode.json, oh-my-openagent.json
│   ├── pi/                 # Pi agent — settings.json, openai-proxy.ts
│   └── pgpass              # libpq password template (manual install)
├── appfiles/               # Manual app-config backups (not symlinked)
├── scripts/                # Utility scripts (shell / python / go)
└── .github/workflows/      # CI — make test + ShellCheck
```

## PostgreSQL Credentials

`dotfiles/pgpass` is a manual template for the libpq password file. Not symlinked by `make` — install by hand when needed:

```bash
cp dotfiles/pgpass ~/.pgpass
chmod 600 ~/.pgpass   # libpq requires owner-only permissions
```

Format per line: `hostname:port:database:username:password` (use `*` as a wildcard).

## Application Config Backups

Files under `appfiles/` are manual backups — restore by importing them into the respective app:

| File                                    | App                      |
| --------------------------------------- | ------------------------ |
| `appfiles/follow.opml`                  | Folo / RSS reader        |
| `appfiles/Preferences.sublime-settings` | Sublime Text             |
| `appfiles/Raycast.rayconfig`            | Raycast                  |
| `appfiles/SecureCRT.xml`                | SecureCRT                |
| `appfiles/vscode.settings.json`         | Visual Studio Code       |
| `appfiles/ZeroOmegaOptions.bak`         | SwitchyOmega / ZeroOmega |

## Scripts

| Script                         | Purpose                            |
| ------------------------------ | ---------------------------------- |
| `scripts/decorate-requests.py` | Python request decorator           |
| `scripts/generate-secret.sh`   | Random password + SHA256           |
| `scripts/getcdn-realip.go`     | Resolve real IP behind a CDN       |
| `scripts/helm-middleware.sh`   | Helm middleware utility            |
| `scripts/trash.sh`             | Safe delete — move to system Trash |

## Conventions

- **Commits**: [Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): description`
- **Shell scripts**: `#!/bin/bash` + `set -euo pipefail`, POSIX `name() {` function style
- **Symlinks**: `ln -svF` into `~/.config/<app>/`
- **Daily-driver platform**: macOS (Apple Silicon, Homebrew at `/opt/homebrew/`); Linux paths are supported in `install` only

## References

1. [Homebrew](https://brew.sh) · [USTC Mirror](https://mirrors.ustc.edu.cn/help/brew.git.html)
2. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) · [oh-my-bash](https://github.com/ohmybash/oh-my-bash)
3. [Vim Awesome](https://vimawesome.com/) · [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)
4. [Nerd Fonts](https://www.nerdfonts.com/)
