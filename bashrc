# Change cd behavior to list files when changing directories
cd () {
  builtin cd "$@"
  ls -AFCG
}

# Make a directory and change into it
mcd () {
  if [ -z "$1" ]; then
    echo "create a directory move into it..."
    return
  fi
  mkdir -pv "$1" && cd "$1"
}

# Creates a random 16 char hash
rand () {
  if [ -z "$1" ]; then
    echo "ask for a number of random characters..."
    return
  fi
  cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

# Command to extract archive based on file extension
extract () {
  if [ -f $1 ] ; then
    case $1 in
       *.tar.bz2)   tar xvjf $1    ;;
       *.tar.gz)    tar xvzf $1    ;;
       *.bz2)       bunzip2 $1     ;;
       *.rar)       unrar x $1     ;;
       *.gz)        gunzip $1      ;;
       *.tar)       tar xvf $1     ;;
       *.tbz2)      tar xvjf $1    ;;
       *.tgz)       tar xvzf $1    ;;
       *.zip)       unzip $1       ;;
       *.Z)         uncompress $1  ;;
       *.7z)        7z x $1        ;;
       *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# Sync local dotfile with the ones from this repo
sync () {
  echo "Overwriting $HOME/.bash_profile with $HOME/.dotfiles/bash_profile"
  nohup rm $HOME/.bash_profile > /dev/null
  nohup cp $HOME/.dotfiles/bash_profile $HOME/.bash_profile > /dev/null
  echo "Overwriting $HOME/.gitconfig with $HOME/.dotfiles/gitconfig"
  nohup rm $HOME/.gitconfig  > /dev/null
  nohup cp $HOME/.dotfiles/gitconfig $HOME/.gitconfig > /dev/null
  source $HOME/.bash_profile
}

# jcat pretty prints json in your clipboard
jcat () {
  pbpaste | jq
}

# allows display of python virtual_env if activated
__set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}

# allows PS1 and PROMPT_COMMAND to show git status
__git_prompt ()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  if git diff --quiet 2>/dev/null >&2; then
    git_color="${c_git_clean}"
  else
    git_color=${c_git_dirty}
  fi
  echo " [$git_color$git_branch${c_reset}]"
}

# Removes IP addresses or domains from the known_hosts file.
# Especially useful when creating/destroying cloud infra
rmk () {
  if [ -z "$1" ]; then
    echo "Need to input address to remove from known_hosts..."
    return
  fi
  ssh-keygen -R $1
}

docker_clock() {
  echo "syncing docker clock with local clock..."
  docker run --rm --privileged alpine hwclock -s
}

makegif() {
  if [ -z "$1" ]; then
    echo "Need to input .mp4 file name to compile..."
    return
  fi
  ffmpeg -i $1 -s 600x400 -pix_fmt rgb8 -r 10 -f gif - | gifsicle --optimize=0 --delay=10 > "$(basename $1 .mp4).gif"
}

