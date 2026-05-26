APPFILES := $(CURDIR)/appfiles
BREWFILE ?= $(CURDIR)/Brewfile
DOTFILES := $(CURDIR)/dotfiles
OS_NAME := $(shell uname -s)
SHELL := /bin/bash


# Check OS and setting package
ifeq ($(OS_NAME),Linux)
    PACKAGE_NAME := curl wget telnet git fontconfig tmux neovim zsh

    # Check sudo command
    ifeq ($(shell command -v sudo 2> /dev/null),)
        CMD_PREFIX := su root -c
    else
        CMD_PREFIX := sudo
    endif

    ifneq ($(strip $(shell grep -i debian /etc/*release 2>/dev/null)),)
        PACKAGE_CMD := apt install -y
    else ifneq ($(strip $(shell grep -i fedora /etc/*release 2>/dev/null)),)
        PACKAGE_CMD := dnf install -y
    else
        $(error Unsupported operating system: $(OS_NAME))
    endif
else ifeq ($(OS_NAME),Darwin)
    BREW := $(or $(shell command -v brew 2>/dev/null),/opt/homebrew/bin/brew)
    PACKAGE_CMD := $(BREW) bundle --file=$(BREWFILE)
else
    $(error Unsupported operating system: $(OS_NAME))
endif


.PHONY: all application clean install test dependencies xdg_config bash zsh coding_agent_config help
all: test install xdg_config clean ## Step: test install xdg_config clean

dependencies:
	@echo "##### Dependencies check start #####"
	@if [ "$(OS_NAME)" = "Darwin" ] && ! command -v brew >/dev/null 2>&1; then \
		echo ">>> Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	elif [ "$(OS_NAME)" = "Linux" ]; then \
		echo ">>> Installing fonts-powerline"; \
		$(CMD_PREFIX) $(PACKAGE_CMD) fonts-powerline; \
	fi
	@echo "##### Dependencies check end   #####"

install: dependencies ## Dependencies check and install all package.
	@echo "##### Install package start #####"
	@if [ "$(OS_NAME)" = "Darwin" ]; then \
		[ -x "$(BREW)" ] || { echo "brew not found at $(BREW)"; exit 1; }; \
		eval "$$($(BREW) shellenv)" && brew bundle --file=$(BREWFILE); \
	else \
		$(CMD_PREFIX) $(PACKAGE_CMD) $(PACKAGE_NAME); \
	fi
	@echo "##### Install package end   #####"

xdg_config: ## Link configure to XDG_CONFIG directory.
	@echo "##### Initialize xdg_config start #####"
	@mkdir -p $(HOME)/.config
	@echo ">>> Tmux"
	ln -svF $(DOTFILES)/tmux $(HOME)/.config/tmux
	@echo ">>> Neovim"
	ln -svF $(DOTFILES)/nvim $(HOME)/.config/nvim && \
	if command -v nvim >/dev/null 2>&1; then \
		nvim --headless +Lazy +qall; \
	else \
		echo ">>> nvim not installed, skipping Lazy sync"; \
	fi
	@echo ">>> Vim"
	test -d $(HOME)/.vim/bundle/Vundle.vim || \
		git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim
	ln -svF $(DOTFILES)/vim $(HOME)/.config/vim && \
	if command -v vim >/dev/null 2>&1; then \
		vim -u $(HOME)/.config/vim/vimrc +PluginInstall +qall; \
	else \
		echo ">>> vim not installed, skipping PluginInstall"; \
	fi
	@echo ">>> WezTerm"
	ln -svF $(DOTFILES)/wezterm $(HOME)/.config/wezterm
	@echo ">>> Ghostty"
	ln -svF $(DOTFILES)/ghostty $(HOME)/.config/ghostty
	@echo "##### Initialize xdg_config end   #####"

bash: ## Install oh-my-bash and link ~/.bashrc
	@echo "##### Initialize oh-my-bash start #####"
	@if [ -d $(HOME)/.oh-my-bash ]; then \
		echo "oh-my-bash already installed"; \
	else \
		bash -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"; \
	fi
	ln -svf $(DOTFILES)/bashrc $(HOME)/.bashrc
	@echo "##### Initialize oh-my-bash end   #####"
	@echo ">>> Please run 'source ~/.bashrc' to apply changes."

zsh: ## Install oh-my-zsh and link ~/.zshrc
	@echo "##### Initialize oh-my-zsh start #####"
	@if [ -d $(HOME)/.oh-my-zsh ]; then \
		echo "oh-my-zsh already installed"; \
	else \
		sh -c "$$(curl -fsSL https://install.ohmyz.sh/)"; \
	fi
	@test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions || \
		git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	@test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	ln -svf $(DOTFILES)/zshrc $(HOME)/.zshrc
	@echo "##### Initialize oh-my-zsh end   #####"
	@echo ">>> Please run 'source ~/.zshrc' to apply changes."

test: ## Run the tests
	@echo "##### Test start #####"
	@echo APPFILES is $(APPFILES)
	@echo DOTFILES is $(DOTFILES)
	@echo BREWFILE is $(BREWFILE)
	@echo OS_NAME is $(OS_NAME)
	@echo CMD_PREFIX is $(CMD_PREFIX)
	@echo PACKAGE_CMD is $(PACKAGE_CMD)
	@echo PACKAGE_NAME is $(PACKAGE_NAME)
	@echo "##### Test end   #####"

clean: ## Clean up broken symlinks in XDG_CONFIG directory.
	@echo "##### Clean start #####"
	@find $(HOME)/.config -maxdepth 1 -type l ! -exec test -e {} \; -print -delete 2>/dev/null || true
	@echo "##### Clean end   #####"

coding_agent_config: ## Install coding agent configs (claude-code / codex / gemini-cli / kimi-cli / opencode / pi)
	@echo "##### Install coding agent config start #####"
	@mkdir -p $(HOME)/.claude $(HOME)/.codex $(HOME)/.gemini $(HOME)/.kimi $(HOME)/.config/opencode $(HOME)/.pi/agent
	ln -svF $(DOTFILES)/claude/settings.json $(HOME)/.claude/settings.json
	ln -svF $(DOTFILES)/codex/config.toml $(HOME)/.codex/config.toml
	ln -svF $(DOTFILES)/gemini/settings.json $(HOME)/.gemini/settings.json
	ln -svF $(DOTFILES)/kimi/config.toml $(HOME)/.kimi/config.toml
	ln -svF $(DOTFILES)/opencode/opencode.json $(HOME)/.config/opencode/opencode.json
	ln -svF $(DOTFILES)/pi/settings.json $(HOME)/.pi/agent/settings.json
	@echo "##### Install coding agent config end   #####"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
