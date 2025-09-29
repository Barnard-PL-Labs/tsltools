#!/bin/bash

# Script to install git hooks

HOOKS_DIR="$(dirname "$0")"
GIT_HOOKS_DIR=".git/hooks"

echo "Installing git hooks..."

# Install pre-commit hook
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo "✓ Installed pre-commit hook"
fi

echo "Git hooks installation complete!"
echo "The pre-commit hook will automatically run ormolu on staged Haskell files."