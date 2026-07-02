APPFILES := $(CURDIR)/appfiles
DOTFILES := $(CURDIR)/dotfiles
OS_NAME := $(shell uname -s)
SHELL := /bin/bash


# Check OS and setting package
ifeq ($(OS_NAME),Linux)
    BREWFILE ?= $(CURDIR)/homebrew/Brewfile-linux
    BREW := $(or $(shell command -v brew 2>/dev/null),/home/linuxbrew/.linuxbrew/bin/brew)
    LN_DIR := ln -svfn

    # Check sudo command
    ifeq ($(shell command -v sudo 2> /dev/null),)
        CMD_PREFIX := su root -c
    else
        CMD_PREFIX := sudo
    endif

    ifneq ($(strip $(shell grep -i debian /etc/*release 2>/dev/null)),)
        PACKAGE_CMD := apt install -y
        BOOTSTRAP_PKGS := build-essential procps curl file git fontconfig fonts-powerline
    else ifneq ($(strip $(shell grep -i fedora /etc/*release 2>/dev/null)),)
        PACKAGE_CMD := dnf install -y
        BOOTSTRAP_PKGS := gcc gcc-c++ make procps-ng curl file git fontconfig powerline-fonts
    else
        $(error Unsupported operating system: $(OS_NAME))
    endif
else ifeq ($(OS_NAME),Darwin)
    BREWFILE ?= $(CURDIR)/homebrew/Brewfile
    BREW := $(or $(shell command -v brew 2>/dev/null),/opt/homebrew/bin/brew)
    LN_DIR := ln -svF
else
    $(error Unsupported operating system: $(OS_NAME))
endif
LN_FILE := ln -svf


.PHONY: all application clean install test dependencies xdg_config bash zsh coding_agent_config aws_config help
all: test install xdg_config clean ## Step: test install xdg_config clean

dependencies:
	@echo "##### Dependencies check start #####"
ifeq ($(OS_NAME),Linux)
	@echo ">>> Installing bootstrap packages: $(BOOTSTRAP_PKGS)"
	@$(CMD_PREFIX) $(PACKAGE_CMD) $(BOOTSTRAP_PKGS)
endif
	@if ! command -v brew >/dev/null 2>&1 && [ ! -x "$(BREW)" ]; then \
		echo ">>> Installing Homebrew"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "##### Dependencies check end   #####"

install: dependencies ## Install all packages via Homebrew (Brewfile / Brewfile-work / Brewfile-linux)
	@echo "##### Install package start #####"
	@[ -x "$(BREW)" ] || { echo "brew not found at $(BREW)"; exit 1; }
	@eval "$$($(BREW) shellenv)" && brew bundle --file=$(BREWFILE)
	@echo "##### Install package end   #####"

xdg_config: ## Install XDG_CONFIG symlinks (alacritty / ghostty / nvim / tmux / vim / wezterm)
	@echo "##### Install xdg_config start #####"
	@mkdir -p $(HOME)/.config $(HOME)/.vim/bundle
	$(LN_DIR) $(DOTFILES)/alacritty $(HOME)/.config/alacritty
	$(LN_DIR) $(DOTFILES)/ghostty $(HOME)/.config/ghostty
	$(LN_DIR) $(DOTFILES)/nvim $(HOME)/.config/nvim
	$(LN_DIR) $(DOTFILES)/tmux $(HOME)/.config/tmux
	$(LN_DIR) $(DOTFILES)/vim $(HOME)/.config/vim
	$(LN_DIR) $(DOTFILES)/wezterm $(HOME)/.config/wezterm
	@test -d $(HOME)/.vim/bundle/Vundle.vim || \
		git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim
	@if command -v nvim >/dev/null 2>&1; then \
		nvim --headless +Lazy +qall; \
	else \
		echo ">>> nvim not installed, skipping Lazy sync"; \
	fi
	@if command -v vim >/dev/null 2>&1; then \
		vim -u $(HOME)/.config/vim/vimrc +PluginInstall +qall; \
	else \
		echo ">>> vim not installed, skipping PluginInstall"; \
	fi
	@echo "##### Install xdg_config end   #####"

bash: ## Install oh-my-bash and link ~/.bashrc
	@echo "##### Install oh-my-bash start #####"
	@if [ -d $(HOME)/.oh-my-bash ]; then \
		echo "oh-my-bash already installed"; \
	else \
		bash -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"; \
	fi
	$(LN_FILE) $(DOTFILES)/bashrc $(HOME)/.bashrc
	@echo "##### Install oh-my-bash end   #####"
	@echo ">>> Please run 'source ~/.bashrc' to apply changes."

zsh: ## Install oh-my-zsh and link ~/.zshrc
	@echo "##### Install oh-my-zsh start #####"
	@if [ -d $(HOME)/.oh-my-zsh ]; then \
		echo "oh-my-zsh already installed"; \
	else \
		sh -c "$$(curl -fsSL https://install.ohmyz.sh/)"; \
	fi
	@test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions || \
		git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	@test -d $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	$(LN_FILE) $(DOTFILES)/zshrc $(HOME)/.zshrc
	@echo "##### Install oh-my-zsh end   #####"
	@echo ">>> Please run 'source ~/.zshrc' to apply changes."

test: ## Run the tests
	@echo "##### Test start #####"
	@echo APPFILES is $(APPFILES)
	@echo DOTFILES is $(DOTFILES)
	@echo BREWFILE is $(BREWFILE)
	@echo BREW is $(BREW)
	@echo OS_NAME is $(OS_NAME)
	@echo CMD_PREFIX is $(CMD_PREFIX)
	@echo PACKAGE_CMD is $(PACKAGE_CMD)
	@echo BOOTSTRAP_PKGS is $(BOOTSTRAP_PKGS)
	@echo "##### Test end   #####"

clean: ## Clean up broken symlinks in XDG_CONFIG directory.
	@echo "##### Clean start #####"
	@find $(HOME)/.config -maxdepth 1 -type l ! -exec test -e {} \; -print -delete 2>/dev/null || true
	@echo "##### Clean end   #####"

coding_agent_config: ## Install coding agent configs (claude-code / codex / opencode / pi)
	@echo "##### Install coding agent config start #####"
	@mkdir -p $(HOME)/.claude $(HOME)/.codex $(HOME)/.config/opencode $(HOME)/.pi/agent/extensions
	$(LN_FILE) $(DOTFILES)/claude/settings.json $(HOME)/.claude/settings.json
	$(LN_FILE) $(DOTFILES)/codex/config.toml $(HOME)/.codex/config.toml
	$(LN_FILE) $(DOTFILES)/opencode/opencode.json $(HOME)/.config/opencode/opencode.json
	$(LN_FILE) $(DOTFILES)/opencode/oh-my-openagent.json $(HOME)/.config/opencode/oh-my-openagent.json
	$(LN_FILE) $(DOTFILES)/pi/settings.json $(HOME)/.pi/agent/settings.json
	$(LN_FILE) $(DOTFILES)/pi/openai-proxy.ts $(HOME)/.pi/agent/extensions/openai-proxy.ts
	@echo "##### Install coding agent config end   #####"

aws_config: ## Symlink AWS CLI config (~/.aws/config)
	@echo "##### Install aws config start #####"
	@mkdir -p $(HOME)/.aws
	$(LN_FILE) $(DOTFILES)/aws/config $(HOME)/.aws/config
	@echo "##### Install aws config end   #####"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
