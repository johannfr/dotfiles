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
export EDITOR=vim
eval "$(mcfly init zsh)"
alias sudo="sudo "
alias dcli="~/mitt/dcli/result/bin/dcli"
alias alert='echo -e "\a"'
alias ice="ssh -Y ice@192.168.122.66"
alias ipython="nix-shell -p python3Packages.ipython --run ipython"

# Let's use zsh inside interactive nix-shells.
any-nix-shell zsh --info-right | source /dev/stdin

eval "$(direnv hook zsh)"


# Switch to ADB Keyboard (for sending text from Linux)
alias kb-pc='adb shell ime set com.android.adbkeyboard/.AdbIME'

# Switch to Gboard (for typing on the phone)
alias kb-phone='adb shell ime set com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME'

# Function to send text (Auto-switches to PC keyboard, sends text, then switches back to Gboard)
adb-send() {
    # 1. Switch to ADB Keyboard
    adb shell ime set com.android.adbkeyboard/.AdbIME > /dev/null
    
    # 2. Send the text (handling special characters)
    adb shell am broadcast -a ADB_INPUT_TEXT --es msg "$*" > /dev/null
    
    # 3. Switch back to Gboard immediately
    adb shell ime set com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME > /dev/null
    
    echo "Sent: $*"
}
