
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

HOST_NAME=$(hostname | cut -d"." -f1)

# Custom config
export GLOBAL_PATH="/Users/${HOST_NAME}/Projects"
source ~/Projects/repos/oh_my_bash/prompt.sh
source ~/Projects/repos/oh_my_bash/custom.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export BAT_THEME="Catppuccin Mocha"
export EDITOR="code --wait"
export VISUAL="code --wait" 

# NVM config
export NVM_DIR="/Users/byverdu-air/.nvm"
[ -s /Users/byverdu-air/.nvm/nvm.sh ] && \. /Users/byverdu-air/.nvm/nvm.sh
[ -s "/Users/byverdu-air/.nvm/bash_completion" ] && \. "/Users/byverdu-air/.nvm/bash_completion"

# pnpm
export PNPM_HOME="/Users/byverdu-air/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

eval "$(zoxide init zsh)"

# fzf config
source <(fzf --zsh)
# Shell integration: Ctrl-T (files), Ctrl-R (history), Alt-C (cd), ** + Tab (completion)
source <(fzf --zsh)

# Use fd as the file source (respects .gitignore, skips node_modules/.git)
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Syntax-highlighted file preview on Ctrl-T
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"

# Search and open in VS Code (swap `code` for vim, nvim, etc.)
alias fe='fzf --bind "enter:become(code {})"'
export FZF_DEFAULT_OPTS=$'--style=full:sharp
  --layout=reverse
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8,fg+:#cdd6f4,bg+:#313244
  --color=hl+:#f38ba8,info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc
  --color=marker:#f8ebe8,spinner:#f5e0dc,header:#f38ba8,border:#585b70
  --color=gutter:#313244'

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
