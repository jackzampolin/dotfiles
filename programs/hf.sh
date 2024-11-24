function hf() {
    local CACHE_DIR="$HOME/.cache/huggingface/hub"
    local NOHUP_DIR="$HOME/.nohup"
    mkdir -p "$NOHUP_DIR" # Make sure directory exists

    case "$1" in
    "ls")
        echo "Cached models:"
        for model in "$CACHE_DIR/models--"*; do
            if [ -d "$model" ]; then
                # Strip prefix and replace -- with /
                echo "  $(basename "$model" | sed 's/models--//' | sed 's/--/\//')"
            fi
        done
        ;;
    "size")
        du -sh "$CACHE_DIR"/models--*
        ;;
    "clean")
        if [ -z "$2" ]; then
            echo "Usage: hf clean <model-name>"
            echo "Example: hf clean meta-llama/Llama-2-7b"
            return 1
        fi
        local MODEL_DIR="$CACHE_DIR/models--${2//\//-}-"
        rm -rf "$MODEL_DIR"*
        echo "Cleaned $2"
        ;;
    "download")
        if [ -z "$2" ]; then
            echo "Usage: hf download <model-name>"
            echo "Example: hf download meta-llama/Llama-2-7b"
            return 1
        fi
        # Use full path for log file
        local LOG="$NOHUP_DIR/hf-${2//\//-}.log"
        echo "Starting download of $2 in background"
        nohup python -c "from huggingface_hub import snapshot_download; snapshot_download('$2')" >"$LOG" 2>&1 &
        echo "PID: $!"
        echo "Log: $LOG"
        ;;
    "logs")
        if [ -z "$2" ]; then
            echo "Usage: hf logs <model-name>"
            return 1
        fi
        tail -f "$NOHUP_DIR/hf-${2//\//-}.log"
        ;;
    *)
        echo "Usage:"
        echo "  hf ls                    # List cached models"
        echo "  hf size                  # Show size of cached models"
        echo "  hf clean <model>         # Remove model from cache"
        echo "  hf download <model>      # Download model in background"
        echo "  hf logs <model>          # Show download logs"
        ;;

    esac
}
