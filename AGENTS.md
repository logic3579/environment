# AGENTS.md

Personal dotfiles, Homebrew packages, app configs, and utility scripts.
Not a software project — a machine bootstrap repo driven by a single `Makefile`.

This is the sole project convention file for all AI agents. Maintain project-specific agent instructions here.

## What agents must know

- **Cross-platform**: macOS (daily driver, Apple Silicon, `/opt/homebrew`) and Linux (Debian/Fedora). Shell configs (`zshrc`, `bashrc`) probe Homebrew paths — never hardcode `/opt/homebrew`.
- **CI**: `make test` + ShellCheck on `scripts/*.sh`. Runs on Ubuntu on push to `main` only (`.github/workflows/make-test.yml`), with no PR trigger. `make test` only prints variables; it does not exercise scripts or configs.
- **Commits**: [Conventional Commits](https://www.conventionalcommits.org/) — `type(scope): description`. Common types: `chore`, `fix`, `style`, `feat`. Common scopes: `tmux`, `nvim`, `brew`, `zsh`, `shell`, `opencode`.

## Commands

```bash
make all        # test → install → xdg_config → clean (packages + editor/terminal setup)
make dependencies # Homebrew and Linux bootstrap packages
make test       # print resolved Makefile variables (also CI verification)
make install    # dependencies → brew bundle (BREW_ENV=macos|macos-work|linux-common; override: BREWFILE=path)
make dump       # overwrite selected environment snapshot; Linux/WSL adds --no-winget
make zsh        # oh-my-zsh + Powerlevel10k + plugins + symlink ~/.zshrc ~/.p10k.zsh
make bash       # oh-my-bash + symlink ~/.bashrc
make coding_agent_config  # symlink claude/codex/opencode/pi configs
make xdg_config  # symlink editor/terminal configs to ~/.config and install editor plugins
make help       # list targets with ## descriptions
make clean      # remove broken symlinks in ~/.config
```

`make all` does not run the shell or coding-agent targets; invoke them separately. Avoid `make -j all`: its prerequisites are not dependency-chained. Use `make -n <target>` to preview machine-changing commands.

## Architecture

```
.
├── Makefile                 # Main entry: install, link, clean
├── homebrew/
│   ├── Brewfile-macos           # Homebrew packages (default, macOS)
│   ├── Brewfile-macos-work      # Homebrew packages (Work environment, macOS)
│   └── Brewfile-linux-common    # Full Linux/WSL Homebrew bundle
├── dotfiles/
│   ├── tmux/tmux.conf       # tmux config (prefix: C-z)
│   ├── nvim/                # Neovim config (lazy.nvim plugin manager)
│   │   ├── init.lua         # Entry: loads config/* and bootstraps lazy.nvim
│   │   └── lua/
│   │       ├── config/      # Core config (option, keymap, autocmd, lib)
│   │       └── plugins/     # Plugin specs (lazy.nvim format)
│   ├── vim/vimrc            # Vim config (Vundle)
│   ├── wezterm/wezterm.lua  # WezTerm terminal config (cross-platform: macOS + Windows)
│   ├── alacritty/alacritty.toml # Alacritty terminal config (cross-platform: macOS + Windows)
│   ├── ghostty/config       # Ghostty terminal config
│   ├── claude/              # Claude Code config
│   │   ├── settings.json
│   │   └── env.example      # Provider/model environment template
│   ├── codex/               # Codex CLI config
│   │   ├── config.toml
│   │   └── env.example      # Manual provider environment examples
│   ├── opencode/            # OpenCode CLI config
│   │   ├── opencode.json
│   │   └── oh-my-openagent.json   # oh-my-openagent plugin: agents/categories → model mapping
│   ├── zshrc/               # Zsh config: zshrc + p10k.zsh (oh-my-zsh + Powerlevel10k)
│   ├── bashrc/              # Bash config: bashrc (oh-my-bash, cross-platform: macOS + Linux)
│   ├── pi/                 # settings.json + openai-proxy.ts
│   └── pgpass               # libpq password template (manual install — see README)
├── appfiles/                # Application config backups (manual; may include platform-specific files)
├── scripts/
│   ├── trash.sh             # Safe delete (move to system trash)
│   ├── generate-secret.sh   # Random password + SHA256 / JWT HMAC secret generator
│   ├── helm-middleware.sh   # Helm middleware utility
│   ├── decorate-requests.py # Incomplete requests API-wrapper example
│   └── getcdn-realip.go     # Cloudflare/CloudFront IP-range snapshot utility
└── .github/workflows/       # CI: make test + ShellCheck
```

## Shell conventions

- New Bash scripts use `#!/bin/bash`, `set -euo pipefail`, and `name() {` functions; keep compatibility with macOS system Bash 3.2 unless a newer Bash requirement is explicit. Existing `helm-middleware.sh` uses `set -e` + `pipefail` without nounset and still uses `function name()`; do not assume all legacy scripts already follow the convention.
- Shell completion caches at `~/.cache/{zsh,bash}-{kubectl,helm,cf,limactl,colima}-completion` — regenerated weekly via `find -mtime +7`. Delete to force refresh.
- `cf` = Cloudflare CLI, installed via `bun install -g cf` → `~/.bun/bin`.
- fzf integration runs near the end of each rc file (`source <(fzf --zsh)` in zsh, `eval "$(fzf --bash)"` in bash) — provides `Ctrl-R` history search, `Ctrl-T` file picker, and `Alt-C` cd; independent from nvim's fzf-lua.
- zsh prompt uses Powerlevel10k (`powerlevel10k/powerlevel10k`); repo stores config as `dotfiles/zshrc/p10k.zsh`, linked by `make zsh` to `~/.p10k.zsh`.
- Initialize Homebrew by probing `/opt/homebrew/bin/brew`, `/usr/local/bin/brew`, then `/home/linuxbrew/.linuxbrew/bin/brew`. Gate Brew paths on `[[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/..." ]]`.
- `~/.local/bin` is added by zshrc/bashrc after Homebrew initialization when present. Bash relies on the Bun PATH section to find `cf` in `~/.bun/bin`.
- On Linux, zshrc/bashrc add Homebrew's keg-only ICU library directory (`$HOMEBREW_PREFIX/opt/icu4c/lib`) to `LD_LIBRARY_PATH` when installed; this is required by .NET tools such as the Marksman Markdown LSP. Keep this Linux-only, preserve existing entries, and avoid duplicates when sourcing repeatedly.
- nvm: zshrc/bashrc load official nvm via `NVM_DIR="${NVM_DIR:-$HOME/.nvm}"` first, then `$HOMEBREW_PREFIX/opt/nvm` as fallback.
- AWS CLI: zshrc/bashrc enable `aws_completer` when present, set `AWS_PROFILE=default`, and set `AWS_PAGER=""`.
- PATH dedup: zsh uses `typeset -U PATH` after PATH setup and before loading `~/.p10k.zsh`; bash uses a final `awk` dedup before attaching ble.sh.

- Bash skips noninteractive sessions. Optional ble.sh loads from `~/.local/share/blesh/ble.sh` with `--attach=none` before oh-my-bash and attaches last; installation is manual and requires Bash 4+, unlike macOS system Bash 3.2.
- Both shell configs register installed Homebrew Docker Compose/Buildx binaries under `~/.docker/cli-plugins/`, using platform-specific symlink flags.
- Both expose Go, Bun, Rust, Java, database-client, and Mason executable paths when applicable. Keep Homebrew-dependent additions conditional.
- `setproxy` / `unsetproxy` manage proxy environment variables; `setbrew` / `unsetbrew` manage Homebrew mirrors. `singbox-dns-on/off` are macOS-only Wi-Fi DNS helpers.

## Comment style

- **Shell scripts**: English comments, POSIX function style `name() {`
- **tmux.conf**: Section headers use `# -- section name ---...` (currently 80 chars total)
- **zshrc**: Section headers use `# -------------------------` / `# Title` / `# -------------------------`
- **Commented-out code**: Always use `# ` with a space after `#`

## Brewfile strategy

- `homebrew/Brewfile-macos` — macOS default. `homebrew/Brewfile-macos-work` — DevOps extras (k8s, helm, argocd). `homebrew/Brewfile-linux-common` — full Linux/WSL bundle, including taps, formulae, supported casks, editor extensions, and language-installed tools.
- `install` and `dump` share `BREW_ENV`: defaults are `macos` on macOS and `linux-common` on Linux/WSL. Work Macs must select `BREW_ENV=macos-work`. Reject environments incompatible with the host OS. Explicit `BREWFILE` overrides the path.
- Dump only the current machine’s environment; Linux/WSL must use `--no-winget`. Dump overwrites the selected file: inspect the diff before committing. `dump` must not bootstrap or install packages.
- Commands and maintenance details: [homebrew/README.md](homebrew/README.md).
- Shared packages exist independently in each file (no shared base).
- **Linux bootstrap layer** (`make dependencies`): system pkgs required to install Homebrew itself plus font infra — Debian uses `build-essential procps curl file git fontconfig`, Fedora uses `gcc gcc-c++ make procps-ng curl file git fontconfig`. Everything beyond bootstrap (tmux, neovim, fzf, ripgrep, …) goes through `Brewfile-linux-common`. The Makefile and current Brewfiles do not install `zsh`; provision it with the system package manager before `make zsh` on Linux.

## Makefile symlink conventions

- `$(LN_DIR)` = `ln -svF` (macOS) or `ln -svfn` (Linux) — for directory symlinks.
- `$(LN_FILE)` = `ln -svf` on both platforms — for file symlinks.
- Shell rc targets remove existing managed symlinks before relinking (`~/.zshrc`, `~/.p10k.zsh`, `~/.bashrc`) so old file-to-directory migrations do not make `ln` treat the target as a directory.
- New targets follow `coding_agent_config` (also mirrored by `xdg_config`):
  - `##` description uses `Install <name> (item1 / item2 / ...)`.
  - Open with `@echo "##### Install <name> start #####"`; close with `@echo "##### Install <name> end   #####"` (three spaces after `end` align the banners).
  - Use one consolidated `@mkdir -p` line for parent directories.
  - Sort symlink rows alphabetically, use Makefile variables, and omit per-row `>>> X` echoes.

## Tmux config (`dotfiles/tmux/tmux.conf`)

### Plugins (via TPM)

| Plugin | Purpose |
| ------ | ------- |
| `tmux-plugins/tpm` | Plugin manager (auto-bootstrapped via `if "test ! -d ..."` block at bottom) |
| `tmux-plugins/tmux-resurrect` | Session save / restore |
| `tmux-plugins/tmux-cpu` | Provides `#{cpu_*}` / `#{ram_*}` format vars consumed by catppuccin's cpu and ram modules |
| `tmux-plugins/tmux-battery` | Provides `#{battery_*}` format vars consumed by catppuccin's battery module |
| `catppuccin/tmux#v2.3.0` | Theme + widget framework (pinned to v2.3.0; bumps require manually editing tag) |

### Status Bar Architecture

- Theme: **catppuccin macchiato** (`@catppuccin_flavor "macchiato"`). Visually deliberately different from the Solarized terminal + nvim palette — accepted color-clash.
- Window pill style: `@catppuccin_window_status_style "rounded"` (default; explicit for clarity).
- Position: top, left-justified (explicit `status-position` / `status-justify` settings).
- Widget composition is done via append-mode `set -ag`/`set -agF` on `status-left` and `status-right` referencing `#{E:@catppuccin_status_<name>}`. The `E:` prefix expands the format twice — needed for catppuccin to interpolate its color slots.
- **Left**: `session` only. Session module has a built-in prefix indicator (`#{?client_prefix,#{E:@thm_red},#{E:@thm_green}}`) — the session pill turns red when `C-z` is held; no separate prefix-highlight needed.
- **Right**: `cpu` → `ram` → `load` → `battery` → `date_time`. Each pill self-colors via theme slots (thm_yellow / thm_blue / thm_pink etc.).
- **Window pills**: `@catppuccin_window_text " #W"` + `@catppuccin_window_current_text " #W"` are explicitly set so the window LABEL (set by `rename-window` / `automatic-rename`) shows — catppuccin's default is `#T` (pane title), a different concept entirely. `@catppuccin_window_flags "icon"` enables Nerd Font glyphs for zoom/bell/activity flags.
- Module configs live in `~/.tmux/plugins/tmux/status/<name>.conf` after TPM clones the plugin; customize by setting `@catppuccin_<module>_*` vars BEFORE the TPM run line at the bottom of `tmux.conf`.

### Gotcha: catppuccin v2 vs v0.3 Syntax

catppuccin/tmux had a major rewrite at v2 — config keys, module names, and the `#{E:@catppuccin_status_*}` interpolation pattern all changed. **Do not copy snippets from old tutorials**; check the version against `~/.tmux/plugins/tmux/CHANGELOG.md`. v2 modules use `#{E:...}` (double expansion) — single `#{...}` will render literal text.

### Gotcha: Plugin Name Collision Under TPM

The catppuccin repo is `catppuccin/tmux`, which TPM clones to `~/.tmux/plugins/tmux/` (just `tmux`, owner stripped). Another plugin with the repository name `tmux` would collide with this directory; retain the path when inspecting installed modules.

### Input and navigation

- Prefix: `C-z`; prefix + `r` reloads the config. TPM: prefix + `I` installs, prefix + `U` updates plugins.
- CSI-u forwarding uses `extended-keys on`, `extended-keys-format csi-u`, and `terminal-features extkeys`; preserve these for modified keys in TUI apps.
- `M-1`…`M-9` select tmux windows; prefix + digits select panes. `M-c` creates a window, `M-q` kills a pane, `M-z` zooms, and prefix + `v` / `s` splits.
- `M-h/j/k/l` detects Vim/Neovim and forwards keys, otherwise moves tmux panes; keep this paired with vim-tmux-navigator mappings.
- `set -ag terminal-overrides ",*256col*:RGB"` advertises truecolor.
- `set -g focus-events on` is required for nvim autoread/gitsigns refresh.
- tmux-sensible was removed; defaults are set explicitly.

## Neovim config (`dotfiles/nvim/`)

#`make all` does not run the shell or coding-agent targets; invoke them separately. Avoid `make -j all`: its prerequisites are not dependency-chained. Use `make -n <target>` to preview machine-changing commands.

## Architecture

- **Plugin manager**: lazy.nvim (bootstrapped in `config/lazynvim.lua`); plugin fetches use `git.filter = false` and `git.timeout = 1200` for slow links. The initial lazy.nvim bootstrap itself still uses `--filter=blob:none --branch=stable`
- **Leader key**: `<Space>`, local leader: `\`
- **Color scheme**: solarized.nvim (`autumn` variant, transparent background enabled)
- **Config loading order**: `init.lua` → `config/lib.lua` (provides `safeRequire`) → `config/option.lua` → `config/keymap.lua` → `config/autocmd.lua` → `config/lazynvim.lua` (loads `plugins/`). `safeRequire` suppresses module errors; inspect individual modules when startup silently skips configuration. Completion loads `config/mycmpconfig.lua` from the nvim-cmp spec

### Plugin Specs (`lua/plugins/`)

| File         | Plugins                                                                                                     | Purpose                                                                              |
| ------------ | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `ui.lua`     | snacks.nvim, solarized.nvim, bufferline, lualine, outline.nvim, render-markdown.nvim, which-key             | QoL (input/notifier/bigfile/quickfile/words/rename/terminal/scope), colorscheme, tabline, statusline, outline, markdown rendering, keybinding hints |
| `lsp.lua`    | mason, mason-lspconfig, mason-tool-installer, SchemaStore.nvim, nvim-lspconfig, nvim-cmp + sources, LuaSnip, lazydev.nvim, conform.nvim             | LSP, completion, Lua dev, formatter                                                  |
| `editor.lua` | nvim-treesitter (`main` branch), treesitter-textobjects (`main` branch), nvim-surround, nvim-autopairs      | Syntax, textobjects, surround, autopairs (requires `tree-sitter` CLI)                |
| `nav.lua`    | fzf-lua, nvim-tree, vim-tmux-navigator, auto-session                                                        | Fuzzy finder, file explorer, seamless nvim/tmux navigation, session management       |
| `git.lua`    | gitsigns, neogit (+ diffview, fzf-lua integration)                                                          | Git signs, magit-like UI, diff viewer                                                |

`lazy-lock.json` records plugin revisions. This is a custom lazy.nvim configuration; the retained `lazyvim.json` metadata does not mean the LazyVim distribution is loaded. Auto-session disables automatic saves and suppresses `/`, `~/`, `~/Projects`, and `~/Downloads`.

### LSP Servers (via mason-tool-installer)

`ansiblels`, `bashls`, `gopls`, `jsonls`, `lua_ls`, `marksman`, `pylsp`, `taplo`, `ts_ls`, `yamlls`

JSON/YAML schemas come from SchemaStore.nvim; the YAML server’s built-in schema store is disabled. `mason-tool-installer` is the single install list; mason-lspconfig automatic installation is disabled.

Additional tools auto-installed: `ansible-lint`, `prettier`, `ruff`, `shfmt`, `stylua`.

On Linux, Marksman's bundled .NET runtime requires ICU. `Brewfile-linux-common` installs `icu4c@78`; zshrc/bashrc expose the keg-only library directory through `LD_LIBRARY_PATH` after Homebrew initialization.

### Formatters (via conform.nvim, format-on-save)

- Lua: `stylua` | Go: `gofmt` | Python: `ruff`
- Bash: `shfmt` | TOML: `taplo`
- Markdown/JSON/YAML/JavaScript: `prettier`

Format-on-save has a 500 ms timeout with LSP fallback. `<leader>cf` explicitly calls LSP formatting. Completion sources are LSP, LuaSnip, and buffer; `/` and `?` use buffer completion, while `:` keeps native command-line completion.

### Neovide GUI

`option.lua` has an `if vim.g.neovide then ... end` block (terminal nvim ignores these):

- `guifont = "JetBrainsMono Nerd Font Mono:h17"` — GUI font (matches terminal font)
- `neovide_input_macos_option_key_is_meta = "both"` — treat macOS Option as Meta so `<M-...>` mappings work
- `<D-c>` / `<D-x>` / `<D-v>` provide system clipboard copy, cut, and paste.
- Dynamic zoom via `neovide_scale_factor`: `<D-=>` zoom in, `<D-->` zoom out, `<D-0>` reset

### Treesitter Languages

`bash`, `html`, `go`, `gomod`, `gowork`, `gosum`, `json`, `lua`, `make`, `markdown`, `markdown_inline`, `python`, `yaml`, `vim`, `vue`

### Key Mappings (prefix groups)

| Prefix            | Group               | Examples                                                                 |
| ----------------- | ------------------- | ------------------------------------------------------------------------ |
| `<leader>c`       | Code (LSP)          | `ca` action, `cd` declaration, `cD` definition, `cn` rename symbol (LSP), `cr` rename file (snacks, LSP-aware), `cf` format |
| `<leader>d`       | Diagnostics         | `dof` show diagnostics message, `dqf` open diagnostics location list          |
| `<leader>f`       | Find / File         | `ff` find files, `fg` live grep, `fb` buffers, `fh` help, `fn` new file  |
| `<leader>g`       | Git                 | `gg` neogit, `gc` commit, `gk` preview hunk                              |
| `<leader>n`       | Notifications       | `nh` history, `nd` dismiss (snacks.notifier)                             |
| `<leader>s`       | Session             | `ss` search, `sw` save, `sq` quit all                                    |
| `<leader>t`       | Terminal            | `tt` toggle floating terminal (snacks.terminal)                          |
| `<leader>w`       | Windows             | `ws` split below, `wv` split right, `wd` close                           |
| `<leader><tab>`   | Jumplist / Tab      | `h` jump back, `l` jump forward, `j` first tab, `k` last tab             |
| `<leader>e`       | Explorer            | Toggle nvim-tree |
| `<leader>o`       | Outline             | Toggle document outline (right sidebar, treesitter-backed for markdown)  |
| `]]` / `[[`       | Reference Nav       | Next / previous reference of word under cursor (snacks.words)            |
| `<M-h/j/k/l>`     | Split / Pane Nav    | Seamless navigation across nvim splits and tmux panes (vim-tmux-navigator) |
| `<M-1>`..`<M-5>`  | —                   | Jump to buffer 1..5 by ordinal (terminal/tmux may intercept these keys) |
| `<M-p>` / `<M-n>` | Buffer Cycle           | Previous / next buffer (bufferline) |

## Coding agent config

- Claude Code: `~/.claude/settings.json` (symlinked from `dotfiles/claude/settings.json`); `dotfiles/claude/env.example` is the provider/model env template for Anthropic-compatible endpoints such as Moonshot/Kimi and GLM.
- Codex: `~/.codex/config.toml` (symlinked from `dotfiles/codex/config.toml`)
- Codex config registers the `hashicorp` marketplace from `hashicorp/agent-skills` at a pinned Git revision. Plugin entries `build-web-apps@openai-curated`, `superpowers@openai-curated`, and `terraform@hashicorp` are explicitly disabled.
- OpenCode: `~/.config/opencode/opencode.json` (symlinked from `dotfiles/opencode/opencode.json`); `oh-my-openagent` plugin config at `~/.config/opencode/oh-my-openagent.json` (symlinked from `dotfiles/opencode/oh-my-openagent.json`)
- Pi: `~/.pi/agent/settings.json` (symlinked from `dotfiles/pi/settings.json`)
- Pi extension: `~/.pi/agent/extensions/openai-proxy.ts` (symlinked from `dotfiles/pi/openai-proxy.ts`).
- OpenCode currently enables only `oh-my-openagent@latest`; `oh-my-openagent.json` maps agents and categories to models.
- Pi’s extension overrides the built-in `openai` provider URL only when `OPENAI_BASE_URL` is set; use `OPENAI_API_KEY` for the relay key. Pi uses Bun for package commands; installed extension packages are listed in `dotfiles/pi/settings.json`.
- Claude settings include the `rtk hook claude` Bash hook and a custom status line using `jq`.
- Provider `env.example` files are manual examples, not loaded or symlinked by Makefile. Select the relevant provider block rather than sourcing all examples together.
- Usage: `make coding_agent_config`. It links individual settings and the Pi extension; it does not install the agent CLIs. There is no managed AWS config or Kimi CLI config in the current tree.

## Terminal appearance

- Font: JetBrainsMono Nerd Font Mono, size 17 (matches Neovide). All Brewfiles install `font-jetbrains-mono-nerd-font`; Linux `make install` refreshes the font cache with `fc-cache -f` after a successful bundle install. SSH rendering uses the client terminal font; Windows-hosted WSL terminals require the font on Windows.
- Color scheme: Solarized Dark across terminals and Neovim; tmux uses catppuccin macchiato.

## Utility scripts and manual files

- `generate-secret.sh`: default/password mode keeps the 13-character default and SHA256 checksum; lengths are 1–4096. `jwt` uses OpenSSL with HS256/384/512 (32/48/64 random bytes), `--format base64url|hex`, and `--raw` for a single secret line. Default JWT output is unpadded Base64URL. Password checksums are not password-storage hashes. Preserve legacy numeric length calls and nonzero errors for invalid arguments.
- `trash.sh`: moves files to `~/.Trash` on macOS or `${XDG_DATA_HOME:-$HOME/.local/share}/Trash/files` on Linux. Linux mode does not write `.trashinfo` metadata; it is a move helper, not a complete desktop trash implementation.
- `helm-middleware.sh`: operates on the preconfigured `my-repo` Helm repository, namespaces `dev/test/uat`, and middleware `kafka/redis/redis-cluster/rocketmq`. Install/uninstall affect the selected Kubernetes cluster.
- `decorate-requests.py` is an incomplete requests API-wrapper example with an existing syntax error in `action_post`, not a runnable utility. `getcdn-realip.go` fetches provider IP ranges, reads/writes `realip.json` in the working directory, and appends `all.log`; it requires initialized JSON and contains placeholder integration settings. CI does not validate Python or Go scripts.
- `dotfiles/pgpass` is installed manually as `~/.pgpass` with mode `600`; Makefile does not link it.
- `appfiles/` contains manual backups (AutoHotkey v2 on Windows, Folo OPML, Sublime Text, Raycast, VS Code, and ZeroOmega). Do not treat these as bootstrap-managed configs.

## Verification

- Run `make test`, `shellcheck scripts/*.sh`, and `git diff --check` for relevant changes. For shell changes also use `bash -n` / `zsh -n` without sourcing interactive configs.
- Exercise changed utility behavior separately: CI only checks Makefile variable resolution and ShellCheck. For secret generation, check lengths, encodings, checksums, raw output, and invalid arguments without logging generated secrets.
- Use source configs as the authority when refreshing the tables above; keep README usage descriptions consistent with Makefile and this file.
