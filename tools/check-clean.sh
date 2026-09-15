#!/bin/bash
# Refuse to publish anything that does not belong in a PUBLIC art repo.
# Run before every push. Exits non-zero on a finding.
#
# NOTE: every loop here reads from process substitution, NOT a pipe.
# `grep | while read` runs the loop in a SUBSHELL, so fail=1 never reaches
# the parent and the script prints a warning then exits 0 — a guard that
# cannot fail. That bug was live in the first version of this file and was
# only caught by deliberately feeding it a credential.
fail=0
note(){ printf "  !! %s\n" "$1"; fail=1; }

echo "checking for things that must never be in a public repo..."

while read -r f; do note "private IP in $f"; done < <(
  grep -rlnE '(^|[^0-9.])(10|192\.168|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]{1,3}\.[0-9]{1,3}' . \
    --include='*.html' --include='*.js' --include='*.md' --include='*.json' 2>/dev/null \
    | grep -v 'check-clean')

while read -r f; do note "credential-shaped string in $f"; done < <(
  grep -rlE 'ssh-(rsa|ed25519) AAAA|BEGIN [A-Z ]*PRIVATE KEY|Bearer [A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{20,}' . 2>/dev/null \
    | grep -v 'check-clean')

for f in boards/*.html pwa/*.html; do
  [ -f "$f" ] || continue
  n=$(grep -ocE 'src="https?://|href="https?://|@import +url\(https?://' "$f" 2>/dev/null)
  [ "$n" != "0" ] && note "$f loads $n external resource(s) — breaks the no-third-party rule"
done

if [ "$fail" = "0" ]; then echo "  clean"; else echo "  REFUSING — fix the above"; exit 1; fi
