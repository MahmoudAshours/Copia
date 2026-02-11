#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

DEVICE_ID="${1:-${ANDROID_DEVICE_ID:-}}"
if [[ -z "$DEVICE_ID" ]]; then
  echo "Usage: ANDROID_DEVICE_ID=<id> $0  (or pass device id as first arg)"
  exit 1
fi

# Use Android Studio JBR for stable AGP/Gradle behavior.
if [[ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ]]; then
  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# Work around AppleDouble files that can break test discovery.
find . -name '._*' -delete || true

# Some Android devices intermittently fail uninstall with internal errors.
for _ in 1 2 3; do
  adb -s "$DEVICE_ID" uninstall com.copia.copia >/dev/null 2>&1 || true
  adb -s "$DEVICE_ID" shell pm clear com.copia.copia >/dev/null 2>&1 || true
  sleep 1
done

flutter test integration_test -d "$DEVICE_ID"
