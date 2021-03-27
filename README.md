# `.dotfiles`

This repo contains Jack's `.dotfiles`. Everything to control the terminal environment. To install initially run:

```
$ git clone git@github.com/jackzampolin/dotfiles ~/.dotfiles
$ cp ~/.dotfiles/bash_profile ~/.bash_profile
$ source ~/.bash_profile
$ sync
```

The inventory of this repo is as follows:

- `bash_profile`: This file is the authoritative version of the `$HOME/.bash_profile` for my computers. There is a command (`sync`) to copy it and other global config files over into their proper locations. It links all the other commands and `ENV` that are contained in this folder.
- `bashrc`: Contains one off functions like `extract`, `mcd`, and `sync`. If you need to define a new function, start here.
- `aliases.bash`: Contains all the different bash aliases. Mainly used for project directory shortcuts.
- `gitconfig`: A copy of my global gitconfig to be synced to `$HOME/.gitconfig`.
- `environment.bash`: Set `ENV` here. Also contains `$PS1` and `$PATH`.
- `secrets.bash`: API Keys and such that are set as `ENV`, not kept in version control. Also programs not for git history
- `programs/`: A folder for fun programs!
  * `fudging.bash`: A program for the things that `fudging annoy` you on your computer. That fudging wifi, those fudging docker images and other fudging things.
  * `git-completion.bash`: Helps display the git branch on my terminal and also completes the branches for me.
  * `sample.bash`: A sample program to help you get started writing your own bash code.
- `secrets/`: A folder to be synced to S3 or Google Storage. Probably encrypt the files in here somehow. This folder is not kept in version control. (This feature is still in development)

### `TODO`

- Add the secrets folder with sync to Google Storage.
- Add `install` program and have list of programs to install when bootsrapping a new machine.
- Add `curl https://githubusercontent | bash -` install for servers
