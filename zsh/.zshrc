# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=${PATH}:~/bin
unalias gm
eval "$(mcfly init zsh)"
#alias vim="hx"
alias sudo="sudo "
alias vim="~/mitt/nixvim/result/bin/nvim"
alias dcli="~/mitt/dcli/result/bin/dcli"
alias alert='echo -e "\a"'
alias ice="ssh -Y ice@192.168.122.66"
