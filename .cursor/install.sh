#!/usr/bin/env bash
# Idempotent Cloud Agent setup for the Nexus Chat Flutter app.
# Installs the pinned Flutter SDK and resolves project dependencies.
set -euo pipefail

# Flutter 3.41.x bundles Dart 3.11.x, which satisfies this repo's SDK
# constraints (pubspec: sdk ^3.11.0; pubspec.lock: flutter >=3.38.4).
# Newer stable channels (3.47+) drop APIs the app relies on
# (e.g. CupertinoPageTransitionsBuilder), so the version is pinned.
FLUTTER_VERSION="3.41.9"
FLUTTER_DIR="/opt/flutter"
ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${ARCHIVE}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Install the SDK only when it is missing or the wrong version.
if ! "${FLUTTER_DIR}/bin/flutter" --version 2>/dev/null | grep -q "Flutter ${FLUTTER_VERSION} "; then
  echo "Installing Flutter ${FLUTTER_VERSION}..."
  tmp="$(mktemp -d)"
  curl -fsSL -o "${tmp}/${ARCHIVE}" "${URL}"
  sudo rm -rf "${FLUTTER_DIR}"
  sudo tar -xf "${tmp}/${ARCHIVE}" -C /opt
  sudo chown -R "$(id -u):$(id -g)" "${FLUTTER_DIR}"
  rm -rf "${tmp}"
fi

# Expose flutter/dart on PATH without mutating shell profiles.
sudo ln -sf "${FLUTTER_DIR}/bin/flutter" /usr/local/bin/flutter
sudo ln -sf "${FLUTTER_DIR}/bin/dart" /usr/local/bin/dart

# The SDK is a git checkout owned by this user; mark it safe for git.
git config --global --add safe.directory "${FLUTTER_DIR}" || true

# Non-interactive: opt out of telemetry and enable the web target.
flutter config --no-analytics >/dev/null 2>&1 || true
flutter config --enable-web >/dev/null 2>&1 || true

# Pre-download web engine artifacts so the first run/build is fast.
flutter precache --web

# Resolve project dependencies.
cd "${REPO_ROOT}"
flutter pub get

echo "Nexus Chat environment ready. Flutter $(flutter --version | head -n1)"
