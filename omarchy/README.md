# Omarchy

`setup.sh` turns a fresh Omarchy install into this setup. Run the whole thing, or name steps: `omarchy/setup.sh ibus fonts`. Every step skips what is already done, so running it again is safe. Anything it replaces in `~` goes to `~/.local/share/Trash/files/omarchy-setup-<time>/`.

| Step | What it does |
| --- | --- |
| `packages` | pacman: zsh, the_silver_searcher, tinyxxd, glab, gitleaks, pass, kubectl, helm, ibus, plus dev CLIs (yq, gh, k9s, delta, shellcheck, httpie...; the full list is in `setup.sh`). AUR: vikey, datagrip, datagrip-jre |
| `tools` | transcrypt 2.3.2 (sha256 pinned) and dcg into `~/.local/bin` |
| `tailscale` | Omarchy's own installer, which asks you to log in |
| `ibus` | IBus with Vikey instead of Fcitx5: env files, `ibus-daemon.service` (panel icon in the Omarchy bar), Fcitx5 masked |
| `shell` | Oh My Zsh with its plugins and the Dracula theme; `.zshrc` and `.zprofile` from the backup repo; login shell set to zsh |
| `ufw` | Tailscale's 41641/udp; Paseo's 6767/tcp from tailscale0 and from the LAN the machine is on |
| `docker` | adds you to the docker group |
| `datagrip` | restores DataGrip settings and `~/DataGripProjects` from the backup repo, runs it under XWayland, sets the VSCode keymap |
| `chromium` | runs Chromium under XWayland (`--ozone-platform=x11`) |
| `fonts` | font size 11 in alacritty, foot, ghostty and kitty |
| `bar` | `config/omarchy/shell.json` |
| `nouveau` | software cursor, only when the nouveau driver is loaded |

## A new machine

```bash
git clone https://github.com/hungthai1401/dotfiles.git ~/.dotfiles
~/.dotfiles/omarchy/setup.sh packages tools
gh auth login
gh repo clone hungthai1401/backup ~/.dotfiles/backup
~/.dotfiles/backup/scripts/crypt init       # asks for the backup password
~/.dotfiles/backup/scripts/omarchy restore  # SSH, git, kube, AI tool configs
~/.dotfiles/omarchy/setup.sh
```

Then reboot. The input method and the docker group only change for a new login, and the systemd user manager outlives a logout while an SSH session is open.

`shell` and `datagrip` read the backup repo, so they skip with a message until it is cloned and decrypted.

Some things stay manual because they need a secret or a browser:

- `glab auth login --hostname gitlab.ggg.com.vn`, plus the HTTPS line in `~/.git-credentials`
- `git clone git@github.com:hungthai1401/password-store.git ~/.password-store` (needs the GPG key)
- the Paseo AppImage in `~/Applications`
- database passwords in DataGrip, which on macOS live in the Keychain and are not in the backup
- the Chromium sync flags (`--oauth2-client-id`, `--oauth2-client-secret`) in `~/.config/chromium-flags.conf`

## Where things live

Files that only this setup owns are symlinked from `config/`, so edits in `~/.config` show up in `git diff` here. That covers the IBus env files in `environment.d` and `uwsm/env.d`. Files that Omarchy or the app rewrites in place are copied instead, because rewriting a symlink leaves a plain file: `ibus-daemon.service`, `shell.json`, the DataGrip VM options and keymap, and the Vikey settings. Copy a changed one back here by hand.

Personal and work files (SSH keys, git identity, kube configs, Claude Code, Paseo, herdr) are not in this public repo. They live in the private backup repo, and `backup/scripts/omarchy` syncs them.

## Why IBus needs help

On Hyprland, IBus reaches GTK and Qt apps through their IM modules and X11 apps through XIM. It has no Wayland input-method protocol. Apps that bypass both get no Vietnamese input:

- Java apps on the Wayland toolkit. DataGrip runs with `-Dawt.toolkit.name=XToolkit` so it goes through XIM.
- Chromium on Wayland, even with `--gtk-version=4`. It runs under XWayland instead.
- Chromium under XWayland is drawn at `GDK_SCALE`. Omarchy sets it to 2 in `~/.config/hypr/monitors.lua`; on a scale-1 monitor set `omarchy_gdk_scale = 1` there, or Chromium and other XWayland apps come out twice as big.
- Paseo, an Electron app. It has no working path yet: it exits on Chromium switches it doesn't know, and under XWayland (forced through the environment) it takes no keyboard input at all. It stays on Wayland, without Vietnamese input.

Fcitx5, Omarchy's default, does implement the Wayland protocol. To go back to it, see the comment in `config/environment.d/95-ibus.conf`.
