---
description: Environment init and install application.
icon: bullseye-arrow
---

# Overview

[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/yakir3/environment/make-test.yml?label=make-test&logo=github&logoColor=white)](https://github.com/yakir3/environment/actions/workflows/make-test.yml)

Use Makefile to init environment and install application.

Application config record.

## How To Use

### Using Makefile

Help info `make help`.

```console
$ make help
all                            Test then install package and application
application                    Install application and init config(Only for MacOS)
clean                          Clean tmp files
dependencies                   Install dependencies
neovim                         Install neovim and init nvim config
package                        Install dependencies and all package
test                           Run the tests
vim                            Install vim and init .vimrc
zsh                            Install zsh and init .zshrc
```

### Application Config

#### iTerm2

```console
# Import config
appfiles/iterm2/iterm2Profile.json

# Import iterm2-color
appfiles/iterm2/Solarized_Darcula.itermcolors
appfiles/iterm2/HaX0R_GR33N.itermcolors
```

#### wireguard

```console
appfiles/wireguard
```

#### sublime-text

```console
appfiles/Preferences.sublime-settings
```

#### SecureCRT

```console
appfiles/SecureCRT.xml
```

#### Raycast

```console
# Import config
appfiles/raycast.rayconfig
```

#### Visual Studio Code

```console
appfiles/vscode.code-profile
```

> Reference:
>
> 1. [HomeBrew Official Website](https://brew.sh)
> 2. [中科大镜像](https://mirrors.ustc.edu.cn/help/brew.git.html)
> 3. [iterm2colors](https://iterm2colorschemes.com/)
> 4. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
> 5. [oh-my-bash](https://github.com/ohmybash/oh-my-bash)
> 6. [Vim Awesome](https://vimawesome.com/)
> 7. [Neovim Awesome](https://github.com/rockerBOO/awesome-neovim)
> 8. [Nerd Fonts](https://www.nerdfonts.com/)
