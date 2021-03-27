# A list of bash aliases for quick shortcuts

# If on linux we need to set pbcopy and pbpaste
if [[ `uname` == 'Linux' ]]; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
    alias f='xdg-open'
elif [[ `uname` == 'Darwin' ]]; then
    alias f='open -a Finder'
fi

# Folder shortcuts for orgs and projects
alias cdi="cd $GITHUB/iqlusioninc/"
alias cdj="cd $GITHUB/jackzampolin/"
alias cdc="cd $GITHUB/cosmos/"
alias cda="cd $GITHUB/althea-net/"
alias cdo="cd $GITHUB/ovrclk/"
alias cdp="cd $GITHUB/peggyjv/"
alias cdt="cd $GITHUB/tendermint/"
alias cdbi="cd $GITHUB/blockstackinc/"
alias cdgh="cd $GITHUB/"

# One letter commands for editor, finder, refresh and clear
alias e='code'
alias r='source ~/.bash_profile'
alias c='clear'

# Modify ls behavior to a standard
alias ls='ls -AFCG'

# Stop and remove all docker containers on the host
alias dc='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Enable influx human readable times
alias influx='influx -precision rfc3339'

# Copy public key to your clipboard
alias pubKey='cat ~/.ssh/id_rsa.pub | pbcopy'

# Copy shrug onto clipboard
alias shrug='echo "¯\_(ツ)_/¯" | pbcopy'

# Terraform
alias tf='terraform'

# Gives a word frequency count of your clipboard
alias freq="pbpaste | tr ' ' '\n' | sort | uniq -c | sort"

# Way to fetch the weather
alias weather='curl wttr.in'

# Easy history grep
alias hgrep='history | grep'

# Copy current repo git sha to clipboard
alias gitsha='git rev-parse --short HEAD | pbcopy'

# Copy current directory to clipboard
alias path='pwd | pbcopy'