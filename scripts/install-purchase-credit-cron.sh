#!/usr/bin/env bash
set -euo pipefail
app_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if ! command -v crontab >/dev/null 2>&1; then
    printf 'crontab is unavailable; add run-purchase-credit-cron.sh to cPanel Cron Jobs (once per minute).\n' >&2
    exit 0
fi
existing_cron=''
if ! existing_cron="$(crontab -l 2>&1)"; then
    if [[ "$existing_cron" == *'no crontab'* ]]; then
        existing_cron=''
    else
        printf 'Cannot read crontab; configure the purchase-credit cron in cPanel manually.\n' >&2
        exit 0
    fi
fi
marker='# shamim-purchase-credit'
if [[ "$existing_cron" == *"$marker"* ]]; then
    printf 'Purchase-credit cron is already installed.\n'
    exit 0
fi
printf -v quoted_script '%q' "$app_root/scripts/run-purchase-credit-cron.sh"
printf -v quoted_log '%q' "$app_root/storage/logs/purchase-credit-cron.log"
php_environment=''
if [[ -n "${DEPLOY_PHP:-}" ]]; then
    printf -v quoted_php '%q' "$DEPLOY_PHP"
    php_environment="DEPLOY_PHP=$quoted_php "
fi
cron_line="* * * * * ${php_environment}/bin/bash $quoted_script >> $quoted_log 2>&1 $marker"
# Cron interprets percent signs even inside shell quoting.
cron_line="${cron_line//%/\\%}"
if ! { printf '%s\n' "$existing_cron"; printf '%s\n' "$cron_line"; } | crontab -; then
    printf 'Cannot install cron; configure the purchase-credit cron in cPanel manually.\n' >&2
    exit 0
fi
printf 'Installed purchase-credit cron (once per minute).\n'
