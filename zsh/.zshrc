
cat -Pp /tmp/gitrepos.log 2>/dev/null
$HOME/bin/checkforupdates.sh &!

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
