#!/bin/bash

source $OMAKUB_PATH/defaults/bash/functions

if [[ -v OMAKUB_FIRST_RUN_CHAT_APPS ]]; then
  apps="$OMAKUB_FIRST_RUN_CHAT_APPS"
else
  AVAILABLE_CHAT_APPS=("WhatsApp" "Signal" "Slack" "Microsoft Teams" "Discord")
  apps=$(gum choose "${AVAILABLE_CHAT_APPS[@]}" --no-limit --height 8 --header "Select chat apps")
fi

if [[ -n "$apps" ]]; then
  IFS=$'\n'
  for app in $apps; do
    case $app in
    "WhatsApp")
      source $OMAKUB_PATH/install/desktop/optional/app-whatsapp.sh
      ;;
    "Signal")
      source $OMAKUB_PATH/install/desktop/optional/app-signal.sh
      ;;
    "Slack")
      source $OMAKUB_PATH/install/desktop/optional/app-slack.sh
      ;;
    "Microsoft Teams")
      source $OMAKUB_PATH/install/desktop/optional/app-teams.sh
      ;;
    "Discord")
      source $OMAKUB_PATH/install/desktop/optional/app-discord.sh
      ;;
    esac
  done
fi
