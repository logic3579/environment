MAINTAINER = yakir
APPFILES = $(CURDIR)/Appfiles
DOTFILES = $(CURDIR)/Dotfiles
OS_NAME := $(shell uname)


# check os
ifeq ($(OS_NAME), Linux)
    ifeq ($(shell cat /etc/*release | grep -i 'debian' | wc -l), 1)
        PACKAGE_CMD := apt install -y
        PACKAGE_NAME := git subversion curl telnet wget cmake make vim zsh
    else ifeq ($(shell cat /etc/*release | grep -i 'fedora' | wc -l), 1)
        PACKAGE_CMD := dnf install -y
        PACKAGE_NAME := git subversion curl telnet wget cmake make vim zsh
    else
        $(error Unsupported operating system: $(OS_NAME))
    endif
else ifeq ($(OS_NAME), Darwin)
    PACKAGE_CMD := brew install
    PACKAGE_NAME := git subversion telnet wget
    APP_NAME := iterm2 sublime-text obsidian visual-studio-code istat-menus keepassxc raycast xmind
else
    $(error Unsupported operating system: $(OS_NAME))
endif



.PHONY: all test clean initenv
all: test install clean ## Execute test, install, clean

install: install-package install-fonts vimrc zshrc install-app ## Operation system environment init then install application(only for MacOS).
	@echo "##### Install start #####"
	@echo "##### Install end   #####"

test: ## Run the tests
	@echo "##### Test start #####"
	@echo $(APPFILES)
	@echo $(DOTFILES)
	@echo $(OS_NAME)
	@echo su root -c "$(PACKAGE_CMD) $(PACKAGE_NAME)"
	@echo $(PACKAGE_CMD) $(APP_NAME)
	@echo "##### Test end   #####"

clean: ## Clean tmp files
	@echo "##### Clean start #####"
	rm -rf /tmp/fonts/
	@echo "##### Clean end   #####"


##### depend #####
.PHONY: install-fonts install-package install-app vimrc zshrc

install-fonts:
	@echo "##### Install fonts start #####"
	@git clone https://github.com/powerline/fonts.git --depth=1 /tmp/fonts; \
	/tmp/fonts/install.sh
	@echo "##### Install fonts end   #####"

install-package:
	@echo "##### Install package start #####"
	@if [ "$(OS_NAME)" = "Darwin" ]; then \
		sudo spctl --master-disable; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi;
	@su root -c "$(PACKAGE_CMD) $(PACKAGE_NAME)"
	@echo "##### Install package end   #####"

install-app:
	@echo "##### Install application start #####"
	@if [ "$(OS_NAME)" = "Darwin" ]; then \
		$(PACKAGE_CMD) $(APP_NAME); \
	fi;
	@echo "##### Install application end   #####"

vimrc:
	@echo "##### Install vimrc start #####"
	@git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim; \
	mkdir -p ~/.vim/colors && cp ~/.vim/bundle/ex-colorschemes/colors/molokai.vim ~/.vim/colors/; \
	cp -a $(DOTFILES)/.vimrc $(HOME)/.vimrc; \
	vim +PluginInstall +qall;
	@echo "##### Install vimrc end   #####"

zshrc: oh-my-zsh
	@echo "##### Install zshrc start #####"
	@git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions; \
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting; \
	cp -a $(DOTFILES)/.zshrc $(HOME)/.zshrc; \
	if which brew &> /dev/null; then \
		BREW_BIN_PATH=$$(dirname `which brew`); \
		sed -i "" "s#BREW_BIN_PATH#$$BREW_BIN_PATH#" $(HOME)/.zshrc || sed -i "s#BREW_BIN_PATH#$$BREW_BIN_PATH#" $(HOME)/.zshrc; \
	else \
		sed -i "" "s#:BREW_BIN_PATH##" $(HOME)/.zshrc || sed -i "s#:BREW_BIN_PATH##" $(HOME)/.zshrc; \
	fi;
	source $(HOME)/.zshrc
	@echo "##### Install zshrc end   #####"

oh-my-bash:
	@echo "##### Install oh-my-bash start #####"
	@test -d $(HOME)/.oh-my-bash && echo "oh-my-bash is exists" || bash -c "$$(curl -fsSL https://raw.githubusercontent.com/oh-my-bash/oh-my-bash/master/tools/install.sh)"
	@echo "##### Install oh-my-bash end   #####"

oh-my-zsh:
	@echo "##### Install oh-my-zsh start #####"
	@test -d $(HOME)/.oh-my-zsh && echo "oh-my-zsh is exists" || sh -c "$$(curl -fsSL https://install.ohmyz.sh/)"
	@echo "##### Install oh-my-zsh end   #####"


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
