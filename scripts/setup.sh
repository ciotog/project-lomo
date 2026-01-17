#!/bin/bash

# CivicTechWR Project Setup Script
# This script sets up the development environment for new contributors

set -euo pipefail  # Exit on error, undefined var, or failed pipeline

CHECK_MODE=0
if [[ ${1:-} == "--check" ]]; then
    CHECK_MODE=1
    echo "ℹ️ Running setup in pre-flight check mode (no changes will be made)."
fi

POSTFLIGHT_ITEMS=(
    "Enable GitHub Pages (Settings → Pages → GitHub Actions)"
    "Run CTWR_PROJECT_OWNER=<org> ./scripts/setup-project.sh to create the GitHub Project"
    "Run ./scripts/setup-security.sh to apply branch protection, Dependabot, and secret scanning"
    "Update README, wiki, and documentation with real project information"
    "Replace placeholder CODEOWNERS entries with your team’s GitHub usernames"
    "Invite partners and volunteers to the repo and GitHub Project"
)

if [[ -n "${CTWR_POSTFLIGHT_EXTRA:-}" ]]; then
    IFS=';' read -r -a _ctwr_extra_items <<<"${CTWR_POSTFLIGHT_EXTRA}"
    for item in "${_ctwr_extra_items[@]}"; do
        trimmed_item=$(echo "${item}" | awk '{$1=$1;print}')
        if [[ -n "${trimmed_item}" ]]; then
            POSTFLIGHT_ITEMS+=("${trimmed_item}")
        fi
    done
fi

# Utility: ensure required command exists before continuing
require_command() {
    local cmd="$1"
    local label=${2:-$1}
    local help=${3:-}

    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "❌ ${label} is required but not installed."
        if [[ -n "${help}" ]]; then
            echo "${help}"
        fi
        exit 1
    fi
}

echo "🚀 Setting up CivicTechWR Project Development Environment"
echo "=================================================="

# Check if we're in the right directory
if [[ ! -f "README.md" ]]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Function to prompt for user input
prompt_user() {
    read -p "$1 (y/n): " -n 1 -r
    echo
    [[ ${REPLY} =~ ^[Yy]$ ]]
}

echo "🔍 Checking system requirements..."

# Check for Git
require_command git "Git" "Please install Git first."
echo "✅ Git found"

# Detect project type and set up accordingly
echo "🔍 Detecting project type..."

if [[ -f "package.json" ]]; then
    PROJECT_TYPE="node"
    echo "📦 Node.js project detected"
elif [[ -f "requirements.txt" || -f "setup.py" || -f "pyproject.toml" ]]; then
    PROJECT_TYPE="python"
    echo "🐍 Python project detected"
elif [[ -f "Gemfile" ]]; then
    PROJECT_TYPE="ruby"
    echo "💎 Ruby project detected"
elif [[ -f "pubspec.yaml" ]]; then
    PROJECT_TYPE="flutter"
    echo "🐦 Flutter project detected"
else
    PROJECT_TYPE="static"
    echo "📄 Static site project detected"
fi

# Node.js setup
if [[ "${PROJECT_TYPE}" == "node" ]]; then
    require_command node "Node.js" "Please install Node.js from https://nodejs.org/"
    require_command npm "npm"

    NODE_VERSION=$(node --version 2>/dev/null) || {
        echo "❌ Failed to determine Node.js version."
        exit 1
    }
    NPM_VERSION=$(npm --version 2>/dev/null) || {
        echo "❌ Failed to determine npm version."
        exit 1
    }

    echo "✅ Node.js ${NODE_VERSION} found"
    echo "✅ npm ${NPM_VERSION} found"

    if (( CHECK_MODE )); then
        echo "ℹ️ (check) Would run: npm install"
    else
        echo "📦 Installing Node.js dependencies..."
        npm install
    fi

    if (( CHECK_MODE )); then
        echo "ℹ️ (check) Skipping accessibility tooling detection"
    else
        if npm list 2>/dev/null | grep -q "accessibility"; then
            echo "♿ Accessibility tools detected"
        fi
    fi

    if (( CHECK_MODE )); then
        echo "ℹ️ (check) Skipping local lint/format detection"
    else
        echo "🔧 Setting up development tools..."
        if [[ -f ".eslintrc.js" || -f ".eslintrc.json" ]]; then
            echo "✅ ESLint configuration found"
        fi

        if [[ -f ".prettierrc" || -f "prettier.config.js" ]]; then
            echo "✅ Prettier configuration found"
        fi
    fi
fi

# Python setup
if [[ "${PROJECT_TYPE}" == "python" ]]; then
    require_command python3 "Python 3" "Please install Python 3 from https://python.org/"

    PYTHON_VERSION=$(python3 --version 2>/dev/null) || {
        echo "❌ Failed to determine Python version."
        exit 1
    }
    echo "✅ ${PYTHON_VERSION}"

    # Create virtual environment if it doesn't exist
    if (( CHECK_MODE )); then
        echo "ℹ️ (check) Would create virtual environment (python3 -m venv venv)"
        echo "ℹ️ (check) Would install pip requirements"
    else
        if [[ ! -d "venv" ]]; then
            echo "🐍 Creating Python virtual environment..."
            python3 -m venv venv
        fi

        echo "🐍 Activating virtual environment..."
        # shellcheck disable=SC1091
        source venv/bin/activate

        echo "📦 Installing Python dependencies..."
        if [[ -f "requirements.txt" ]]; then
            pip install -r requirements.txt
        fi

        if [[ -f "requirements-dev.txt" ]]; then
            pip install -r requirements-dev.txt
        fi

        if pip list 2>/dev/null | grep -q "django"; then
            echo "🌐 Django framework detected"
        fi

        if pip list 2>/dev/null | grep -q "flask"; then
            echo "🌐 Flask framework detected"
        fi
    fi
fi

# Ruby setup
if [[ "${PROJECT_TYPE}" == "ruby" ]]; then
    require_command ruby "Ruby"
    require_command bundle "Bundler" "Run: gem install bundler"

    RUBY_VERSION=$(ruby --version 2>/dev/null) || {
        echo "❌ Failed to determine Ruby version."
        exit 1
    }
    echo "✅ ${RUBY_VERSION}"
    BUNDLER_VERSION=$(bundle --version 2>/dev/null) || {
        echo "❌ Failed to determine Bundler version."
        exit 1
    }
    echo "✅ ${BUNDLER_VERSION}"

    if (( CHECK_MODE )); then
        echo "ℹ️ (check) Would run: bundle install"
        echo "ℹ️ (check) Would check bundle list for Jekyll"
    else
        echo "💎 Installing Ruby dependencies..."
        bundle install

        if bundle list 2>/dev/null | grep -q "jekyll"; then
            echo "📄 Jekyll static site generator detected"
        fi
    fi
fi

# Flutter setup
if [[ "${PROJECT_TYPE}" == "flutter" ]]; then
    require_command flutter "Flutter" "Please install Flutter from https://flutter.dev/"

    echo "✅ Flutter found"
    if (( CHECK_MODE )); then
        echo "ℹ️ (check) Would run: flutter doctor"
        echo "ℹ️ (check) Would run: flutter pub get"
    else
        flutter doctor
        echo "🐦 Getting Flutter dependencies..."
        flutter pub get
    fi
fi

if (( CHECK_MODE )); then
    echo ""
    echo "✅ Pre-flight check complete. Run ./scripts/setup.sh without --check to perform setup."
    exit 0
fi

# Create development environment file if it doesn't exist
if [[ ! -f ".env" && ! -f ".env.example" ]]; then
    echo "🔧 Creating environment configuration..."
    cat > .env.example << EOF
# Environment Configuration for Development
# Copy this file to .env and fill in your values

# Development settings
NODE_ENV=development
DEBUG=true

# Database (if applicable)
# DATABASE_URL=postgresql://localhost:5432/your_db_name

# External APIs (if applicable)
# EXTERNAL_API_KEY=your_api_key_here

# Security (generate strong secrets for production)
# SECRET_KEY=your_secret_key_here

# Civic Tech specific settings
# ORGANIZATION_NAME=CivicTechWR
# SEASON=Season_X
EOF
    echo "📄 Created .env.example - copy to .env and customize for your setup"
fi

# Set up pre-commit hooks for code quality
echo "🔧 Setting up development tools..."

# Create simple pre-commit hook
if [[ ! -f ".git/hooks/pre-commit" ]]; then
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for CivicTechWR projects

echo "🔍 Running pre-commit checks..."

# Check for secrets in staged files
if git diff --cached --name-only | xargs grep -l "password\|secret\|key\|token" 2>/dev/null; then
    echo "❌ Potential secrets detected in staged files!"
    echo "Please review and remove any sensitive data before committing."
    exit 1
fi

# Run project-specific linting
if [[ -f "package.json" ]] && command -v npm >/dev/null; then
    if npm run lint --silent 2>/dev/null; then
        echo "✅ JavaScript linting passed"
    fi
fi

if [[ -f "requirements.txt" ]] && command -v flake8 >/dev/null; then
    if flake8 . 2>/dev/null; then
        echo "✅ Python linting passed"
    fi
fi

echo "✅ Pre-commit checks completed"
EOF
    chmod +x .git/hooks/pre-commit
    echo "✅ Pre-commit hooks installed"
fi

# Create basic project structure if missing
echo "📁 Checking project structure..."

# Create essential directories
mkdir -p assets/images
mkdir -p docs
mkdir -p tests

# Create .gitignore if it doesn't exist
if [[ ! -f ".gitignore" ]]; then
    cat > .gitignore << 'EOF'
# Development environment
.env
.env.local

# Dependencies
node_modules/
venv/
vendor/

# Build outputs
dist/
build/
_site/

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp

# Civic tech specific
# Add any sensitive data patterns here
EOF
    echo "📄 Created .gitignore file"
fi

# Verify accessibility tools
echo "♿ Checking accessibility tools..."
if command -v npm >/dev/null 2>&1 && [[ -f "package.json" ]]; then
    if npm list @axe-core/cli &>/dev/null || npm list lighthouse &>/dev/null; then
        echo "✅ Accessibility testing tools available"
    else
        echo "💡 Consider adding accessibility testing tools:"
        echo "   npm install --save-dev @axe-core/cli lighthouse"
    fi
fi

# Check for Docker setup
if [[ -f "Dockerfile" || -f "docker-compose.yml" ]]; then
    echo "🐳 Docker configuration detected"
    if command -v docker >/dev/null 2>&1; then
        echo "✅ Docker is available"
    else
        echo "💡 Docker is configured but not installed. Install Docker for containerized development."
    fi
fi

echo ""
echo "🎉 Setup completed successfully!"
echo "=================================================="
echo ""
echo "📋 Next steps:"
echo "1. Copy .env.example to .env and customize settings"
echo "2. Review the project documentation in docs/"
echo "3. Start contributing! Check issues labeled 'good first issue'"
echo ""

# Project-specific startup instructions
case "${PROJECT_TYPE}" in
    "node")
        echo "🚀 To start development:"
        echo "   npm start"
        if [[ -f "package.json" ]] && grep -q "dev" package.json; then
            echo "   npm run dev"
        fi
        ;;
    "python")
        echo "🚀 To start development:"
        echo "   source venv/bin/activate"
        if [[ -f "manage.py" ]]; then
            echo "   python manage.py runserver"
        elif [[ -f "app.py" ]]; then
            echo "   python app.py"
        fi
        ;;
    "ruby")
        echo "🚀 To start development:"
        if bundle list 2>/dev/null | grep -q "jekyll"; then
            echo "   bundle exec jekyll serve"
        else
            echo "   bundle exec [your-command]"
        fi
        ;;
    "flutter")
        echo "🚀 To start development:"
        echo "   flutter run"
        ;;
    "static")
        echo "🚀 To start development:"
        echo "   Open index.html in your browser"
        echo "   Or use a local server like 'python -m http.server'"
        ;;
    *)
        echo "⚠️ Unknown project type '${PROJECT_TYPE}'. Please update scripts/setup.sh."
        ;;
esac

echo ""
echo "🤝 Welcome to CivicTechWR! Let's build technology that serves our community."
echo ""
echo "Need help? Join our weekly meetings or reach out on our communication channels."
echo "Check CONTRIBUTING.md for more details on how to get involved."

if [[ "${CTWR_SKIP_POSTFLIGHT:-0}" != "1" ]]; then
    echo ""
    echo "🧾 Post-flight checklist:"
    for item in "${POSTFLIGHT_ITEMS[@]}"; do
        echo "   ▸ ${item}"
    done
    if [[ -n "${CTWR_POSTFLIGHT_EXTRA:-}" ]]; then
        echo "   (Additional items supplied via CTWR_POSTFLIGHT_EXTRA)"
    fi
fi
