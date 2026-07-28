#!/bin/sh
# check-secrets.sh — run BEFORE every push. Exits 1 if anything secret-looking
# is found in this folder. Never push if this fails.
cd "$(dirname "$0")" || exit 1

PATTERN='sk-[A-Za-z0-9]{8}|ghp_[A-Za-z0-9]|gho_[A-Za-z0-9]|xox[baprs]-|AKIA[0-9A-Z]{4}|-----BEGIN|[a-z_]*token[a-z_]*[[:space:]]*[:=]|api[_-]?key[[:space:]]*[:=]|private[_-]?key'

MATCHES=$(grep -rIinE "$PATTERN" . \
  --exclude=check-secrets.sh \
  --exclude-dir=.git 2>/dev/null)

# Also refuse if any env/credential-style FILE exists here at all
FILES=$(find . -name '.git' -prune -o -type f \( -name '.env*' -o -name '*.pem' -o -name 'id_rsa*' -o -name '*.p12' -o -name '.telegram-env' -o -name '.discord-env' \) -print)

if [ -n "$MATCHES" ] || [ -n "$FILES" ]; then
  echo "✗ SECRETS RISK — DO NOT PUSH"
  [ -n "$MATCHES" ] && printf 'Matched content:\n%s\n' "$MATCHES"
  [ -n "$FILES" ]   && printf 'Credential-style files present:\n%s\n' "$FILES"
  exit 1
fi
echo "✓ clean — safe to push"
