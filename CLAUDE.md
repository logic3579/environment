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
│   └── bashrc               # Bash config (oh-my-bash)
├── appfiles/                # Application config backups
├── scripts/
│   ├── trash.sh             # Safe delete (move to system trash)
│   ├── generate-secret.sh   # Random password + SHA256 generator
│   ├── tmux-network-speed.sh # tmux status bar network speed
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
- OpenCode: `~/.opencode/opencode.json` (symlinked from `dotfiles/opencode/opencode.json`)
- Usage: `make coding_agent_config`

### Two Brewfile Strategy

- `Brewfile` — Default environment packages
- `Brewfile-work` — Work environment packages (more DevOps tools: k8s, helm, argocd, etc.)
- Shared packages exist in both files independently (no shared base file)

### Neovim Config (`dotfiles/nvim/`)

#### Architecture

- **Plugin manager**: lazy.nvim (bootstrapped in `config/lazynvim.lua`)
- **Leader key**: `<Space>`, local leader: `\`
- **Color scheme**: solarized.nvim (transparent background enabled)
- **Config loading order**: `init.lua` → `config/option.lua` → `config/keymap.lua` → `config/autocmd.lua` → `config/lib.lua` → `config/lazynvim.lua` (loads `plugins/`)

#### Plugin Specs (`lua/plugins/`)

| File              | Plugins                                                                                | Purpose                                                                 |
| ----------------- | -------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `colorschema.lua` | solarized.nvim                                                                         | Solarized Dark theme with transparency                                  |
| `lsp.lua`         | mason, mason-lspconfig, nvim-lspconfig                                                 | LSP management (handlers auto-setup pattern)                            |
| `coding.lua`      | conform.nvim, lazydev.nvim, nvim-autopairs, nvim-cmp + sources, LuaSnip                | Formatting, completion, Lua dev                                         |
| `treesitter.lua`  | nvim-treesitter (`main` branch), treesitter-textobjects (`main` branch), nvim-surround | Syntax highlighting, textobjects, surround (requires `tree-sitter` CLI) |
| `editor.lua`      | telescope, nvim-tree, gitsigns, neogit + diffview, which-key                           | Navigation, file explorer, git, keybinding hints                        |
| `ui.lua`          | bufferline, lualine                                                                    | Tabline and statusline                                                  |
| `dap.lua`         | nvim-dap, dap-ui, dap-virtual-text, mason-nvim-dap, dap-python, dap-go                 | Debugging (Python + Go)                                                 |
| `util.lua`        | auto-session                                                                           | Session management                                                      |

#### LSP Servers (via mason-lspconfig)

`bashls`, `lua_ls`, `pylsp`, `gopls`, `marksman`

#### Formatters (via conform.nvim, format-on-save)

- Lua: `stylua` | Go: `goimports` + `gofmt` | Python: `isort` + `black`
- Markdown/JSON/YAML: `prettier` | JavaScript: `prettierd`/`prettier`

#### Treesitter Languages

`bash`, `html`, `go`, `gomod`, `gowork`, `gosum`, `json`, `lua`, `make`, `markdown`, `markdown_inline`, `python`, `yaml`, `vim`, `vue`

#### Key Mappings (prefix groups)

| Prefix            | Group               | Examples                                                                 |
| ----------------- | ------------------- | ------------------------------------------------------------------------ |
| `<leader>c`       | Code (LSP)          | `ca` action, `cd` declaration, `cD` definition, `cr` rename, `cf` format |
| `<leader>d`       | Debug / Diagnostics | `db` breakpoint, `dc` continue, `di` step into, `du` DAP UI              |
| `<leader>f`       | Find / File         | `ff` find files, `fg` live grep, `fn` new file                           |
| `<leader>g`       | Git                 | `gg` neogit, `gc` commit, `gk` preview hunk                              |
| `<leader>s`       | Session             | `ss` search, `sw` save, `sq` quit all                                    |
| `<leader>w`       | Windows             | `ws` split below, `wv` split right, `wd` close                           |
| `<leader><tab>`   | Jumplist / Tab      | `h` jump back, `l` jump forward, `j` first tab, `k` last tab             |
| `<M-p>` / `<M-n>` | —                   | Buffer prev / next (bufferline)                                          |

## Key Details

- macOS only for daily use (Apple Silicon, Homebrew at `/opt/homebrew/`)
- Dotfiles are symlinked via `ln -svF` to `~/.config/<app>/`
- tmux prefix key: `C-z`
- Terminal font: MesloLGLDZ Nerd Font, font size 17
- Color scheme: Solarized Dark (across terminals and Neovim)
- Shell scripts target: `#!/bin/bash` with `set -euo pipefail`
