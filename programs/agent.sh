# Talk to deployed amygdala agents over their Codex shim.
#
# Each deployed defra-agent runtime can expose a Codex app-server shim on a
# websocket (the 9600+ "Codex Listeners" port range; see the amygdala repo
# infra/services/PORTS.md). `agent <name>` opens an interactive Codex session
# against one of them over Tailscale.

# Resolve a deployed agent name to "<tailscale-host> <codex-shim-port>".
# Add stewards here as their codex shim comes online.
_agent_addr() {
    case "$1" in
    amy)                   echo "100.69.4.79 9601" ;;
    studio-1-steward)      echo "100.69.4.79 9602" ;;
    observability-steward) echo "100.69.4.79 9603" ;;
    coding-steward)        echo "100.69.4.79 9604" ;;
    hf-data-steward)       echo "100.69.4.79 9605" ;;
    x-data-steward)        echo "100.69.4.79 9606" ;;
    # mini-1-steward)   echo "100.102.157.108 <port>" ;;
    *) return 1 ;;
    esac
}

# Registered agent names, in display order. Keep in sync with _agent_addr
# (and the completions/zsh/_agent completion).
_AGENT_NAMES=(amy studio-1-steward observability-steward coding-steward hf-data-steward x-data-steward)

function agent() {
    case "$1" in
    ls | "")
        local addr host port state
        echo "Deployed agents (Codex shim):"
        for a in "${_AGENT_NAMES[@]}"; do
            addr="$(_agent_addr "$a")" || continue
            host="${addr%% *}"
            port="${addr##* }"
            if nc -z -G 2 "$host" "$port" 2>/dev/null; then
                state="up"
            else
                state="down"
            fi
            printf "  %-22s ws://%s:%s  (%s)\n" "$a" "$host" "$port" "$state"
        done
        ;;
    -h | --help | help)
        echo "Usage:"
        echo "  agent <name>   # open a Codex session against a deployed agent"
        echo "  agent ls       # list deployed agents and liveness"
        ;;
    *)
        local addr host port
        addr="$(_agent_addr "$1")" || {
            echo "unknown agent: $1"
            echo "try: agent ls"
            return 1
        }
        host="${addr%% *}"
        port="${addr##* }"
        echo "Connecting to $1 at ws://$host:$port ..."
        codex --no-alt-screen --yolo --remote "ws://$host:$port"
        ;;
    esac
}
