# prompt.sh
# Color definitions (using POSIX color codes)
c_reset=$'\033[0m'
c_path=$'\033[0;31m'
c_git_clean=$'\033[0;32m'
c_git_dirty=$'\033[0;31m'

# Git prompt function (shell-agnostic version)
__git_prompt() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    fi
    git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    if git diff --quiet 2>/dev/null >&2; then
        git_color="$c_git_clean"
    else
        git_color="$c_git_dirty"
    fi
    printf " [%s%s%s]" "$git_color" "$git_branch" "$c_reset"
}