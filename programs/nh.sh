function nh() {
    local NOHUP_DIR="$HOME/.nohup"
    mkdir -p "$NOHUP_DIR"

    case "$1" in
    "run")
        shift
        local DESC="$1"
        shift
        local LOG="$NOHUP_DIR/${DESC}.log"
        local PID_FILE="$NOHUP_DIR/${DESC}.pid"

        # Source zshrc and venv, then run hf function directly from programs
        local SETUP_CMD="source $HOME/.$(basename $SHELL)rc; "
        if [ -n "$VIRTUAL_ENV" ]; then
            SETUP_CMD+="source $HOME/.venvs/$(basename "$VIRTUAL_ENV")/bin/activate; "
        fi
        SETUP_CMD+="source $HOME/.dotfiles/programs/hf.sh; "

        nohup bash -c "$SETUP_CMD $*" >"$LOG" 2>&1 &
        echo $! >"$PID_FILE"
        echo "Started $DESC (PID: $!)"
        echo "Log: $LOG"
        ;;
    "ls")
        echo "Running processes:"
        for pid_file in "$NOHUP_DIR"/*.pid; do
            if [ -f "$pid_file" ]; then
                local DESC=$(basename "$pid_file" .pid)
                local PID=$(cat "$pid_file")
                if kill -0 "$PID" 2>/dev/null; then
                    echo "$DESC: $PID (running)"
                else
                    echo "$DESC: $PID (stopped)"
                fi
            fi
        done
        ;;
    "tail")
        tail -f "$NOHUP_DIR/$2.log"
        ;;
    "kill")
        if [ -f "$NOHUP_DIR/$2.pid" ]; then
            kill $(cat "$NOHUP_DIR/$2.pid")
            rm "$NOHUP_DIR/$2.pid"
            echo "Killed $2"
        else
            echo "No such process: $2"
        fi
        ;;
    *)
        echo "Usage:"
        echo "  nh run <name> <command>  # Start command"
        echo "  nh ls                    # List processes"
        echo "  nh tail <name>           # Tail logs"
        echo "  nh kill <name>           # Kill process"
        ;;
    esac
}
