#!/bin/bash

source $OMAKUB_PATH/defaults/bash/functions

AVAILABLE_WEB_APPS=("HEY" "Basecamp" "Gemini" "Chat GPT" "Google Photos" "Google Contacts" "Tailscale")
apps=$(gum choose "${AVAILABLE_WEB_APPS[@]}" --no-limit --height 9 --header "Select web apps to uninstall")

if [[ -n "$apps" ]]; then
  IFS=$'\n'
  for app in $apps; do
    case $app in
    "HEY")
      source "$OMAKUB_PATH/uninstall/app-hey.sh"
      ;;
    "Basecamp")
      source "$OMAKUB_PATH/uninstall/app-basecamp.sh"
      ;;
    "Gemini")
      web2app-remove 'Gemini'
      app2folder-remove 'Gemini.desktop' WebApps
      ;;
    "Chat GPT")
      web2app-remove 'Chat GPT'
      app2folder-remove 'Chat GPT.desktop' WebApps
      ;;
    "Google Photos")
      web2app-remove 'Google Photos'
      app2folder-remove 'Google Photos.desktop' WebApps
      ;;
    "Google Contacts")
      web2app-remove 'Google Contacts'
      app2folder-remove 'Google Contacts.desktop' WebApps
      ;;
    "Tailscale")
      web2app-remove 'Tailscale'
      app2folder-remove 'Tailscale.desktop' WebApps
      ;;
    esac
  done
fi
