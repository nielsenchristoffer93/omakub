#!/bin/bash

source $OMAKUB_PATH/defaults/bash/functions

AVAILABLE_CHAT_APPS=("WhatsApp" "Signal" "Slack" "Microsoft Teams" "Discord")
apps=$(gum choose "${AVAILABLE_CHAT_APPS[@]}" --no-limit --height 8 --header "Select chat apps to uninstall")

if [[ -n "$apps" ]]; then
  IFS=$'\n'
  for app in $apps; do
    case $app in
    "WhatsApp")
      source $OMAKUB_PATH/uninstall/app-whatsapp.sh
      ;;
    "Signal")
      source $OMAKUB_PATH/uninstall/app-signal.sh
      ;;
    "Slack")
      source $OMAKUB_PATH/uninstall/app-slack.sh
      ;;
    "Microsoft Teams")
      source $OMAKUB_PATH/uninstall/app-teams.sh
      ;;
    "Discord")
      source $OMAKUB_PATH/uninstall/app-discord.sh
      ;;
    esac
  done
fi
