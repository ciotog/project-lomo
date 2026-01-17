#!/bin/bash
set -e

echo "🔒 Setting up repository security for CivicTechWR project..."

# Check if gh CLI is installed and authenticated. This script requires:
#   * GitHub CLI (`gh`) logged in with rights to edit repository settings.
#   * Permission to modify security features and branch protection in the CivicTechWR org.
#   * `repo` scope (and repository admin rights) on the CLI token.
#
# See docs/REPOSITORY_SECURITY.md for more information.
if command -v gh >/dev/null 2>&1; then :; else
    echo "❌ GitHub CLI (gh) is not installed. Please install it first:"
    echo "   https://cli.github.com/"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository. Please run this from your project root."
    exit 1
fi

# Get repository information
REPO_URL=$(git config --get remote.origin.url)
if [[ ${REPO_URL} =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
    OWNER=${BASH_REMATCH[1]}
    REPO=${BASH_REMATCH[2]}
    REPO=${REPO%.git}  # Remove .git suffix if present
    GITHUB_REPOSITORY="${OWNER}/${REPO}"
else
    echo "❌ Could not parse GitHub repository from remote URL: ${REPO_URL}"
    exit 1
fi

echo "Setting up security for repository: ${GITHUB_REPOSITORY}"

# 1. Enable secret scanning
echo "🔍 Enabling secret scanning and push protection..."
if gh repo edit "${GITHUB_REPOSITORY}" --enable-secret-scanning --enable-secret-scanning-push-protection 2>/dev/null; then
    echo "✅ Secret scanning enabled"
else
    echo "⚠️  Could not enable secret scanning (may require admin permissions)"
fi

# 2. Set up branch protection (if branch-protection.json exists)
if [[ -f "scripts/branch-protection.json" ]]; then
    echo "🛡️  Setting up branch protection..."
    if gh api "repos/${GITHUB_REPOSITORY}/branches/main/protection" \
        --method PUT \
        --input scripts/branch-protection.json > /dev/null 2>&1; then
        echo "✅ Branch protection rules applied"
    else
        echo "⚠️  Could not set up branch protection (may require admin permissions)"
        echo "   You can manually enable this in GitHub repository settings"
    fi
else
    echo "⚠️  Branch protection config not found at scripts/branch-protection.json"
    echo "   Creating default configuration..."

    mkdir -p scripts
    cat > scripts/branch-protection.json << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["template-validation", "civic-compliance", "template-completeness"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
    echo "✅ Created default branch protection configuration"
    echo "   Run this script again to apply the rules"
fi

# 3. Create dependabot config if it doesn't exist
if [[ ! -f .github/dependabot.yml ]]; then
    echo "🤖 Creating Dependabot configuration..."
    mkdir -p .github

    # Detect package ecosystem
    ECOSYSTEM="npm"  # default
    if [[ -f package.json ]]; then
        ECOSYSTEM="npm"
    elif [[ -f requirements.txt || -f pyproject.toml ]]; then
        ECOSYSTEM="pip"
    elif [[ -f Gemfile ]]; then
        ECOSYSTEM="bundler"
    elif [[ -f pom.xml ]]; then
        ECOSYSTEM="maven"
    elif [[ -f build.gradle || -f build.gradle.kts ]]; then
        ECOSYSTEM="gradle"
    elif [[ -f go.mod ]]; then
        ECOSYSTEM="gomod"
    elif [[ -f Cargo.toml ]]; then
        ECOSYSTEM="cargo"
    fi

    cat > .github/dependabot.yml << EOF
version: 2
updates:
  # Enable version updates for ${ECOSYSTEM}
  - package-ecosystem: "${ECOSYSTEM}"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    open-pull-requests-limit: 5
    commit-message:
      prefix: "chore"
      include: "scope"

  # Enable version updates for GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
    commit-message:
      prefix: "ci"
EOF

    echo "✅ Created Dependabot configuration for ${ECOSYSTEM} ecosystem"
else
    echo "✅ Dependabot configuration already exists"
fi

# 4. Create CODEOWNERS file if it doesn't exist
if [[ ! -f .github/CODEOWNERS ]]; then
    echo "👥 Creating CODEOWNERS file..."
    mkdir -p .github
    cat > .github/CODEOWNERS << 'EOF'
# Global code owners for this CivicTechWR project
# These users will be automatically requested for review when PRs are opened

# All files
* @OWNER

# Documentation changes
*.md @OWNER
docs/ @OWNER

# Security-related files
SECURITY.md @OWNER
docs/SECURITY_GUIDE.md @OWNER
scripts/setup-security.sh @OWNER

# Configuration files
.github/ @OWNER
scripts/ @OWNER

# Add specific code owners for different parts of your project:
# frontend/ @frontend-team-member
# backend/ @backend-team-member
# data/ @data-team-member
EOF

    echo "⚠️  Please update .github/CODEOWNERS with actual GitHub usernames"
    echo "✅ Created CODEOWNERS template"
else
    echo "✅ CODEOWNERS file already exists"
fi

# 5. Verify security settings
echo ""
echo "🔍 Verifying security configuration..."

# Check if secret scanning is enabled
SECRET_STATUS=$(gh api "repos/${GITHUB_REPOSITORY}" --jq '.security_and_analysis.secret_scanning.status' 2>/dev/null || true)
if grep -q "enabled" <<< "${SECRET_STATUS}"; then
    echo "✅ Secret scanning is enabled"
else
    echo "⚠️  Secret scanning status unknown or disabled"
fi

# Check if security policy exists
if [[ -f SECURITY.md ]]; then
    echo "✅ Security policy (SECURITY.md) exists"
else
    echo "❌ Security policy missing - this should be included in the template"
fi

# Check branch protection
if gh api "repos/${GITHUB_REPOSITORY}/branches/main/protection" > /dev/null 2>&1; then
    echo "✅ Branch protection is configured"
else
    echo "⚠️  Branch protection is not configured or not accessible"
fi

echo ""
echo "🎉 Repository security setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Review and customize .github/CODEOWNERS with your team members"
echo "2. Check repository settings on GitHub for any additional security features"
echo "3. Set up security monitoring and response procedures"
echo "4. Train team members on security best practices"
echo ""
echo "📖 For more information:"
echo "   - Repository Security Guide: docs/REPOSITORY_SECURITY.md"
echo "   - General Security Guide: docs/SECURITY_GUIDE.md"
echo "   - Getting Started Guide: GETTING_STARTED.md"
echo ""
echo "🔔 Security alerts will appear in the GitHub Security tab"
echo "   Check regularly and respond promptly to any alerts"
