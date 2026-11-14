# oh_my_bash

Personal collection of shell scripts, dotfiles, and setup notes for a macOS
development machine, plus a few Linux server and Raspberry Pi guides. It covers
machine bootstrap, a custom zsh prompt, git and GitHub helpers, nginx and SSL
setup, and a pre-push test hook.

## Contents

| Path                                   | Type     | Purpose                                                                                                                                                     |
| -------------------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [init.sh](./init.sh)                   | Script   | Entry point for a fresh Mac. Optionally installs Xcode Command Line Tools and Homebrew, shows hidden files in Finder, then runs `custom.sh` and `setup.sh`. |
| [setup.sh](./setup.sh)                 | Script   | Installs apps, fonts, and CLI tools with Homebrew, sets global git identity, and appends the shell configuration to `~/.zshrc`.                             |
| [custom.sh](./custom.sh)               | Script   | Shared aliases and shell functions (git shortcuts, `killport`, `findAndMove`, `create_repo`, and others). Sourced from `~/.zshrc`.                          |
| [prompt.sh](./prompt.sh)               | Script   | Custom zsh prompt. Shows user and time, current directory, git branch and status icons, and the last non-zero exit code.                                    |
| [git_repos.sh](./git_repos.sh)         | Script   | Creates a local git repo, a GitHub repo with `gh`, and pushes the initial commit to `master`.                                                               |
| [pre-push-hook.sh](./pre-push-hook.sh) | Git hook | Husky pre-push hook. Runs frontend or component tests only when those folders changed compared to `origin/<branch>`.                                        |
| [nginx_setup.sh](./nginx_setup.sh)     | Script   | Creates an nginx reverse-proxy server block for a domain and port, opens the port with `ufw`, and optionally enables Let's Encrypt SSL with HTTP/2.         |
| [config files/](./config%20files)      | Dotfiles | `.zshrc` and `.vimrc` used as the reference configuration.                                                                                                  |
| [digitalOcean.md](./digitalOcean.md)   | Notes    | Ubuntu server setup on DigitalOcean: users, firewall, zsh, Node, nginx, certbot, and Docker.                                                                |
| [raspberrypi.md](./raspberrypi.md)     | Notes    | Raspberry Pi setup: exFAT, Samba, Plex, static IP, and ExpressVPN.                                                                                          |
| [sshConfig.md](./sshConfig.md)         | Notes    | Using two GitHub accounts on one machine with separate SSH keys and host aliases.                                                                           |
| [snippets.md](./snippets.md)           | Notes    | Code snippets, including PostCSS color functions and a webpack config.                                                                                      |

## Requirements

- macOS for `init.sh`, `setup.sh`, `prompt.sh`, and `custom.sh`. Some aliases
  use macOS-only commands such as `ipconfig`, `open`, and `brew`.
- [Homebrew](https://brew.sh) (installed by `init.sh` if you choose)
- [GitHub CLI](https://cli.github.com) (`gh`) for `create_repo` and
  `git_repos.sh`
- zsh, with
  [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and
  [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
  `setup.sh` installs both.
- Optional: `fzf`, `zoxide`, `bat`, `fd`, `fnm`, which `setup.sh` installs and
  the dotfiles use.

## Installation

The scripts expect the repo to live at `~/Projects/repos/oh_my_bash`, because
`prompt.sh`, `custom.sh`, and the generated `~/.zshrc` source from that path.

```bash
mkdir -p ~/Projects/repos
git clone <this-repo-url> ~/Projects/repos/oh_my_bash
cd ~/Projects/repos/oh_my_bash

# Bootstrap a new Mac (prompts before each step)
./init.sh
```

To run only the package and shell setup on a machine that already has Homebrew:

```bash
./setup.sh
```

`setup.sh` appends a block to `~/.zshrc`. Run it once, or the block will be
duplicated.

## Usage

### Shell helpers (`custom.sh`)

Once sourced, these are available in your shell:

| Command                                   | What it does                                                                        |
| ----------------------------------------- | ----------------------------------------------------------------------------------- |
| `g-a`, `g-c`, `g-ac`, `g-s`, `g-b`, `g-o` | Shortcuts for `git add`, `commit -m`, `commit -am`, `status`, `branch`, `checkout`. |
| `g-hi`                                    | Compact graph view of the git log.                                                  |
| `g-name`                                  | Amend the last commit's author.                                                     |
| `g-d`                                     | Delete every local branch except `master`.                                          |
| `killport <port>`                         | Kill the process listening on a TCP port.                                           |
| `ports`                                   | List listening sockets.                                                             |
| `myip`                                    | Print the local IP address (macOS).                                                 |
| `server`                                  | Start a Python HTTP server on port 8888.                                            |
| `findAndMove <pattern> <dest>`            | Move files in the current folder matching a name pattern into `dest`.               |
| `getAllFiles <dir> <ext>`                 | Write the paths of all files with a given extension to `<ext>Files.txt`.            |
| `removeNumbersFromFileName`               | Strip leading numbers and hyphens from file names in the current folder.            |
| `fe`                                      | Fuzzy-find a file with `fzf` and open it in VS Code.                                |
| `cd`                                      | Aliased to `zoxide` (`z`), so it jumps to frequently used folders.                  |

### Creating a repository

```bash
create_repo my-new-project
```

This creates `$GLOBAL_PATH/repos/my-new-project`, runs `git init`, adds a
README, `.gitignore`, and `package.json`, creates a public GitHub repo with
`gh`, and pushes to `main`. `git_repos.sh` does the same from the command line,
but pushes to `master`.

### Prompt

`prompt.sh` sets `PS1` to a two-line prompt:

- Segments for `user@HH:MM` and the current directory
- Git branch, with icons for added (`✚`), modified (`✹`), deleted (`✖`), renamed
  (`➜`), conflicted (`═`), and untracked (`✭`) files, or `✔` when clean
- A `👻` segment with the reason when the last command failed (for example
  `Error`, `Usage`, `Not Found`, or `Canceled`)

The prompt uses zsh-specific syntax (`setopt PROMPT_SUBST`), so it only works in
zsh.

### Nginx reverse proxy

```bash
# Proxy example.com to localhost:3000 over HTTP
sudo ./nginx_setup.sh example.com 3000

# Same, and enable Let's Encrypt SSL with HTTP/2
sudo ./nginx_setup.sh example.com 3000 ssl
```

Requirements: nginx, `ufw`, and, for SSL, `certbot` with the nginx plugin. The
script writes to `/etc/nginx/sites-available`, enables the site, opens the port,
and reloads nginx. It does not check for an existing config with the same name,
so review `/etc/nginx/sites-available` before rerunning it.

### Pre-push hook

`pre-push-hook.sh` is written for [Husky](https://typicode.github.io/husky/) and
a monorepo layout with `libs/components/src/lib` and `apps/frontend/src`. It
compares the working branch with `origin/<branch>`:

- If the component library changed, it runs
  `npm run test:frontend && npm run test:components`.
- If only the frontend changed, it runs `npm run test:frontend`.
- If neither changed, it skips the tests.

To use it, copy it to `.husky/pre-push` in the target project and adjust the
folder variables and npm scripts.

## Configuration

Several values are hard-coded for the original author. Change them before
reusing the scripts:

- **Git identity:** `setup.sh`, `git_repos.sh`, and `custom.sh` (`create_repo`)
  set a name and email. Update them to your own.
- **GitHub SSH host:** `create_repo` and `git_repos.sh` use
  `git@github.com-byverdu:`, which is a host alias from
  [sshConfig.md](./sshConfig.md).
- **Paths:** `setup.sh` and `init.sh` use `/Users/<name>/...` and the
  `~/Projects/repos/oh_my_bash` location. `config files/.zshrc` contains a
  hard-coded NVM and pnpm path. Replace them with your own.
- **Homebrew packages:** `setup.sh` installs a long list of casks and formulae.
  Comment out any you don't need.

## Dotfiles

`config files/.zshrc` shows the full setup that `setup.sh` writes to `~/.zshrc`.
It also includes:

- `fzf` integration with `fd` and `bat` previews, and a Catppuccin Mocha color
  scheme
- `EDITOR` and `VISUAL` set to `code --wait`
- A Kiro CLI shell integration block, which can be removed if you don't use it

`config files/.vimrc` is a Vim configuration.

## Notes

- Several scripts run `sudo` or change system settings. Read them before
  running.
- `init.sh` and `setup.sh` are interactive or install many packages. Run them on
  a machine you are prepared to change.
- `custom.sh` defines `cd` as `z` (zoxide). Scripts that rely on the builtin
  `cd` should not source it.
- The `.md` files are reference notes, not runnable scripts. Commands in them
  are meant to be copied one at a time.
