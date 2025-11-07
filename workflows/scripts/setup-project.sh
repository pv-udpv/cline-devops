#!/bin/bash
set -euo pipefail

# Cline Project Setup Script
# Usage: ./setup-project.sh <project-name> <project-path>

PROJECT_NAME="${1:?Project name required}"
PROJECT_PATH="${2:?Project path required}"
RULES_REPO="https://github.com/pv-udpv/cline-devops.git"

echo "🚀 Setting up Cline for project: $PROJECT_NAME"

# 1. Create project directory
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

# 2. Initialize git if needed
if [ ! -d .git ]; then
    git init
    git branch -M main
fi

# 3. Create .venv with uv
echo "📦 Creating virtual environment..."
if command -v uv &> /dev/null; then
    uv venv
    source .venv/bin/activate
else
    echo "⚠️  uv not found. Install: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

# 4. Sync global rules
echo "📋 Syncing Cline rules..."
mkdir -p .cline
git clone --depth 1 --filter=blob:none --sparse "$RULES_REPO" .cline/devops
cd .cline/devops
git sparse-checkout set rules/global
cd ../..

cp .cline/devops/rules/global/.copilot-instructions.md .copilot-instructions.md

# 5. Create project-specific rules
cat > .cline/project-rules.md <<EOF
# Project-Specific Rules: $PROJECT_NAME

## Project Context
<!-- Add project description -->

## Dependencies
<!-- List key dependencies -->

## Critical Files
<!-- Identify files that need careful handling -->

## Custom Instructions
<!-- Add project-specific prompts/patterns -->
EOF

# 6. Create task templates
mkdir -p .cline/tasks
if [ -d .cline/devops/workflows/templates ]; then
    cp .cline/devops/workflows/templates/* .cline/tasks/ 2>/dev/null || true
fi

echo "✅ Cline setup complete for $PROJECT_NAME!"
echo ""
echo "Next steps:"
echo "1. Edit .copilot-instructions.md with project specifics"
echo "2. Review .cline/project-rules.md"
echo "3. Configure MCP servers in VSCode settings"