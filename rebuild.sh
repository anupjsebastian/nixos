#!/usr/bin/env bash
# Quick build and test script for the new Noctalia + Niri configuration

set -e

echo "🔄 Updating flake lock..."
nix flake update

echo "🔨 Building configuration (test mode)..."
sudo nixos-rebuild test --flake .#nyx

echo ""
echo "✅ Build successful!"
echo ""
echo "Next steps:"
echo "1. If everything looks good, run: sudo nixos-rebuild switch --flake .#nyx"
echo "2. Reboot to use the new greetd login manager"
echo "3. Log in and Noctalia will start automatically"
echo ""
echo "Keybindings to try:"
echo "  - Mod+Space: Open launcher"
echo "  - Mod+Shift+L: Lock screen"
echo "  - Mod+P: Session menu"
echo "  - Mod+Return: Open terminal"
echo ""
echo "Check MIGRATION_SUMMARY.md for full details!"
