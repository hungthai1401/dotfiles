# reload zsh config
alias reload!="source $HOME/.zshrc"

# Filesystem
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Git
alias lzg="lazygit"
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force-with-lease"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias prune="git fetch --prune"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# tmux
alias ta="tmux attach"
alias tat="tmux attach -t"
alias td="tmux detach"
alias tls="tmux ls"
alias tns="tmux new-session -s"

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo \"=> Public key copied to pasteboard.\""

# Docker
alias d="docker $*"
alias dc="docker-compose $*"
alias lzd="lazydocker"

# Public IP
# https://laravel-news.com/get-a-servers-public-ip-address-with-php
alias ip='dig @resolver4.opendns.com myip.opendns.com +short'
alias ip6='dig @resolver1.opendns.com AAAA myip.opendns.com +short -6'
