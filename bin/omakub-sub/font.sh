#!/bin/bash

set_font() {
	local font_name=$1
	local url=$2
	local file_type=$3
	local file_name="${font_name/ Nerd Font/}"

	if ! $(fc-list | grep -i "$font_name" >/dev/null); then
		cd /tmp
		wget -O "$file_name.zip" "$url"
		unzip "$file_name.zip" -d "$file_name"
		cp "$file_name"/*."$file_type" ~/.local/share/fonts
		rm -rf "$file_name.zip" "$file_name"
		fc-cache
		cd -
		clear
		source $OMAKUB_PATH/ascii.sh
	fi

	gsettings set org.gnome.desktop.interface monospace-font-name "$font_name 10"
	cp "$OMAKUB_PATH/configs/alacritty/fonts/$file_name.toml" ~/.config/alacritty/font.toml

	EDITOR_SETTINGS=(
		"$HOME/.config/Code/User/settings.json"
		"$HOME/.config/Antigravity/User/settings.json"
		"$HOME/.config/Antigravity IDE/User/settings.json"
		"$HOME/.config/antigravity/User/settings.json"
	)

	for settings_file in "${EDITOR_SETTINGS[@]}"; do
		if [ -f "$settings_file" ]; then
			if grep -q "editor.fontFamily" "$settings_file" 2>/dev/null; then
				sed -i "s/\"editor.fontFamily\": \".*\"/\"editor.fontFamily\": \"$font_name\"/g" "$settings_file"
			else
				sed -i "1s/^{/{\n  \"editor.fontFamily\": \"$font_name\",/" "$settings_file" 2>/dev/null || true
			fi
		fi
	done
}

if [ "$#" -gt 1 ]; then
	choice=${!#}
else
	choice=$(gum choose "Cascadia Mono" "Fira Mono" "JetBrains Mono" "Meslo" "> Change size" "<< Back" --height 8 --header "Choose your programming font")
fi

case $choice in
"Cascadia Mono")
	set_font "CaskaydiaMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip" "ttf"
	;;
"Fira Mono")
	set_font "FiraMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraMono.zip" "otf"
	;;
"JetBrains Mono")
	set_font "JetBrainsMono Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" "ttf"
	;;
"Meslo")
	set_font "MesloLGS Nerd Font" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip" "ttf"
	;;
"> Change size")
	source $OMAKUB_PATH/bin/omakub-sub/font-size.sh
	exit
	;;
esac

source $OMAKUB_PATH/bin/omakub-sub/menu.sh
