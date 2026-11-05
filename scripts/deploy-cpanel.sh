#!/usr/bin/env bash
set -euo pipefail

app_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$app_root"

trap 'printf "Deployment failed at line %s.\n" "$LINENO" >&2' ERR

for required_file in artisan .env vendor/autoload.php; do
    if [[ ! -r "$required_file" ]]; then
        printf 'Missing %s in %s. Deploy from the live Laravel repository.\n' "$required_file" "$app_root" >&2
        exit 1
    fi
done

for runtime_directory in storage/framework bootstrap/cache; do
    if [[ ! -d "$runtime_directory" || ! -w "$runtime_directory" ]]; then
        printf 'Runtime directory is not writable: %s\n' "$runtime_directory" >&2
        exit 1
    fi
done

php_candidates=()
if [[ -n "${DEPLOY_PHP:-}" ]]; then
    php_candidates+=("$DEPLOY_PHP")
else
    if command -v php >/dev/null 2>&1; then
        php_candidates+=("$(command -v php)")
    fi
    php_candidates+=(
        /opt/cpanel/ea-php84/root/usr/bin/php
        /opt/cpanel/ea-php83/root/usr/bin/php
        /opt/alt/php84/usr/bin/php
        /opt/alt/php83/usr/bin/php
    )
fi

php_bin=''
for candidate in "${php_candidates[@]}"; do
    if [[ -x "$candidate" ]] && "$candidate" -r 'exit(PHP_VERSION_ID >= 80300 && PHP_VERSION_ID < 80500 ? 0 : 1);'; then
        php_bin="$candidate"
        break
    fi
done

if [[ -z "$php_bin" ]]; then
    printf 'PHP CLI 8.3 or 8.4 is required. Set DEPLOY_PHP to its executable path.\n' >&2
    exit 1
fi

if ! command -v flock >/dev/null 2>&1; then
    printf 'The flock command is required to prevent concurrent deployments.\n' >&2
    exit 1
fi

exec 9>storage/framework/cpanel-deploy.lock
if ! flock -n 9; then
    printf 'Another deployment is already running.\n' >&2
    exit 1
fi

printf 'Deploying %s with %s\n' "$app_root" "$php_bin"
"$php_bin" artisan optimize:clear --no-interaction
"$php_bin" artisan migrate --force --no-interaction
"$php_bin" artisan optimize --no-interaction
"$php_bin" artisan queue:restart --no-interaction
printf 'Deployment completed.\n'
