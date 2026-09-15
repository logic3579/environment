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

# AI coding agent configs (Claude Code / Codex / OpenCode / Pi)
make coding_agent_config
```

> Homebrew defaults to `macos` on macOS and `linux-common` on Linux / WSL. On a work Mac, use `make install BREW_ENV=macos-work` (or `make all BREW_ENV=macos-work`). Use `make dump` with the same environment to update its snapshot. See [Homebrew environments](homebrew/README.md) for commands and overrides.

All environments install JetBrains Mono Nerd Font through Homebrew; Linux also
refreshes the font cache after installation. Terminal configs use
`JetBrainsMono Nerd Font Mono`. For SSH, install and select the font on the client
machine; for a Windows-hosted WSL terminal, do so on Windows.

## Makefile Targets

Run `make help` for the live list. Current targets:

| Target                | Description                                                                |
| --------------------- | -------------------------------------------------------------------------- |
| `all`                 | `test` → `install` → `xdg_config` → `clean`                                |
| `install`             | Install packages via `brew bundle` (Brewfile-macos on macOS, Brewfile-linux-common on Linux) |
| `dump`                | Export installed packages to the selected Brewfile (overwrite)             |
| `dependencies`        | Install Homebrew + bootstrap system packages on Linux (build tools, fontconfig, …) |
| `xdg_config`          | Symlink alacritty / tmux / nvim / vim / wezterm / ghostty to `~/.config`               |
| `bash`                | Install oh-my-bash, link `~/.bashrc`                                       |
| `zsh`                 | Install oh-my-zsh + Powerlevel10k + plugins, link `~/.zshrc` and `~/.p10k.zsh` |
| `coding_agent_config` | Symlink Claude / Codex / OpenCode / Pi configs                      |
| `clean`               | Remove broken symlinks under `~/.config`                                   |
| `test`                | Print resolved Makefile variables                                          |

## Project Layout

```
.
├── Makefile                # Entry point — run `make help` for targets
├── homebrew/               # Homebrew package manifests
│   ├── Brewfile-macos           # Default environment (macOS)
│   ├── Brewfile-macos-work      # Work environment — DevOps tooling (macOS)
│   └── Brewfile-linux-common    # Linux / WSL environment snapshot
├── dotfiles/               # Symlinked to ~/.config/ or $HOME
│   ├── tmux/               # tmux.conf — prefix C-z, catppuccin macchiato
│   ├── nvim/               # Neovim — lazy.nvim, LSP, treesitter, fzf-lua
│   ├── vim/                # Vim — Vundle, fallback editor
│   ├── alacritty/          # Alacritty terminal
│   ├── wezterm/            # WezTerm terminal
│   ├── ghostty/            # Ghostty terminal
│   ├── zshrc               # Zsh — oh-my-zsh + autosuggestions + syntax-highlighting
│   ├── bashrc              # Bash — oh-my-bash, cross-platform (macOS + Linux)
│   ├── claude/             # Claude Code — settings.json
│   ├── codex/              # Codex CLI — config.toml, env.example
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
| `scripts/decorate-requests.py` | Incomplete requests API-wrapper example           |
| `scripts/generate-secret.sh`   | Random password + SHA256 / JWT secret |
| `scripts/getcdn-realip.go`     | Snapshot Cloudflare/CloudFront IP ranges       |
| `scripts/helm-middleware.sh`   | Helm middleware utility            |
| `scripts/trash.sh`             | Safe delete — move to system Trash |

## Project Conventions

[AGENTS.md](AGENTS.md) is the sole project convention file for AI agents, covering cross-platform bootstrap rules, config maintenance, and verification.

## References

1. [Homebrew](https://brew.sh) · [USTC Mirror](https://mirrors.ustc.edu.cn/help/brew.git.html)
2. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) · [oh-my-bash](https://github.com/ohmybash/oh-my-bash)
3. [Vim Awesome](https://vimawesome.com/) · [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim)
4. [Nerd Fonts](https://www.nerdfonts.com/)
