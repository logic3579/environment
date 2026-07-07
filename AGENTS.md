# AGENTS.md

Personal dotfiles, Homebrew packages, app configs, and utility scripts.
Not a software project — a machine bootstrap repo driven by a single `Makefile`.

## What agents must know

- **Cross-platform**: macOS (daily driver, Apple Silicon, `/opt/homebrew`) and Linux (Debian/Fedora). Shell configs (`zshrc`, `bashrc`) probe Homebrew paths — never hardcode `/opt/homebrew`.
- **CI**: `make test` + ShellCheck on `scripts/*.sh`. Runs on push to `main` only.
- **Commits**: [Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): description`. Common scopes: `tmux`, `nvim`, `brew`, `zsh`, `shell`, `opencode`.

## Commands

```bash
make all        # test → install → xdg_config → clean (full bootstrap)
make test       # print resolved Makefile variables (also CI verification)
make install    # brew bundle (Brewfile per OS; override: BREWFILE=path)
make zsh        # oh-my-zsh + Powerlevel10k + plugins + symlink ~/.zshrc ~/.p10k.zsh
make bash       # oh-my-bash + symlink ~/.bashrc
make coding_agent_config  # symlink claude/codex/opencode/pi configs
make aws_config # symlink ~/.aws/config
make clean      # remove broken symlinks in ~/.config
```

## Architecture

```
Makefile          ← entry point, everything flows through here
homebrew/         ← Brewfile (macOS default), Brewfile-work (macOS DevOps), Brewfile-linux (no casks)
dotfiles/          ← symlinked to ~/.config or ~/ (by make targets)
  nvim/           ← lazy.nvim, LSP, treesitter, fzf-lua  (init.lua → config/* → plugins/*)
  tmux/tmux.conf  ← prefix C-z, catppuccin macchiato v2.3.0, TPM plugins
  zshrc/          ← zshrc + p10k.zsh, linked to ~/.zshrc and ~/.p10k.zsh
  bashrc/         ← bashrc, linked to ~/.bashrc
  opencode/       ← opencode.json + oh-my-openagent.json (agent→model mapping)
  aws/config      ← AWS CLI config (SSO profiles)
scripts/           ← misc utilities (bash/py/go), CI-linted via ShellCheck
appfiles/          ← manual app config backups, not symlinked
```

## Shell conventions

- `#!/bin/bash` with `set -euo pipefail` for all scripts.
- Shell completion caches at `~/.cache/{zsh,bash}-{kubectl,helm,cf,limactl,colima}-completion` — regenerated weekly via `find -mtime +7`. Delete to force refresh.
- `cf` = Cloudflare CLI, installed via `bun install -g cf` → `~/.bun/bin`.
- fzf integration trails zshrc/bashrc (`eval "$(fzf --{zsh,bash})"`) — independent from nvim's fzf-lua.
- zsh prompt uses Powerlevel10k (`powerlevel10k/powerlevel10k`); repo stores config as `dotfiles/zshrc/p10k.zsh`, linked by `make zsh` to `~/.p10k.zsh`.
- nvm: zshrc loads official nvm (`~/.nvm`) first, then Homebrew nvm as fallback.
- PATH dedup: zsh uses `typeset -U PATH`, bash uses a final `awk` dedup.

## Brewfile strategy

- `homebrew/Brewfile` — macOS default. `homebrew/Brewfile-work` — DevOps extras (k8s, helm, argocd). `homebrew/Brewfile-linux` — formulae only, no casks.
- Shared packages exist independently in each file (no shared base).
- `make dependencies` bootstraps Linux: system pkgs (build-essential/fontconfig/…) + Homebrew itself. Everything beyond bootstrap goes through `brew bundle`.

## Makefile symlink conventions

- `$(LN_DIR)` = `ln -svF` (macOS) or `ln -svfn` (Linux) — for directory symlinks.
- `$(LN_FILE)` = `ln -svf` on both platforms — for file symlinks.
- Shell rc targets remove existing managed symlinks before relinking (`~/.zshrc`, `~/.p10k.zsh`, `~/.bashrc`) so old file-to-directory migrations do not make `ln` treat the target as a directory.
- New targets: follow `coding_agent_config` body shape (echo start/end banners aligned with 3 trailing spaces on END, single `@mkdir -p` line, sorted symlink rows).

## Tmux gotchas

- **catppuccin v2 vs v0.3**: Config keys, module names, and `#{E:...}` double-expansion pattern changed. Never copy snippets from old tutorials. Check `~/.tmux/plugins/tmux/CHANGELOG.md` for version.
- **Plugin path**: `catppuccin/tmux` clones to `~/.tmux/plugins/tmux/` — a potential collision with other plugins named `tmux`.
- `set -g focus-events on` is required for nvim autoread/gitsigns refresh.

## Neovim notes

- Config load order: `init.lua` → `config/option` → `keymap` → `autocmd` → `lib` → `lazynvim` (loads `plugins/`).
- Format-on-save via conform.nvim: `stylua` (Lua), `gofmt` (Go), `ruff` (Python), `shfmt` (Bash), `taplo` (TOML), `prettier` (Markdown/JSON/YAML/JS).
- Treesitter requires `tree-sitter` CLI.
- Neovide GUI: Option key = Meta (`<M-...>`), `<D-=>`/`<D-->`/`<D-0>` for zoom.

## OpenCode config

This repo manages OpenCode config at `dotfiles/opencode/`:
- `opencode.json` — plugins: `opencode-dynamic-context-pruning`, `oh-my-openagent`.
- `oh-my-openagent.json` — agent → model mapping for all categories and sub-agents.
- Symlinked by `make coding_agent_config` to `~/.config/opencode/`.

## References

For detailed nvim key maps, LSP servers, plugin tables, tmux status bar layout, and full comment style conventions, see `CLAUDE.md`.
