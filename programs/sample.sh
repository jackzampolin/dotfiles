#!/usr/bin/env sh

# Use POSIX standard if blocks instead of case when possible
# Check for shell type to handle shell-specific features
sample() {
    # Local functions - use POSIX style
    command_help() {
        printf "%s\n" "Usage: sample <command>

Available Commands:
    cmd     - this is a sample command
    another - this is another example

Use 'sample <command>' to run a command"
    }

    cmd() {
        printf "%s\n" "this is a sample command"
        # code goes here...
    }

    another() {
        printf "%s\n" "I'm another way to implement commands"
    }

    # Use printf instead of echo for better POSIX compatibility
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        command_help
        return 0
    fi

    # POSIX case statement
    case "$1" in
        cmd) cmd ;;
        another) another ;;
        "")
            printf "Error: Command required\n"
            command_help
            return 1
            ;;
        *)
            printf "Error: Unknown command '%s'\n" "$1"
            command_help
            return 1
            ;;
    esac
}

# Optional: detect if being sourced vs run directly
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    sample "$@"
fi
