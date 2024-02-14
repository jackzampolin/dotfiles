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
  sync   -> check the sync difference between two nodes
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
      if [ -z "$2" ]; then
        echo "Need to input a rpc endpoint for a node that is behind chain tip"
        return 1
      fi
      if [ -z "$3" ]; then
        echo "Need to input a rpc endpoint for a node that is on same network at chain tip"
        return 1
      fi
      date
      local behind=$(curl -sL $2/status | jq -r '.result.sync_info.latest_block_height')
      local tip=$(curl -sL $3/status | jq -r '.result.sync_info.latest_block_height')
      local blocks=$(expr $tip - $behind)
      echo "$2 is $blocks blocks behind $3"
      echo "waiting for 60 seconds to estimate sync speed..."
      sleep 60
      local behind1=$(curl -s: $2/status | jq -r '.result.sync_info.latest_block_height')
      local tip1=$(curl -sL $3/status | jq -r '.result.sync_info.latest_block_height')
      local blocks1=$(expr $tip1 - $behind1)
      local permin=$(expr $blocks - $blocks1)
      echo "syncing $permin per minute $(echo "scale=0; ($blocks1/$permin)/1" | bc) min to tip"
      ;;
    peers)
      curl -s localhost:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id) \(.remote_ip)"'
      ;;
    consstate)
      if [ -z "$2" ]; then
        echo "Need to input a rpc endpoint for a node on a stopped chain that is coming online"
        return 1
      fi
      curl -s $2/consensus_state | jq '.result.round_state.height_vote_set[].prevotes_bit_array'
      ;;
    online)
      curl -s localhost:26657/consensus_state | jq '.result.round_state.height_vote_set[0].prevotes_bit_array'
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
