#!/bin/bash

# A series of commands with the general theme of fudging frustration
# A subtheme of things that fudging annoy you
fudging () {

  commands () {
    cat <<-EOF
fudging commands:
  wifi   -> cycle your wifi on and off
  images -> clean up docker images by removing dangling ones
  ds     -> delete all .DS_Store files
  remote -> sync a fork with the upstream branch of choice
  port   -> find which process is running on a port
  peers  -> dump the peers of the cosmos chain at localhost:26657
EOF
  }

  case $1 in
    wifi)
      wifi
      ;;
    ds)
      echo "Fudging .DS_Strore files..."
      sleep 1
      echo "Littering my ls results..."
      sleep 1
      sudo find / -name ".DS_Store" -depth -exec rm {} \;
      echo "Begone!"
      ;;
    images)
      echo "Dangling docker images..."
      sleep 1
      echo "Making my docker images results unreadable..."
      nohup docker rmi $(docker images -f dangling=true -q) > /dev/null
      echo "Die the eternal death!"
      ;;
    remote)
      if [ -z "$2" ]; then
        echo "Need to input fudging branch to sync..."
      else
        git fetch upstream
        git checkout $2
        git merge upstream/$2
        git push
      fi
      ;;
    port)
      if [ -z "$2" ]; then
        echo "Need to input a fudging port check"
      else
        echo "Fudging port blocking my shit..."
          if [[ `uname` == 'Linux' ]]; then
            netstat -tulpn | grep $2
          elif [[ `uname` == 'Darwin' ]]; then
            lsof -nP -i4TCP:$2 | grep LISTEN
          fi
      fi
      ;;
    sync)
      date
      TIP=$(curl -s localhost:26657/status | jq -r '.result.sync_info.latest_block_height')
      BEHIND=$(curl -s hub.technofractal.com:26657/status | jq -r '.result.sync_info.latest_block_height')
      echo "hub.technofractal.com is $(expr $TIP - $BEHIND) blocks behind sentries"
      ;;
    peers)
      curl -s localhost:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id) \(.remote_ip)"'
      ;;
    *)
      commands
      ;;
  esac
}

wifi () {
  if [[ `uname` == 'Linux' ]]; then
    nmcli radio wifi off
  elif [[ `uname` == 'Darwin' ]]; then
    networksetup -setairportpower en0 off
  fi

  sleep 1
  echo "Threads of the ether"
  sleep 1
  echo "Wifi, why u so slow today"
  sleep 1
  echo "On off maybe help?"

  if [[ `uname` == 'Linux' ]]; then
    nmcli radio wifi on
  elif [[ `uname` == 'Darwin' ]]; then
    networksetup -setairportpower en0 on
  fi
}