---
description: Environment init and install application.
icon: bullseye-arrow
---

# Environment

[![make-test](https://github.com/logic3579/environment/actions/workflows/make-test.yml/badge.svg)](https://github.com/logic3579/environment/actions/workflows/make-test.yml)

Personal dotfiles, Homebrew packages, application configs, and utility scripts. Driven by a single `Makefile` — bootstrap a fresh machine (macOS / Debian / Fedora) with a few targets.

## Quick Start

```bash
# macOS / Linux — bootstrap deps, install Homebrew packages, link dotfiles, clean
make all

# Pick your shell framework
make zsh        # oh-my-zsh + plugins, link ~/.zshrc
make bash       # oh-my-bash, link ~/.bashrc

# AI coding agent configs (Claude Code / Codex / Kimi CLI / OpenCode / Pi)
make coding_agent_config
```

> Pick a Brewfile: defaults are `homebrew/Brewfile` (macOS) and `homebrew/Brewfile-linux` (Linux). Override with `make install BREWFILE=$(pwd)/homebrew/Brewfile-work` for DevOps-heavy macOS work setup.

## Makefile Targets

Run `make help` for the live list. Current targets:

| Target                | Description                                                                |
| --------------------- | -------------------------------------------------------------------------- |
| `all`                 | `test` → `install` → `xdg_config` → `clean`                                |
| `install`             | Install packages via `brew bundle` (Brewfile on macOS, Brewfile-linux on Linux) |
| `dependencies`        | Install Homebrew + bootstrap system packages on Linux (build tools, fontconfig, …) |
| `xdg_config`          | Symlink tmux / nvim / vim / wezterm / ghostty to `~/.config`               |
| `bash`                | Install oh-my-bash, link `~/.bashrc`                                       |
| `zsh`                 | Install oh-my-zsh + autosuggestions + syntax-highlighting, link `~/.zshrc` |
| `coding_agent_config` | Symlink Claude / Codex / Kimi / OpenCode / Pi configs                      |
| `clean`               | Remove broken symlinks under `~/.config`                                   |
| `test`                | Print resolved Makefile variables                                          |

## Project Layout

```
.
├── Makefile                # Entry point — run `make help` for targets
├── homebrew/               # Homebrew package manifests
│   ├── Brewfile            # Default environment (macOS)
│   ├── Brewfile-work       # Work environment — DevOps tooling (macOS)
│   └── Brewfile-linux      # Linux-portable subset (formulae only, no casks)
├── dotfiles/               # Symlinked to ~/.config/ or $HOME
│   ├── tmux/               # tmux.conf — prefix C-z, catppuccin macchiato
│   ├── nvim/               # Neovim — lazy.nvim, LSP, treesitter, fzf-lua
│   ├── vim/                # Vim — Vundle, fallback editor
│   ├── wezterm/            # WezTerm terminal
│   ├── ghostty/            # Ghostty terminal
│   ├── zshrc               # Zsh — oh-my-zsh + autosuggestions + syntax-highlighting
│   ├── bashrc              # Bash — oh-my-bash, cross-platform (macOS + Linux)
│   ├── claude/             # Claude Code — settings.json
│   ├── codex/              # Codex CLI — config.toml, env.example
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

Files under `appfiles/` are manual backups — restore by importing or copying them into the respective app:

| File                                    | App                          |
| --------------------------------------- | ---------------------------- |
| `appfiles/autokey.ahk`                  | AutoHotkey v2 (Windows only) |
| `appfiles/follow.opml`                  | Folo / RSS reader            |
| `appfiles/Preferences.sublime-settings` | Sublime Text                 |
| `appfiles/Raycast.rayconfig`            | Raycast                      |
| `appfiles/vscode.settings.json`         | Visual Studio Code           |
| `appfiles/ZeroOmegaOptions.json`        | SwitchyOmega / ZeroOmega     |

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
- **Daily-driver platform**: macOS (Apple Silicon, Homebrew at `/opt/homebrew/`); Linux (Debian / Fedora) also goes through Homebrew via `homebrew/Brewfile-linux` after a small bootstrap layer (`build-essential`, `fontconfig`, etc.)

## References

1. [Homebrew](https://brew.sh) · [USTC Mirror](https://mirrors.ustc.edu.cn/help/brew.git.html)
2. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) · [oh-my-bash](https://github.com/ohmybash/oh-my-bash)
3. [Vim Awesome](https://vimawesome.com/) · [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)
4. [Nerd Fonts](https://www.nerdfonts.com/)
