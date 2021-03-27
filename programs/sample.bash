#!/bin/bash

sample () {

  cmd () {
    echo "this is a sample command"
    # code goes here...
  }

  commands () {
    cat <<-EOF
sample commands:
  cmd -> this is a sample command
  another -> this is another example
EOF
  }

  case $1 in
    cmd)
      cmd
      ;;
    another)
      echo "I'm another way to implement commands"
      ;;
    *)
      commands
      ;;
  esac
}
