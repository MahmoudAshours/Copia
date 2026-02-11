#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Use Android Studio JBR for stable AGP/Gradle behavior.
if [[ -d "/Applications/Android Studio.app/Contents/jbr/Contents/Home" ]]; then
  export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# Work around AppleDouble files that can break test discovery on some external volumes.
find . -name '._*' -delete || true

flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
if [[ -n "${ANDROID_DEVICE_ID:-}" ]]; then
  bash tool/run_integration_android.sh "$ANDROID_DEVICE_ID"
else
  echo "ANDROID_DEVICE_ID not set; skipping integration_test device run."
fi
flutter build apk --debug

echo "Android quality checks completed."
