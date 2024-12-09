MAINTAINER := yakir
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
    PACKAGE_CMD := brew install
    PACKAGE_NAME := git subversion curl telnet wget
    APP_NAME := iterm2 raycast obsidian visual-studio-code keepassxc
else
    $(error Unsupported operating system: $(OS_NAME))
endif



# main 
.PHONY: all package application clean test
all: test package application clean ## Test then install package and application

# dependencies
dependencies:  ## Install dependencies
	@echo "##### Install dependencies start #####"
	#@echo ">>> Install nerd-fonts"
	#https://www.nerdfonts.com/
	@echo ">>> Install powerline-fonts"
	git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts; \
	/tmp/fonts/install.sh
	@echo "##### Install dependencies end   #####"

#package: dependencies neovim vim zsh ## Install all package
package:  ## Install dependencies and all package
	@echo "##### Install package start #####"
	@if [ "$(OS_NAME)" = "Darwin" ]; then \
		sudo spctl --master-disable; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi; \
	$(CMD_PREFIX) $(PACKAGE_CMD) $(PACKAGE_NAME)
	@echo "##### Install package end   #####"

application:  ## Install application and init config(Only for MacOS)
	@echo "##### Install application start #####"
	@if [ "$(OS_NAME)" != "Darwin" ]; then \
		echo "Unsupported operating system!"; \
	else \
		$(PACKAGE_CMD) $(APP_NAME); \
	fi;
	@echo "##### Install application end   #####"

neovim:  ## Install neovim and init nvim config
	@echo "##### Install neovim start #####"
	#$(CMD_PREFIX) $(PACKAGE_CMD) neovim;
	ln -s $(DOTFILES)/nvim $(HOME)/.config/nvim; \
	nvim +Lazy +qall;
	@echo "##### Install neovim end   #####"

vim:  ## Install vim and init .vimrc
	@echo "##### Install vim start #####"
	$(CMD_PREFIX) $(PACKAGE_CMD) vim; \
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; \
	ln -s $(DOTFILES)/vimrc $(HOME)/.vimrc; \
	vim +PluginInstall +qall; \
	mv $(HOME)/.vim/bundle/vim-colors-solarized/colors/ $(HOME)/.vim/;
	@echo "##### Install vim end   #####"

zsh: oh-my-zsh  ## Install zsh and init .zshrc
	@echo "##### Install zsh start #####"
	$(CMD_PREFIX) $(PACKAGE_CMD) zsh; \
	ln -s $(DOTFILES)/zshrc $(HOME)/.zshrc; \
	source $(HOME)/.zshrc
	@echo "##### Install zsh end   #####"

oh-my-bash:
	@echo ">>> Install oh-my-bash and plugins"
	test -d $(HOME)/.oh-my-bash && echo "oh-my-bash is exists" || bash -c "$$(curl -fsSL https://raw.githubusercontent.com/oh-my-bash/oh-my-bash/master/tools/install.sh)"

oh-my-zsh:
	@echo ">>> Install oh-my-zsh and plugins"
	test -d $(HOME)/.oh-my-zsh && echo "oh-my-zsh is exists" || sh -c "$$(curl -fsSL https://install.ohmyz.sh/)"; \
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting;

test: ## Run the tests
	@echo "##### Test start #####"
	@echo $(APPFILES)
	@echo $(DOTFILES)
	@echo $(OS_NAME)
	@echo $(CMD_PREFIX)
	@echo $(PACKAGE_CMD)
	@echo $(PACKAGE_NAME)
	@echo $(APP_NAME)
	@echo "##### Test end   #####"

clean: ## Clean tmp files
	@echo "##### Clean start #####"
	rm -rf /tmp/fonts/
	@echo "##### Clean end   #####"


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
