# Load programs folder
for file in $HOME/.dotfiles/programs/*; do
  [[ -s "$file" ]] && source "$file"
done

# Load utility functions
[[ -s "$HOME/.dotfiles/bashrc" ]] && source $HOME/.dotfiles/bashrc

# Load environmental variables
[[ -s "$HOME/.dotfiles/environment.bash" ]] && source $HOME/.dotfiles/environment.bash

# Load environmental variables
[[ -s "$HOME/.dotfiles/secrets.bash" ]] && source $HOME/.dotfiles/environment.bash

# Load bash aliases
[[ -s "$HOME/.dotfiles/aliases.bash" ]] && source $HOME/.dotfiles/aliases.bash

# Load gaiad and gaiacli completions
eval $(gaiacli completion)
eval $(gaiad completion)

# Load in secrets file, a file for API keys and the such not saved in version control
if [ ! -z "$HOME/.dotfiles/secrets.bash" ]; then
  source "$HOME/.dotfiles/secrets.bash"
else
  echo "no secrets file defined, add one with 'touch $HOME/.dotfiles/secrets.bash'"
fi

# Load the gcloud sdk and associated binaries
if [ ! -z "$HOME/.google-cloud-sdk/path.bash.inc" ] && [ ! -z "$HOME/.google-cloud-sdk/completion.bash.inc" ]; then
  source "$HOME/.google-cloud-sdk/path.bash.inc"
  source "$HOME/.google-cloud-sdk/completion.bash.inc"
else 
  echo "gcloud not installed"
fi

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Intro message.  Shows $USER and hostname.
echo "Logged in as $USER at $(hostname). The time is $(date "+%H:%M"), good luck..."
