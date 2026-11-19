# dotfiles
A set of `zsh`, and `tmux` configuration files for Developer on macOS.

## Setting up your Mac
1. Clone onto your machine:
```bash
git clone --recursive https://github.com/hungthai1401/dotfiles.git ~/.dotfiles
```
2. Run the installation with (maybe you  must run `chmod +x ./fresh.sh` before run that file):
```bash
cd ~/.dotfiles && ./fresh.sh
```
3. Clone the private backup repo (log in over HTTPS, there is no SSH key yet) and restore. `scripts/restore` asks for the encryption password, decrypts the secrets, then runs `mackup restore`; mackup would otherwise copy ciphertext into `~`:
```bash
gh auth login
gh repo clone hungthai1401/backup ~/.dotfiles/backup
~/.dotfiles/backup/scripts/restore
```
4. Restart your computer to finalize the process

## Setting up Omarchy
See [omarchy/README.md](omarchy/README.md).

## Backing up
```bash
mackup backup
cd ~/.dotfiles/backup && git add -A && git commit && git push
```
The pre-commit hook blocks the commit if a file listed in `.gitattributes` would go up unencrypted, or if gitleaks finds a secret in a plaintext file; encrypt it with `scripts/crypt add <path>`. See `backup/scripts/crypt` for the other commands.

A machine whose clone predates the encryption needs the password once. Pull first, so `init` can check the password against the encrypted files (it refuses to run before the pull), and don't run `mackup restore` in between:
```bash
cd ~/.dotfiles/backup && git pull && scripts/crypt init
```

## Thanks To...
- https://github.com/dracula/dracula-theme/
- https://pragprog.com/titles/bhtmux2/tmux-2/
- https://github.com/driesvints/dotfiles
- https://github.com/holman/dotfiles
