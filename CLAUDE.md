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
│   │   └── opencode.json
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
- `make coding_agent_config` — Install AI configs (claude, codex, gemini, opencode) to respective directories
- `make clean` — Remove broken symlinks in `~/.config/`
- `make test` — Print environment variables for verification
- `make help` — Show targets with `##` descriptions

### Coding Agent Config

- Claude Code: `~/.claude/settings.json` (symlinked from `dotfiles/claude/settings.json`)
- Codex: `~/.codex/config.toml` (symlinked from `dotfiles/codex/config.toml`)
- Gemini CLI: `~/.gemini/settings.json` (symlinked from `dotfiles/gemini/settings.json`)
- OpenCode: `~/.config/opencode/opencode.json` (symlinked from `dotfiles/opencode/opencode.json`)
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
| `thewtex/tmux-mem-cpu-load` | Mem / CPU / load status segment; binary symlinked to `/opt/homebrew/bin/tmux-mem-cpu-load` |
| `semi710/minimal-tmux-status` | Status bar layout (owns `status-left/right/style` + `window-status-*format`) |
| `tmux-plugins/tmux-battery` | Battery status segment |

#### Status Bar Architecture

- Layout fully owned by **minimal-tmux-status**; do NOT hand-write `status-left/right/style` or `window-status-*format` — set `@minimal-tmux-*` vars instead. Plugin sets `status-style bg=default,fg=default` so the bar bg stays terminal default; `@minimal-tmux-bg/fg` only colors the active-window pill + prefix indicator.
- Palette: `@minimal-tmux-bg "#268bd2"` (Solarized blue) + `@minimal-tmux-fg "#073642"` (base02).
- Prefix indicator: `@minimal-tmux-indicator-str " #S "` — session name shown subtly, lights up blue when `C-z` held.
- Zoom flag auto-injected via `#{?window_zoomed_flag,…}` in `window-status-current-format`.
- Right side (`@minimal-tmux-status-right`): 5 colored pills — three auto-styled by `tmux-mem-cpu-load -c` (mem / cpu / load, thresholded bg), then battery on `colour23` dark teal, then date+time on `colour58` dark olive.

#### Gotcha: `#{battery_color_fg}` Is a Full Style Block, Not a Color

`#{battery_color_fg}` (and its siblings `_bg`, `_charge_*`, `_status_*`) expands to a complete `#[fg=X,bg=Y]` declaration — **NOT** a bare color value. Nesting it inside `#[fg=…,bg=…]` breaks tmux's `#[...]` parser and leaks literal text into the status line. Use it standalone. Default secondary plane is `colour0` (black) — to force a different bg, override **both** `@batt_color_charge_secondary_tier1..8` AND `@batt_color_status_secondary_<state>` (13 vars total) to the desired color.

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
