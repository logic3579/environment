# Environment

Personal dotfiles, application configs, Homebrew packages, and utility scripts.

## Project Structure

```
.
├── Makefile                 # Main entry: install, link, clean
├── Brewfile                 # Homebrew packages (default)
├── Brewfile-work            # Homebrew packages (Work environment)
├── dotfiles/
│   ├── tmux/tmux.conf       # tmux config (prefix: C-z)
│   ├── nvim/                # Neovim config (lazy.nvim plugin manager)
│   │   ├── init.lua         # Entry: loads config/* and bootstraps lazy.nvim
│   │   └── lua/
│   │       ├── config/      # Core config (option, keymap, autocmd, lib)
│   │       └── plugins/     # Plugin specs (lazy.nvim format)
│   ├── vim/vimrc            # Vim config (Vundle)
│   ├── wezterm/wezterm.lua  # WezTerm terminal config
│   ├── ghostty/config       # Ghostty terminal config
│   ├── claude/              # Claude Code config
│   │   └── settings.json
│   ├── codex/               # Codex CLI config
│   │   └── config.toml
│   ├── gemini/              # Gemini CLI config
│   │   └── settings.json
│   ├── opencode/            # OpenCode CLI config
│   │   ├── opencode.json
│   │   └── oh-my-openagent.json   # oh-my-openagent plugin: agents/categories → model mapping
│   ├── zshrc                # Zsh config (oh-my-zsh)
│   ├── bashrc               # Bash config (oh-my-bash, cross-platform: macOS + Linux)
│   └── pgpass               # libpq password template (manual install — see README)
├── appfiles/                # Application config backups
├── scripts/
│   ├── trash.sh             # Safe delete (move to system trash)
│   ├── generate-secret.sh   # Random password + SHA256 generator
│   ├── helm-middleware.sh   # Helm middleware utility
│   ├── decorate-requests.py # Python request decorator
│   └── getcdn-realip.go     # Go utility for CDN real IP
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
- **zshrc PATH pattern**: Use `export PATH="...:$PATH"` for each tool, with `typeset -U PATH` on the last line to deduplicate (no conditional `[[ ]]` checks needed)
- **bashrc PATH pattern**: Cross-platform (macOS + Linux). Brew paths gated on `[[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/..." ]]`. Final `awk` dedup since bash has no `typeset -U`.
- **Shell completion cache**: `kubectl`/`helm` completion is cached at `~/.cache/{zsh,bash}-{kubectl,helm}-completion` (regen weekly via `find -mtime +7`) to avoid ~100ms startup penalty per tool. `rm` the file to force refresh.
- **fzf shell integration**: zshrc/bashrc trail with `eval "$(fzf --{zsh,bash})"` — provides `Ctrl-R` history fuzzy search, `Ctrl-T` file picker, `Alt-C` cd. Independent from nvim's fzf-lua.

### Makefile Targets

- `make install` — Install all packages (depends on `dependencies`)
- `make xdg_config` — Symlink dotfiles to `~/.config/`
- `make bash` / `make zsh` — Install shell framework and link rc file
- `make coding_agent_config` — Install AI configs (claude, codex, gemini, kimi, opencode, pi) to respective directories
- `make clean` — Remove broken symlinks in `~/.config/`
- `make test` — Print environment variables for verification
- `make help` — Show targets with `##` descriptions

### Coding Agent Config

- AtomCode: `~/.atomcode/config.toml` (symlinked from `dotfiles/atomcode/config.toml`)
- Claude Code: `~/.claude/settings.json` (symlinked from `dotfiles/claude/settings.json`)
- Codex: `~/.codex/config.toml` (symlinked from `dotfiles/codex/config.toml`)
- Gemini CLI: `~/.gemini/settings.json` (symlinked from `dotfiles/gemini/settings.json`)
- Kimi CLI: `~/.kimi/config.toml` (symlinked from `dotfiles/kimi/config.toml`)
- OpenCode: `~/.config/opencode/opencode.json` (symlinked from `dotfiles/opencode/opencode.json`); `oh-my-openagent` plugin config at `~/.config/opencode/oh-my-openagent.json` (symlinked from `dotfiles/opencode/oh-my-openagent.json`)
- Pi: `~/.pi/agent/settings.json` (symlinked from `dotfiles/pi/settings.json`)
- Usage: `make coding_agent_config`

### Two Brewfile Strategy

- `Brewfile` — Default environment packages
- `Brewfile-work` — Work environment packages (more DevOps tools: k8s, helm, argocd, etc.)
- Shared packages exist in both files independently (no shared base file)

### Tmux Config (`dotfiles/tmux/tmux.conf`)

#### Plugins (via TPM)

| Plugin | Purpose |
| ------ | ------- |
| `tmux-plugins/tpm` | Plugin manager (auto-bootstrapped via `if "test ! -d ..."` block at bottom) |
| `tmux-plugins/tmux-resurrect` | Session save / restore |
| `tmux-plugins/tmux-cpu` | Provides `#{cpu_*}` / `#{ram_*}` format vars consumed by catppuccin's cpu and ram modules |
| `tmux-plugins/tmux-battery` | Provides `#{battery_*}` format vars consumed by catppuccin's battery module |
| `catppuccin/tmux#v2.3.0` | Theme + widget framework (pinned to v2.3.0; bumps require manually editing tag) |

#### Status Bar Architecture

- Theme: **catppuccin macchiato** (`@catppuccin_flavor "macchiato"`). Visually deliberately different from the Solarized terminal + nvim palette — accepted color-clash.
- Window pill style: `@catppuccin_window_status_style "rounded"` (default; explicit for clarity).
- Position: top, left-justified (tmux defaults `status-position` / `status-justify`).
- Widget composition is done via append-mode `set -ag`/`set -agF` on `status-left` and `status-right` referencing `#{E:@catppuccin_status_<name>}`. The `E:` prefix expands the format twice — needed for catppuccin to interpolate its color slots.
- **Left**: `session` only. Session module has a built-in prefix indicator (`#{?client_prefix,#{E:@thm_red},#{E:@thm_green}}`) — the session pill turns red when `C-z` is held; no separate prefix-highlight needed.
- **Right**: `cpu` → `ram` → `load` → `battery` → `date_time`. Each pill self-colors via theme slots (thm_yellow / thm_blue / thm_pink etc.).
- **Window pills**: `@catppuccin_window_text " #W"` + `@catppuccin_window_current_text " #W"` are explicitly set so the window LABEL (set by `rename-window` / `automatic-rename`) shows — catppuccin's default is `#T` (pane title), a different concept entirely. `@catppuccin_window_flags "icon"` enables Nerd Font glyphs for zoom/bell/activity flags.
- Module configs live in `~/.tmux/plugins/tmux/status/<name>.conf` after TPM clones the plugin; customize by setting `@catppuccin_<module>_*` vars BEFORE the TPM run line at the bottom of `tmux.conf`.

#### Gotcha: catppuccin v2 vs v0.3 Syntax

catppuccin/tmux had a major rewrite at v2 — config keys, module names, and the `#{E:@catppuccin_status_*}` interpolation pattern all changed. **Do not copy snippets from old tutorials**; check the version against `~/.tmux/plugins/tmux/CHANGELOG.md`. v2 modules use `#{E:...}` (double expansion) — single `#{...}` will render literal text.

#### Gotcha: Plugin Name Collision Under TPM

The catppuccin repo is `catppuccin/tmux`, which TPM clones to `~/.tmux/plugins/tmux/` (just `tmux`, owner stripped). This conflicts with conventional plugin naming patterns and is why upstream marks "Manual install" as the recommended path. For this project TPM works fine, but if other plugins ever name themselves `tmux` (unlikely) they will collide.

### Neovim Config (`dotfiles/nvim/`)

#### Architecture

- **Plugin manager**: lazy.nvim (bootstrapped in `config/lazynvim.lua`); configured with `git.filter = false` (full clone, no `blob:none` partial fetch) and `git.timeout = 1200` to survive slow links
- **Leader key**: `<Space>`, local leader: `\`
- **Color scheme**: solarized.nvim (transparent background enabled)
- **Config loading order**: `init.lua` → `config/option.lua` → `config/keymap.lua` → `config/autocmd.lua` → `config/lib.lua` → `config/lazynvim.lua` (loads `plugins/`)

#### Plugin Specs (`lua/plugins/`)

| File         | Plugins                                                                                                     | Purpose                                                                              |
| ------------ | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `ui.lua`     | snacks.nvim, solarized.nvim, bufferline, lualine, outline.nvim, render-markdown.nvim, which-key             | QoL (input/notifier/bigfile/quickfile/words/rename/terminal/scope), colorscheme, tabline, statusline, outline, markdown rendering, keybinding hints |
| `lsp.lua`    | mason, mason-lspconfig, nvim-lspconfig, nvim-cmp + sources, LuaSnip, lazydev.nvim, conform.nvim             | LSP, completion, Lua dev, formatter                                                  |
| `editor.lua` | nvim-treesitter (`main` branch), treesitter-textobjects (`main` branch), nvim-surround, nvim-autopairs      | Syntax, textobjects, surround, autopairs (requires `tree-sitter` CLI)                |
| `nav.lua`    | fzf-lua, nvim-tree, vim-tmux-navigator, auto-session                                                        | Fuzzy finder, file explorer, seamless nvim/tmux navigation, session management       |
| `git.lua`    | gitsigns, neogit (+ diffview, fzf-lua integration)                                                          | Git signs, magit-like UI, diff viewer                                                |

#### LSP Servers (via mason-tool-installer)

`ansiblels`, `bashls`, `gopls`, `jsonls`, `lua_ls`, `marksman`, `pylsp`, `taplo`, `ts_ls`, `yamlls`

Additional tools auto-installed: `ansible-lint`, `prettier`, `ruff`, `shfmt`, `stylua`.

#### Formatters (via conform.nvim, format-on-save)

- Lua: `stylua` | Go: `gofmt` | Python: `ruff`
- Bash: `shfmt` | TOML: `taplo`
- Markdown/JSON/YAML/JavaScript: `prettier`

#### Neovide GUI

`option.lua` has an `if vim.g.neovide then ... end` block (terminal nvim ignores these):

- `guifont = "MesloLGMDZ Nerd Font Mono:h17"` — GUI font (matches terminal font)
- `neovide_input_macos_option_key_is_meta = "both"` — treat macOS Option as Meta so `<M-...>` mappings work
- Dynamic zoom via `neovide_scale_factor`: `<D-=>` zoom in, `<D-->` zoom out, `<D-0>` reset

#### Treesitter Languages

`bash`, `html`, `go`, `gomod`, `gowork`, `gosum`, `json`, `lua`, `make`, `markdown`, `markdown_inline`, `python`, `yaml`, `vim`, `vue`

#### Key Mappings (prefix groups)

| Prefix            | Group               | Examples                                                                 |
| ----------------- | ------------------- | ------------------------------------------------------------------------ |
| `<leader>c`       | Code (LSP)          | `ca` action, `cd` declaration, `cD` definition, `cn` rename symbol (LSP), `cr` rename file (snacks, LSP-aware), `cf` format |
| `<leader>d`       | Diagnostics         | `dof` show diagnostics message, `dqf` open diagnostics quickfix          |
| `<leader>f`       | Find / File         | `ff` find files, `fg` live grep, `fb` buffers, `fh` help, `fn` new file  |
| `<leader>g`       | Git                 | `gg` neogit, `gc` commit, `gk` preview hunk                              |
| `<leader>n`       | Notifications       | `nh` history, `nd` dismiss (snacks.notifier)                             |
| `<leader>s`       | Session             | `ss` search, `sw` save, `sq` quit all                                    |
| `<leader>t`       | Terminal            | `tt` toggle floating terminal (snacks.terminal)                          |
| `<leader>w`       | Windows             | `ws` split below, `wv` split right, `wd` close                           |
| `<leader><tab>`   | Jumplist / Tab      | `h` jump back, `l` jump forward, `j` first tab, `k` last tab             |
| `<leader>o`       | Outline             | Toggle document outline (right sidebar, treesitter-backed for markdown)  |
| `]]` / `[[`       | Reference Nav       | Next / previous reference of word under cursor (snacks.words)            |
| `<M-h/j/k/l>`     | Split / Pane Nav    | Seamless navigation across nvim splits and tmux panes (vim-tmux-navigator) |
| `<M-1>`..`<M-5>`  | —                   | Jump to tab 1..5 by ordinal (bufferline, Neovide only — tmux intercepts in terminal) |
| `<M-p>` / `<M-n>` | Tab Cycle           | Previous / next tab (bufferline; works in both Neovide and terminal nvim) |

## Key Details

- macOS only for daily use (Apple Silicon, Homebrew at `/opt/homebrew/`); `bashrc` is the only shell rc kept Linux-portable
- tmux: `set -ag terminal-overrides ",*256col*:RGB"` advertises truecolor; `focus-events on` is required by gitsigns/nvim autoread; tmux-sensible plugin removed (all defaults set explicitly)
- Dotfiles are symlinked via `ln -svF` to `~/.config/<app>/`
- tmux prefix key: `C-z`
- Terminal font: MesloLGMDZ Nerd Font Mono, font size 17 (matches Neovide `guifont`)
- Color scheme: Solarized Dark (across terminals and Neovim)
- Shell scripts target: `#!/bin/bash` with `set -euo pipefail`
