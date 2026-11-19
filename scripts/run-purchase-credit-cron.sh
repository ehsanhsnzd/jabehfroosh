#!/usr/bin/env bash
set -euo pipefail
app_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$app_root"
php_bin="${DEPLOY_PHP:-}"
if [[ -z "$php_bin" ]]; then
    for candidate in /opt/cpanel/ea-php84/root/usr/bin/php /opt/cpanel/ea-php83/root/usr/bin/php /opt/alt/php84/usr/bin/php /opt/alt/php83/usr/bin/php; do
        if [[ -x "$candidate" ]]; then php_bin="$candidate"; break; fi
    done
fi
if [[ -z "$php_bin" ]]; then php_bin="$(command -v php)"; fi
exec 9>storage/framework/purchase-credit-cron.lock
flock -n 9 || exit 0
"$php_bin" artisan credit:dispatch-notices --no-interaction
"$php_bin" artisan queue:work database --queue=purchase-credit --stop-when-empty --max-time=50 --tries=1 --timeout=30 --no-interaction
