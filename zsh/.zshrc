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

export PATH=${PATH}:~/bin
alias dcli="~/mitt/dcli/result/bin/dcli"
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
