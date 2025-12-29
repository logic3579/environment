MAINTAINER := logic
APPFILES := $(CURDIR)/appfiles
DOTFILES := $(CURDIR)/dotfiles
OS_NAME := $(shell uname -s)
DATE = $(shell DATE)
SHELL := /bin/bash


# check os and setting package
ifeq ($(OS_NAME), Linux)
    PACKAGE_NAME := curl wget telnet git fontconfig tmux neovim zsh

    # check sudo command
    ifeq ($(shell command -v sudo 2> /dev/null),)
        CMD_PREFIX := su root -c
    else
        CMD_PREFIX := sudo
    endif

    ifneq ($(strip $(shell cat /etc/*release | grep -i 'debian')),)
        PACKAGE_CMD := apt install -y
    else ifneq ($(strip $(shell cat /etc/*release | grep -i 'fedora')),)
        PACKAGE_CMD := dnf install -y
    else
        $(error Unsupported operating system: $(OS_NAME))
    endif
else ifeq ($(OS_NAME), Darwin)
    PACKAGE_CMD := brew bundle
else
    $(error Unsupported operating system: $(OS_NAME))
endif


.PHONY: all application clean install test
all: test install xdg_config clean ## Step: test install xdg_config clean

dependencies:
	@echo "##### Dependencies check start #####"
	@if [ "$(OS_NAME)" = "Darwin" ] &&  ! command -v brew >/dev/null 2>&1; then \
		echo ">>> Installing Homebrew..."; \
		sudo spctl --master-disable; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	elif [ "$(OS_NAME)" = "Linux" ]; then \
		echo ">>> Installing fonts-powerline"; \
		$(CMD_PREFIX) $(PACKAGE_CMD) fonts-powerline; \
	fi
	@echo "##### Dependencies check end   #####"

install: dependencies ## Dependencies check and install all package.
	@echo "##### Install package start #####"
	$(CMD_PREFIX) $(PACKAGE_CMD) $(PACKAGE_NAME)
	@echo "##### Install package end   #####"

xdg_config: ## Link configure to XDG_CONFIG directory.
	@echo "##### Initialize xdg_config start #####"
	@echo ">>> Tmux"
	ln -svF $(DOTFILES)/tmux $(HOME)/.config/tmux;
	@echo ">>> Neovim"
	ln -svF $(DOTFILES)/nvim $(HOME)/.config/nvim; \
	nvim +Lazy +qall;
	@echo ">>> Vim"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || echo "Vundle.vim path already exists"; \
	ln -svF $(DOTFILES)/vim $(HOME)/.config/vim; \
	vim +PluginInstall +qall;
	@echo ">>> WezTerm"
	ln -svF $(DOTFILES)/wezterm $(HOME)/.config/wezterm;
	@echo ">>> ghostty"
	ln -svF $(DOTFILES)/ghostty $(HOME)/.config/ghostty;
	@echo "##### Initialize xdg_config end   #####"

bash: ## Install oh-my-bash and link ~/.bachrc
	@echo "##### Initialize oh-my-bash start #####"
	@test -d $(HOME)/.oh-my-bash && echo "oh-my-bash has already exists" || bash -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"; \
	ln -svf $(DOTFILES)/bashrc $(HOME)/.bashrc; \
	source $(HOME)/.bashrc
	@echo "##### Initialize oh-my-bash end   #####"

zsh: ## Install oh-my-zsh and link ~/.zshrc
	@echo "##### Initialize oh-my-zsh start #####"
	@test -d $(HOME)/.oh-my-zsh && echo "oh-my-zsh has already exists" || sh -c "$$(curl -fsSL https://install.ohmyz.sh/)"; \
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
	ln -svf $(DOTFILES)/zshrc $(HOME)/.zshrc; \
	source $(HOME)/.zshrc
	@echo "##### Initialize oh-my-zsh end   #####"

test: ## Run the tests
	@echo "##### Test start #####"
	@echo APPFILES is $(APPFILES)
	@echo DOTFILES is $(DOTFILES)
	@echo OS_NAME is $(OS_NAME)
	@echo CMD_PREFIX is $(CMD_PREFIX)
	@echo PACKAGE_CMD is $(PACKAGE_CMD)
	@echo PACKAGE_NAME is $(PACKAGE_NAME)
	@echo APP_NAME is $(APP_NAME)
	@echo "##### Test end   #####"

clean:
	@echo "##### Clean start #####"
	echo "cleaning step"
	@echo "##### Clean end   #####"


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
