#!/usr/bin/env bash

tempfile="$(mktemp --suffix=.png)"
grim -g "$(slurp -w 4)" "${tempfile}"
chmod ugo+r "${tempfile}"

function action_menu() {
  menu_items=(
    "clipboard"
    "Vista í klemmuspjald"
    "sftp-vinir"
    "SFTP Vinir"
    "sftp-jof"
    "SFTP temp-jof"
    "sftp-mech"
    "SFTP docs/mechanical"
    "save"
    "Vista í skrá"
  )

  for i in $(seq 0 $(( ${#menu_items[@]} - 1 ))); do
    if [[ $(($i % 2)) -eq 1 ]]; then
      echo "${menu_items[$i]}"
    fi
  done | wofi --show dmenu -p "Select screenshot action:" -i | while read selected_item ; do
  for i in $(seq 0 $(( ${#menu_items[@]} - 1 ))); do
    if [[ $(($i % 2)) -eq 1 ]]; then
      printf -v current_item "%s" "${menu_items[$i]}"
      if [[ "$current_item" == "$selected_item" ]]; then
        corresponding_item=$((i - 1))
        echo -n "${menu_items[$corresponding_item]}"
        break
      fi
    fi
  done
done
}

action="$(action_menu)"

if [[ -z "${action}" ]] ; then
    echo "No selection"
    rm -f "${tempfile}"
    exit
fi
echo "Selected action: ${action}"
case "${action}" in
    clipboard)
        wl-copy -t image/png < "${tempfile}"
        rm -f "${tempfile}"
        ;;
    sftp-vinir)
        scp "${tempfile}" jof@jof.guru:/var/www/html/temppics
        rm -f "${tempfile}"
        ;;
    sftp-jof)
        scp "${tempfile}" jof@jof.guru:/var/www/html/temp-jof
        echo "https://jof.guru/temp-jof/$(basename "${tempfile}")" | wl-copy
        rm -f "${tempfile}"
        ;;
    sftp-mech)
        new_filename="$(zenity --entry --text Nafn:)"
        echo "${new_filename}" | wl-copy
        scp "${tempfile}" jof@jof.guru:/var/www/html/docs/mechanical/${new_filename}
        rm -f "${tempfile}"
        ;;
    save)
        echo "${tempfile}" | wl-copy
        ;;
    *)
        ;;
esac
