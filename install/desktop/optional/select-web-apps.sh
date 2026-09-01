#!/bin/bash

source $OMAKUB_PATH/defaults/bash/functions

AVAILABLE_WEB_APPS=("HEY" "Basecamp" "Gemini" "Chat GPT" "Google Photos" "Google Contacts" "Tailscale")
apps=$(gum choose "${AVAILABLE_WEB_APPS[@]}" --no-limit --height 9 --header "Select web apps")

if [[ -n "$apps" ]]; then
  IFS=$'\n'
  for app in $apps; do
    case $app in
    "HEY")
      source "$OMAKUB_PATH/install/desktop/optional/app-hey.sh"
      ;;
    "Basecamp")
      source "$OMAKUB_PATH/install/desktop/optional/app-basecamp.sh"
      ;;
    "Gemini")
      web2app 'Gemini' https://gemini.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-gemini.png
      app2folder 'Gemini.desktop' WebApps
      ;;
    "Chat GPT")
      web2app 'Chat GPT' https://chatgpt.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png
      app2folder 'Chat GPT.desktop' WebApps
      ;;
    "Google Photos")
      web2app 'Google Photos' https://photos.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-photos.png
      app2folder 'Google Photos.desktop' WebApps
      ;;
    "Google Contacts")
      web2app 'Google Contacts' https://contacts.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-contacts.png
      app2folder 'Google Contacts.desktop' WebApps
      ;;
    "Tailscale")
      web2app 'Tailscale' https://login.tailscale.com/admin/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/tailscale-light.png
      app2folder 'Tailscale.desktop' WebApps
      ;;
    esac
  done
fi
