function ve() {
   local VENV_DIR="$HOME/.venvs"
   mkdir -p "$VENV_DIR"

   case "$1" in
       "new")
           if [ -z "$2" ]; then
               echo "Usage: venv new <name> [python-version]"
               return 1
           fi
           local VENV_NAME="$2"
           local PYTHON_VERSION="${3:-python3}"
           if [ -d "$VENV_DIR/$VENV_NAME" ]; then
               echo "venv $VENV_NAME already exists"
               return 1
           fi
           $PYTHON_VERSION -m venv "$VENV_DIR/$VENV_NAME"
           echo "Created venv: $VENV_NAME"
           ;;
       "ls")
           echo "Available virtual environments:"
           for venv in "$VENV_DIR"/*; do
               if [ -d "$venv" ]; then
                   local NAME=$(basename "$venv")
                   if [ "$VIRTUAL_ENV" = "$VENV_DIR/$NAME" ]; then
                       echo "* $NAME (active)"
                   else
                       echo "  $NAME"
                   fi
               fi
           done
           ;;
       "attach")
           if [ -z "$2" ]; then
               echo "Usage: venv attach <name>"
               return 1
           fi
           if [ -d "$VENV_DIR/$2" ]; then
               source "$VENV_DIR/$2/bin/activate"
           else
               echo "No such venv: $2"
               return 1
           fi
           ;;
       "detach")
           if [ -z "$VIRTUAL_ENV" ]; then
               echo "No active virtual environment"
               return 1
           fi
            deactivate
           ;;
       "delete")
           if [ -z "$2" ]; then
               echo "Usage: venv delete <name>"
               return 1
           fi
           if [ "$VIRTUAL_ENV" = "$VENV_DIR/$2" ]; then
               echo "Cannot delete active venv. Run 'venv detach' first"
               return 1
           fi
           if [ -d "$VENV_DIR/$2" ]; then
               rm -rf "$VENV_DIR/$2"
               echo "Deleted venv: $2"
           else
               echo "No such venv: $2"
               return 1
           fi
           ;;
       *)
           echo "Usage:"
           echo "  ve new <name> [python-version]  # Create new virtualenv"
           echo "  ve ls                          # List virtualenvs"
           echo "  ve attach <name>               # Activate virtualenv"
           echo "  ve detach                      # Deactivate current virtualenv"
           echo "  ve delete <name>               # Delete virtualenv"
           ;;
   esac
}