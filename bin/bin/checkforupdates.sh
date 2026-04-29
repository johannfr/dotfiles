#!/usr/bin/env bash

DEBUG=0
[[ "$1" == "--debug" ]] && DEBUG=1


# Public repos: checked against remote over HTTPS (no auth required)
PUBLIC_REPOS=(
    "$HOME/dotfiles"
    "$HOME/mitt/zup"
    "/etc/nixos"
)

# Private repos: local status only, no network access
LOCAL_ONLY_REPOS=(
    "$HOME/vinna/isds"
    "$HOME/vinna/ice"
    "$HOME/vinna/envdata"
    "$HOME/vinna/iws"
)

# Checks working tree and local commit status; no network access required.
# Must be called from within the repo directory with $branch already set.
check_local_workdir() {
    local repo_path="$1"
    local branch="$2"

    local -a conditions

    git diff --quiet                                        || conditions+=("Unstaged changes")
    git diff --cached --quiet                               || conditions+=("Staged changes")
    git ls-files --others --exclude-standard | grep -q .   && conditions+=("Untracked files")

    if git rev-parse @{u} &>/dev/null; then
        git log @{u}.. --oneline 2>/dev/null | grep -q . && conditions+=("Unpushed commits")
    else
        echo "$repo_path ($branch): No upstream configured, skipping unpushed check."
    fi

    if [ ${#conditions[@]} -gt 0 ]; then
        local message
        local IFS=','; message="${conditions[*]}"; message="${message//,/, }"
        echo "$repo_path ($branch): ${message}."
    fi
}

check_remote_status() {
    local repo_path="$1"

    if [ ! -d "$repo_path/.git" ]; then
        [ "$DEBUG" -eq 1 ] && echo "Skipping $repo_path: Not a git repository." >&2
        return
    fi

    cd "$repo_path" || return

    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)

    local local_hash
    local_hash=$(git rev-parse HEAD)

    # Convert SSH remote URL to HTTPS (no auth needed for public repos)
    local ssh_url https_url remote_hash
    ssh_url=$(git remote get-url origin)
    https_url=$(echo "$ssh_url" | sed -E 's|git@([^:]+):(.+)|https://\1/\2|;s|ssh://git@([^/]+)/(.+)|https://\1/\2|')

    remote_hash=$(git ls-remote -h "$https_url" "refs/heads/$branch" | cut -f1)

    if [ -z "$remote_hash" ]; then
        echo "$repo_path ($branch): Could not reach remote or branch via HTTPS."
    elif [ "$local_hash" != "$remote_hash" ]; then
        echo -n "$repo_path ($branch): "
        if git cat-file -e "$remote_hash" 2>/dev/null; then
            echo "Local commits not pushed."
        else
            echo "Remote commits not pulled."
        fi
    fi

    check_local_workdir "$repo_path" "$branch"
}

check_local_status() {
    local repo_path="$1"

    if [ ! -d "$repo_path/.git" ]; then
        [ "$DEBUG" -eq 1 ] && echo "Skipping $repo_path: Not a git repository." >&2
        return
    fi

    cd "$repo_path" || return

    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)

    check_local_workdir "$repo_path" "$branch"
}

for repo in "${PUBLIC_REPOS[@]}"; do
    check_remote_status "$repo"
done
for repo in "${LOCAL_ONLY_REPOS[@]}"; do
    check_local_status "$repo"
done
