#!/bin/bash
# LLM Wiki Scaffold Script
# Creates a ready-to-use wiki directory from the starter kit.
#
# Usage:
#   ./scaffold.sh ~/Documents/llm-wiki
#   ./scaffold.sh /path/to/your/wiki

set -e

TARGET="${1:-$HOME/Documents/llm-wiki}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$TARGET/CLAUDE.md" ]; then
    echo "Error: $TARGET/CLAUDE.md already exists. Aborting to avoid overwriting."
    exit 1
fi

echo "Creating LLM Wiki at: $TARGET"
echo ""

# Create directory structure
mkdir -p "$TARGET/raw/assets"
mkdir -p "$TARGET/wiki/entities"
mkdir -p "$TARGET/wiki/concepts"
mkdir -p "$TARGET/wiki/topics"
mkdir -p "$TARGET/wiki/queries"
mkdir -p "$TARGET/tools"

# Copy files
cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
cp "$SCRIPT_DIR/.gitignore" "$TARGET/.gitignore"
cp "$SCRIPT_DIR/wiki/index.md" "$TARGET/wiki/index.md"
cp "$SCRIPT_DIR/wiki/log.md" "$TARGET/wiki/log.md"
cp "$SCRIPT_DIR/wiki/overview.md" "$TARGET/wiki/overview.md"
cp "$SCRIPT_DIR/tools/search.py" "$TARGET/tools/search.py"
chmod +x "$TARGET/tools/search.py"

# Init git
cd "$TARGET"
git init -q
git add .
git commit -q -m "init: empty wiki scaffold"

echo "Done! Your wiki is ready at: $TARGET"
echo ""
echo "Structure:"
echo "  raw/          ← Drop your source files here"
echo "  wiki/         ← LLM maintains this (don't edit manually)"
echo "  CLAUDE.md     ← Schema (edit to customize conventions)"
echo "  tools/        ← CLI utilities"
echo ""
echo "Next steps:"
echo "  1. Drop source files into $TARGET/raw/"
echo "  2. cd $TARGET && claude"
echo "  3. Tell Claude: ingest raw/your-first-file.md"
