#!/usr/bin/env bash

# --- CONFIGURATION ---
ADB_KB="com.android.adbkeyboard/.AdbIME"
PHONE_KB="com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME"

# Editor Actions (The "Blue Button" on your phone keyboard)
# 2=GO, 3=SEARCH, 4=SEND, 5=NEXT, 6=DONE
ACTION_CODE=4 

# --- SETUP ---
echo "Initializing Connection..."
adb shell ime set $ADB_KB > /dev/null

cleanup() {
    echo -e "\n\nExiting... Switching back to Gboard."
    adb shell ime set $PHONE_KB > /dev/null
    exit
}

trap cleanup SIGINT SIGTERM

echo "---------------------------------------"
echo "  ANDROID REMOTE TYPING: ULTIMATE MODE"
echo "---------------------------------------"
echo "  [Type]   -> Sends character"
echo "  [Ctrl+V] -> Pastes Linux Clipboard (wl-paste)"
echo "  [Ctrl+E] -> Hits 'Send/Submit' button"
echo "  [Ctrl+C] -> Exit"
echo "---------------------------------------"

# --- MAIN LOOP ---
while IFS= read -rsn1 char; do
    
    # Get hex value to detect control keys
    hex_val=$(printf '%02x' "'$char")

    case "$hex_val" in
        "7f"|"08")
            # BACKSPACE (Code 67)
            adb shell am broadcast -a ADB_INPUT_CODE --ei code 67 > /dev/null
            echo -ne "\b \b"
            ;;
        "00"|"0a"|"0d")
            # ENTER (Code 66) - Just a new line, does NOT submit
            adb shell am broadcast -a ADB_INPUT_CODE --ei code 66 > /dev/null
            echo ""
            ;;
        "16") 
            # CTRL+V (Hex 16) -> PASTE LINUX CLIPBOARD
            # 1. Capture clipboard content
            clip_content=$(wl-paste)
            
            if [ -z "$clip_content" ]; then
                echo -n "[Empty Clipboard]"
            else
                # 2. Encode to Base64 (handle multi-line, special chars, etc.)
                b64_clip=$(echo -n "$clip_content" | base64 | tr -d '\n')
                
                # 3. Send via ADB
                adb shell am broadcast -a ADB_INPUT_B64 --es msg "$b64_clip" > /dev/null
                echo -n "[Pasted $(echo -n "$clip_content" | wc -c) bytes]"
            fi
            ;;
        "05")
            # CTRL+E (Hex 05) -> SEND / SUBMIT ACTION
            # Sends the specific "Editor Action" (Send, Go, Search, etc.)
            adb shell am broadcast -a ADB_EDITOR_CODE --ei code $ACTION_CODE > /dev/null
            echo -e "\n[SENT ACTION]"
            ;;
        *)
            # REGULAR TEXT (Base64 Encoded for safety)
            b64_char=$(echo -n "$char" | base64 | tr -d '\n')
            adb shell am broadcast -a ADB_INPUT_B64 --es msg "$b64_char" > /dev/null
            echo -n "$char"
            ;;
    esac
done
