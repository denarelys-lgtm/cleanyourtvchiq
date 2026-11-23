#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# This source archive does not include the git submodule's files. The project pins the
# upstream launcher source at b06ab21; fetch that exact revision if the submodule is empty.
if [[ ! -d third_party/cleanyourtv/examples ]]; then
  if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: missing third_party/cleanyourtv and git is not installed." >&2
    exit 2
  fi
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  git clone --filter=blob:none https://github.com/Gathin23/cleanyourtv.git "$tmp/upstream"
  git -C "$tmp/upstream" checkout --detach b06ab21
  mkdir -p third_party/cleanyourtv
  cp -a "$tmp/upstream/." third_party/cleanyourtv/
fi

# Candidate profile + Home Button Helper are intentionally test-build-only.
./gradlew \
  :core:spec:test \
  :core:planner:test \
  :core:flows:test \
  :app:testFullDebugUnitTest \
  :app:assembleFullDebug \
  -Pcyt.candidates=true \
  -Pcyt.homeHelper=true \
  -Pcyt.chiqExperimental=true

APK="app/build/outputs/apk/full/debug/app-full-debug.apk"
if [[ -f "$APK" ]]; then
  echo
  echo "Experimental CHiQ APK: $APK"
  echo "Version: 0.4.8-alpha1 (versionCode 31)"
else
  echo "Build completed, but the expected APK path was not found. APK files:" >&2
  find app/build/outputs -type f -name '*.apk' -print >&2 || true
  exit 3
fi
