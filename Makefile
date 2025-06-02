MAINTAINER := logic
APPFILES := $(CURDIR)/appfiles
DOTFILES := $(CURDIR)/dotfiles
OS_NAME := $(shell uname)
DATE = $(shell DATE)


# check os and setting package
ifeq ($(OS_NAME), Linux)
    # check sudo command
    ifeq ($(shell command -v sudo 2> /dev/null),)
        CMD_PREFIX := su root -c
    else
        CMD_PREFIX := sudo
    endif

    ifneq ($(strip $(shell cat /etc/*release | grep -i 'debian')),)
        PACKAGE_CMD := apt install -y
        PACKAGE_NAME := git subversion curl telnet wget cmake make
    else ifneq ($(strip $(shell cat /etc/*release | grep -i 'fedora')),)
        PACKAGE_CMD := dnf install -y
        PACKAGE_NAME := git subversion curl telnet wget cmake make
    else
        $(error Unsupported operating system: $(OS_NAME))
    endif
else ifeq ($(OS_NAME), Darwin)
    # PACKAGE_CMD := brew install
    # PACKAGE_NAME := git subversion curl telnet wget
    # APP_NAME := iterm2 wezterm raycast obsidian visual-studio-code keepassxc
    PACKAGE_CMD := brew bundle
else
    $(error Unsupported operating system: $(OS_NAME))
endif


.PHONY: all package application clean test
all: test package configure clean ## Test and then install package and configure

dependencies:
	@echo "##### Install dependencies start #####"
	#@echo ">>> Install nerd-fonts"
	#https://www.nerdfonts.com/
	@echo ">>> Install powerline-fonts"
	git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts; \
	/tmp/fonts/install.sh
	@echo "##### Install dependencies end   #####"

package: dependencies ## Install dependencies and all package
	@echo "##### Install package start #####"
	@if [ "$(OS_NAME)" = "Darwin" ]; then \
		sudo spctl --master-disable; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi; \
	$(CMD_PREFIX) $(PACKAGE_CMD) $(PACKAGE_NAME)
	@echo "##### Install package end   #####"

configure: ## Configure neovim, tmux, vim
	@echo "##### Configure start #####"
	@echo ">>> Neovim"
	ln -svF $(DOTFILES)/nvim $(HOME)/.config/nvim; \
	nvim +Lazy +qall;
	@echo ">>> Tmux"
	ln -svF $(DOTFILES)/tmux.conf $(HOME)/.tmux.conf;
	@echo ">>> Vim"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || echo "Path already exists"; \
	ln -svF $(DOTFILES)/vim/vimrc $(HOME)/.vim/vimrc; \
	vim +PluginInstall +qall;
	# mv $(HOME)/.vim/bundle/vim-colors-solarized/colors/ $(HOME)/.vim/;
	@echo ">>> WezTerm"
	ln -svF $(DOTFILES)/wezterm $(HOME)/.config/wezterm;
	@echo "##### Configure end   #####"

bash: ## Install oh-my-bash and init .bachrc
	@echo "##### Bash env start #####"
	test -d $(HOME)/.oh-my-bash && echo "oh-my-bash is exists" || bash -c "$$(curl -fsSL https://raw.githubusercontent.com/oh-my-bash/oh-my-bash/master/tools/install.sh)"; \
	@echo "##### Bash env end   #####"

zsh: ## Install oh-my-zsh and init .zshrc
	@echo "##### Zsh env start #####"
	test -d $(HOME)/.oh-my-zsh && echo "oh-my-zsh is exists" || sh -c "$$(curl -fsSL https://install.ohmyz.sh/)"; \
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
	ln -svf $(DOTFILES)/zshrc $(HOME)/.zshrc; \
	source $(HOME)/.zshrc
	@echo "##### Zsh env end   #####"

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

clean: ## Clean tmp files
	@echo "##### Clean start #####"
	rm -rf /tmp/fonts/
	@echo "##### Clean end   #####"


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
