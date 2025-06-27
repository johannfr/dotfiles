# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


my_repositories=(
  "${HOME}/vinna/isds"
  "${HOME}/vinna/ice"
  "${HOME}/vinna/envdata"
  "${HOME}/mitt/nixvim"
  "${HOME}/dotfiles"
  "/etc/nixos"
)
for repo in ${my_repositories[@]} ; do
  if [ -d "${repo}" ]; then
    if git -C ${repo} status --porcelain | grep -q .; then
      echo "Uncommitted changes in: ${repo}"
    fi
  fi
done

function configupdate() {
  for repo in ${my_repositories[@]} ; do
    if $(echo ${repo} | grep -qv "vinna") ; then
      echo "Pulling ${repo}"
      git -C ${repo} pull
    fi
  done
}

up-line-or-local-history() {
  zle set-local-history 1
  zle up-line-or-history
  zle set-local-history 0
}
zle -N up-line-or-local-history

down-line-or-local-history() {
  zle set-local-history 1
  zle down-line-or-history
  zle set-local-history 0
}
zle -N down-line-or-local-history

bindkey "${key[Up]}" up-line-or-local-history
bindkey "${key[Down]}" down-line-or-local-history


export PATH=${PATH}:~/bin
unalias gm
eval "$(mcfly init zsh)"
alias sudo="sudo "
alias dcli="~/mitt/dcli/result/bin/dcli"
alias alert='echo -e "\a"'
alias ice="ssh -Y ice@192.168.122.66"

# Let's use zsh inside interactive nix-shells.
any-nix-shell zsh --info-right | source /dev/stdin
