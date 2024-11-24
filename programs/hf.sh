function hf() {
   local CACHE_DIR="$HOME/.cache/huggingface/hub"
   
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
           python -c "from huggingface_hub import snapshot_download; snapshot_download('$2')"
           ;;
       *)
           echo "Usage:"
           echo "  hf ls                    # List cached models"
           echo "  hf size                  # Show size of cached models"
           echo "  hf clean <model>         # Remove model from cache"
           echo "  hf download <model>      # Download model to cache"
           ;;
   esac
}
