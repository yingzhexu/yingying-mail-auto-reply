#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT/build}"
APP="$OUTPUT_DIR/YINGYING邮件自动回复.app"
mkdir -p "$OUTPUT_DIR"
if [[ -e "$APP" ]]; then
  mv "$APP" "$OUTPUT_DIR/YINGYING邮件自动回复-previous-$(date +%s).app"
fi
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
clang -arch arm64 -arch x86_64 -mmacosx-version-min=12.0 \
  -fobjc-arc -fblocks -fobjc-exceptions -O2 -Wall \
  -framework Cocoa -framework Security \
  "$ROOT/Sources/Main.m" -o "$APP/Contents/MacOS/ReplyPilot"
cp "$ROOT/Info.plist" "$APP/Contents/Info.plist"
cp "$ROOT/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
codesign --force --sign - --entitlements "$ROOT/ReplyPilot.entitlements" "$APP"
codesign --verify --deep --strict "$APP"
ARCHITECTURES="$(lipo -archs "$APP/Contents/MacOS/ReplyPilot")"
if [[ " $ARCHITECTURES " != *" arm64 "* || " $ARCHITECTURES " != *" x86_64 "* ]]; then
  echo "Universal build failed: $ARCHITECTURES" >&2
  exit 3
fi
echo "Created $APP with $ARCHITECTURES (macOS 12+)."
