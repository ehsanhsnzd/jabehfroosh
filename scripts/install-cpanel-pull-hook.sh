#!/usr/bin/env bash
set -euo pipefail

app_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$app_root"

if [[ ! -f artisan || ! -f .env ]]; then
    printf 'Run this installer in the live Laravel repository on the server.\n' >&2
    exit 1
fi

if git config --get core.hooksPath >/dev/null 2>&1; then
    printf 'A custom core.hooksPath is configured. No existing hooks were changed.\n' >&2
    exit 1
fi

hook_path="$(git rev-parse --git-path hooks/post-merge)"
if [[ -e "$hook_path" || -L "$hook_path" ]]; then
    if [[ -f "$hook_path" ]] && grep -q '^# shamim-cpanel-deploy-hook$' "$hook_path"; then
        printf 'Automatic deployment after pull is already installed.\n'
        exit 0
    fi

    printf 'An existing post-merge hook was found at %s. It was left intact.\n' "$hook_path" >&2
    exit 1
fi

mkdir -p -- "$(dirname -- "$hook_path")"
cat > "$hook_path" <<'HOOK'
#!/usr/bin/env bash
# shamim-cpanel-deploy-hook
set -euo pipefail
app_root="$(git rev-parse --show-toplevel)"
exec /bin/bash "$app_root/scripts/deploy-cpanel.sh"
HOOK
chmod 755 "$hook_path"
printf 'Installed automatic deployment after a successful merge or fast-forward pull.\n'
