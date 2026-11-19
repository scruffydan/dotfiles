. ~/dotfiles/zsh/env
. ~/dotfiles/zsh/config
. ~/dotfiles/zsh/aliases

if [[ -o interactive && -n "${REX_SESSION:-}" ]]; then
  ~/dotfiles/scripts/rex-ensure-main
fi

# Run uptime command at launch (interactive shells only)
[[ -o interactive ]] && uptime
