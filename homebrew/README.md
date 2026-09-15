# Homebrew environments

Run these commands from the repository root. Each Brewfile is an independent
snapshot of its environment; there is no shared base file.

| Environment | Brewfile | Install | Update snapshot |
| --- | --- | --- | --- |
| Personal macOS | `Brewfile-macos` | `make install` | `make dump` |
| Work macOS | `Brewfile-macos-work` | `make install BREW_ENV=macos-work` | `make dump BREW_ENV=macos-work` |
| Linux / WSL | `Brewfile-linux-common` | `make install` | `make dump` |

`BREW_ENV` defaults to `macos` on macOS and `linux-common` on Linux / WSL.
Work Macs must explicitly select `macos-work`. Unknown environments and
environments incompatible with the host OS are rejected.
`make all BREW_ENV=macos-work` also selects the work snapshot during bootstrap.

`make install` bootstraps Homebrew and required Linux system packages, then runs
`brew bundle install --file="..."`. This installs and, by default, upgrades
dependencies in the selected file.

All environments install `font-jetbrains-mono-nerd-font` through Homebrew.
Linux bootstrap packages include `fontconfig`; distribution-specific Powerline
font packages are not required. After a successful bundle install, `make install`
refreshes the Linux font cache with `fc-cache -f`.

The configured font family is `JetBrainsMono Nerd Font Mono`. On a Linux desktop,
verify it with `fc-match 'JetBrainsMono Nerd Font Mono'`, restart the terminal,
and select that family if the terminal is not managed by this repository.
SSH sessions use the client terminal's font; WSL terminals running on Windows
need the font installed and selected on Windows.

`make dump` requires Homebrew to already be installed and runs the corresponding
command below, without bootstrapping or installing packages:

```bash
# Personal macOS
brew bundle dump -f --file ./homebrew/Brewfile-macos

# Work macOS
brew bundle dump -f --file ./homebrew/Brewfile-macos-work

# Linux / WSL
brew bundle dump -f --no-winget --file ./homebrew/Brewfile-linux-common
```

Dump records the current machine's installed packages and overwrites the selected
file. Only dump into the matching environment's snapshot, then inspect its Git
diff before committing. Linux / WSL always excludes WinGet packages from dump.

For a custom file, `BREWFILE` takes precedence over the environment's default path:

```bash
make install BREWFILE=/path/to/Brewfile
make dump BREWFILE=/path/to/Brewfile
```

The environment must still be valid for the host OS; dump flags follow the host
OS even when the file path is overridden.

Use `make test` to inspect resolved variables, or `make -n install` / `make -n dump`
to preview commands. These also accept `BREW_ENV` and `BREWFILE` overrides.
