#!/bin/bash
# Set up an Omarchy machine on top of Omarchy's own install. Safe to run again:
# every step skips what is already in place.
#
#   omarchy/setup.sh               all steps, in order
#   omarchy/setup.sh ibus fonts    only these steps
#
# Steps: packages tools tailscale ibus shell ufw docker datagrip chromium paseo
#        fonts bar nouveau
#
# Named setup.sh, not install.sh, so the macOS fresh.sh (which runs every
# */install.sh) leaves it alone. Files this replaces in ~ go to the Trash.
set -euo pipefail

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
backup="$(dirname "$dir")/backup"
trash="${XDG_DATA_HOME:-$HOME/.local/share}/Trash/files/omarchy-setup-$(date +%Y%m%d-%H%M%S)"
font_size=11

[ -d /usr/share/omarchy ] || {
	echo 'This is not an Omarchy machine.' >&2
	exit 1
}

say() { printf '\n==> %s\n' "$*"; }

# Moves ~/$1 into the Trash, if it exists.
set_aside() {
	[ -e "$HOME/$1" ] || [ -L "$HOME/$1" ] || return 0
	mkdir -p "$trash/$(dirname "$1")"
	mv "$HOME/$1" "$trash/$1"
	echo "moved the old ~/$1 to $trash"
}

# ~/.config/$1 becomes a symlink to config/$1 here, so edits land in the repo.
link_config() {
	local home=".config/$1" src="$dir/config/$1"
	[ "$(readlink "$HOME/$home" || true)" != "$src" ] || return 0
	if cmp -s "$src" "$HOME/$home"; then rm "$HOME/$home"; else set_aside "$home"; fi
	mkdir -p "$(dirname "$HOME/$home")"
	ln -s "$src" "$HOME/$home"
	echo "linked ~/$home"
}

# Copies config/$1 to ~/.config/${2:-$1}. For files that Omarchy or the app
# rewrites in place, which would turn a symlink back into a plain file.
copy_config() {
	local home=".config/${2:-$1}" src="$dir/config/$1"
	! cmp -s "$src" "$HOME/$home" || return 0
	set_aside "$home"
	mkdir -p "$(dirname "$HOME/$home")"
	cp "$src" "$HOME/$home"
	echo "copied ~/$home"
}

# The backup repo stores some files encrypted (transcrypt).
backup_ready() {
	if [ ! -d "$backup/.git" ]; then
		echo "Clone the backup repo to $backup first (see omarchy/README.md); skipping." >&2
		return 1
	fi
	if [ "$(head -c 10 "$backup/.zshrc")" = U2FsdGVkX1 ]; then
		echo "$backup is still encrypted; run $backup/scripts/crypt init first; skipping." >&2
		return 1
	fi
}

clone_once() { [ -d "$2" ] || git clone --depth 1 "$1" "$2"; }

step_packages() {
	say 'Packages'
	sudo pacman -S --needed --noconfirm zsh the_silver_searcher tinyxxd glab gitleaks pass kubectl helm ibus
	yay -S --needed --noconfirm --answerdiff None --answerclean None vikey datagrip datagrip-jre
}

step_tools() {
	say 'Tools in ~/.local/bin'
	mkdir -p "$HOME/.local/bin"
	if ! command -v transcrypt >/dev/null; then
		local t
		t=$(mktemp)
		curl -fsSL https://raw.githubusercontent.com/elasticdog/transcrypt/v2.3.2/transcrypt -o "$t"
		echo "d4723d29cee8781de6fa83e5ad2817ad81241674fb4159db6452c1ce9d4b0253  $t" | sha256sum -c --quiet
		install -m 755 "$t" "$HOME/.local/bin/transcrypt"
		rm "$t"
	fi
	# Same installer as ai/install.sh; it also adds dcg's Claude Code hook.
	command -v dcg >/dev/null ||
		curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/destructive_command_guard/main/install.sh?$(date +%s)" | bash -s -- --easy-mode
}

step_tailscale() {
	say 'Tailscale'
	# Omarchy's installer also sets the operator, Taildrop and the bar item.
	omarchy-installed-service-tailscale || omarchy-install-service-tailscale
}

step_ibus() {
	say 'IBus with Vikey instead of Fcitx5'
	link_config environment.d/95-ibus.conf
	link_config uwsm/env.d/60-ibus
	copy_config systemd/user/ibus-daemon.service
	[ -e "$HOME/.config/vikey/settings.json" ] || copy_config vikey/settings.json
	systemctl --user daemon-reload
	systemctl --user mask omarchy-fcitx5.service
	systemctl --user enable ibus-daemon.service
	dconf write /desktop/ibus/general/preload-engines "['vikey', 'xkb:us::eng']"
	echo 'Log out and back in for the input method to change.'
}

step_shell() {
	say 'zsh with Oh My Zsh'
	backup_ready || return 0
	local custom="$HOME/.oh-my-zsh/custom" f
	clone_once https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
	clone_once https://github.com/zsh-users/zsh-autosuggestions "$custom/plugins/zsh-autosuggestions"
	clone_once https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom/plugins/zsh-syntax-highlighting"
	clone_once https://github.com/jessarcher/zsh-artisan.git "$custom/plugins/artisan"
	clone_once https://github.com/dracula/zsh.git "$custom/themes/dracula-zsh"
	ln -sfn "$custom/themes/dracula-zsh/dracula.zsh-theme" "$custom/themes/dracula.zsh-theme"
	ln -sfn "$custom/themes/dracula-zsh/lib" "$custom/themes/lib"
	for f in "$backup"/.oh-my-zsh/custom/*.zsh; do
		ln -sfn "$f" "$custom/$(basename "$f")"
	done
	# Not .zshenv: it sources ~/.cargo/env unconditionally.
	for f in .zshrc .zprofile; do
		[ "$(readlink "$HOME/$f" || true)" = "$backup/$f" ] && continue
		set_aside "$f"
		ln -s "$backup/$f" "$HOME/$f"
	done
	[ "$(getent passwd "$USER" | cut -d: -f7)" = /usr/bin/zsh ] || chsh -s /usr/bin/zsh
}

step_ufw() {
	say 'Firewall'
	local nic lan
	sudo ufw allow 41641/udp comment tailscale
	sudo ufw allow in on tailscale0 to any port 6767 proto tcp comment paseo-tailscale
	# Paseo from the local network this machine is on.
	nic=$(ip -o -4 route show default | awk '{ print $5; exit }')
	lan=$(ip -o -4 route show scope link dev "$nic" | awk '{ print $1; exit }')
	[ -z "$lan" ] || sudo ufw allow from "$lan" to any port 6767 proto tcp comment paseo-lan
}

step_docker() {
	say 'Docker without sudo'
	[[ " $(id -nG) " != *' docker '* ]] || return 0
	sudo usermod -aG docker "$USER"
	echo 'Reboot for the docker group to apply (the systemd user manager keeps the old groups).'
}

step_datagrip() {
	say 'DataGrip'
	local version cfg old
	version=$(jq -r .dataDirectoryName /opt/datagrip/product-info.json)
	cfg="$HOME/.config/JetBrains/$version"
	# Settings from the macOS backup, once, into a config dir DataGrip has not made yet.
	if [ ! -e "$cfg" ] && backup_ready; then
		old=$(find "$backup/Library/Application Support/JetBrains" -maxdepth 1 -name 'DataGrip*' | sort -V | tail -1)
		mkdir -p "$cfg"
		cp -a "$old/." "$cfg/"
		chmod 600 "$cfg/datagrip.key"
		[ -e "$HOME/DataGripProjects" ] || cp -a "$backup/DataGripProjects" "$HOME/DataGripProjects"
		grep -rlIZ '/Users/' "$cfg" "$HOME/DataGripProjects" | xargs -0 -r sed -i -E \
			-e "s#/Users/[^/\"<]+/Library/Application Support/JetBrains/DataGrip[0-9.]+#$cfg#g" \
			-e "s#/Users/[^/\"<]+#$HOME#g"
		echo "restored settings from $old"
	fi
	# Run under XWayland: IBus only reaches Java apps through XIM.
	copy_config JetBrains/datagrip64.vmoptions "JetBrains/$version/datagrip64.vmoptions"
	# The keymap is per OS. The macOS one is Cmd-based, and Super belongs to Hyprland.
	[ -e "$cfg/options/linux/keymap.xml" ] || copy_config JetBrains/keymap.xml "JetBrains/$version/options/linux/keymap.xml"
	[ -d "$HOME/.local/share/JetBrains/$version/keymap-vscode" ] ||
		/opt/datagrip/bin/datagrip.sh installPlugins com.intellij.plugins.vscodekeymap
}

step_chromium() {
	say 'Chromium under XWayland'
	# IBus reaches X11 apps through XIM. On Wayland, Chromium with --gtk-version=4
	# still got no Vikey input on Hyprland.
	sed -i -E -e 's/^--ozone-platform(-hint)?=wayland$/--ozone-platform\1=x11/' \
		-e '/^--gtk-version=4$/d' "$HOME/.config/chromium-flags.conf"
}

step_paseo() {
	say 'Paseo under XWayland'
	local f="$HOME/.local/share/applications/paseo.desktop"
	if [ ! -f "$f" ]; then
		echo "No $f yet; install the Paseo AppImage first; skipping." >&2
		return 0
	fi
	# Paseo exits on Chromium switches it does not know, so Electron is pointed
	# at X11 through the environment. The daemon and the agents it starts inherit
	# it too, so they run without WAYLAND_DISPLAY (wl-copy fails there).
	grep -q '^Exec=env -u WAYLAND_DISPLAY ' "$f" ||
		sed -i 's#^Exec=#Exec=env -u WAYLAND_DISPLAY XDG_SESSION_TYPE=x11 #' "$f"
}

step_fonts() {
	say "Terminal font size $font_size"
	sed -i -E "s/^size = [0-9.]+$/size = $font_size/" "$HOME/.config/alacritty/alacritty.toml"
	sed -i -E "s/^(font=[^:]*):size=[0-9.]+$/\1:size=$font_size/" "$HOME/.config/foot/foot.ini"
	sed -i -E "s/^font-size = [0-9.]+$/font-size = $font_size/" "$HOME/.config/ghostty/config"
	if grep -q '^font_size ' "$HOME/.config/kitty/kitty.conf"; then
		sed -i -E "s/^font_size .*/font_size $font_size.0/" "$HOME/.config/kitty/kitty.conf"
	else
		printf '\nfont_size %s.0\n' "$font_size" >>"$HOME/.config/kitty/kitty.conf"
	fi
}

step_bar() {
	say 'Top bar'
	copy_config omarchy/shell.json
}

step_nouveau() {
	say 'nouveau cursor'
	local f="$HOME/.config/hypr/looknfeel.lua"
	grep -q '^nouveau ' /proc/modules || return 0
	grep -q no_hardware_cursors "$f" && return 0
	cat >>"$f" <<'EOF'

-- nouveau does not display the hardware cursor plane on many older NVIDIA GPUs,
-- leaving the pointer invisible on the physical display. Render it in software.
hl.config({
  cursor = {
    no_hardware_cursors = true,
  },
})
EOF
}

steps=(packages tools tailscale ibus shell ufw docker datagrip chromium paseo fonts bar nouveau)
[ $# -eq 0 ] || steps=("$@")
for s in "${steps[@]}"; do
	declare -F "step_$s" >/dev/null || {
		echo "No such step: $s" >&2
		exit 2
	}
done
for s in "${steps[@]}"; do "step_$s"; done
[ ! -d "$trash" ] || printf '\nReplaced files are in %s\n' "$trash"
