# Repository Security Configuration

This guide helps you configure GitHub repository security settings for your CivicTechWR project.

## 🚀 Quick Security Setup (5 Minutes)

After creating your repository from this template, enable these essential security features:

### 1. Enable Secret Scanning (Required)

```bash
# Enable secret scanning and push protection
gh repo edit --enable-secret-scanning --enable-secret-scanning-push-protection
```

**Why:** Automatically detects accidentally committed passwords, API keys, and tokens.

### 2. Set Up Branch Protection (Recommended)

```bash
# Basic branch protection for main branch
gh api repos/OWNER/REPO/branches/main/protection \
  --method PUT \
  --input scripts/branch-protection.json
```

**Why:** Prevents direct pushes to main branch, requires pull request reviews.

### 3. Enable Dependabot (Recommended)

Create `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: "npm" # or "pip", "gradle", etc.
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
```

**Why:** Automatically updates vulnerable dependencies.

## 🔒 Complete Security Configuration

### Repository Settings Checklist

#### Security & Analysis Settings

- [ ] **Secret scanning** - Enabled (detects committed secrets)
- [ ] **Push protection** - Enabled (blocks secret commits)
- [ ] **Dependency graph** - Enabled (tracks dependencies)
- [ ] **Dependabot alerts** - Enabled (vulnerable dependency notifications)
- [ ] **Dependabot security updates** - Enabled (automatic security patches)

#### Access & Permissions

- [ ] **Repository visibility** - Public (for open civic tech projects)
- [ ] **Collaborator permissions** - Minimum necessary access
- [ ] **Team permissions** - Read/Write/Admin as appropriate

#### Branch Protection Rules

- [ ] **Require pull request reviews** - At least 1 approving review
- [ ] **Require status checks** - CI must pass before merge
- [ ] **Require up-to-date branches** - Force updates before merge
- [ ] **Restrict pushes to main** - No direct commits to main branch

### Advanced Security (For Sensitive Projects)

#### Code Scanning

Enable GitHub Advanced Security (if available):

```yaml
# .github/workflows/security.yml
name: Security Scan
on: [push, pull_request]
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: javascript # or python, java, etc.
      - uses: github/codeql-action/analyze@v3
```

#### Security Policy

- [ ] **SECURITY.md file** - Created ✅ (included in template)
- [ ] **Vulnerability disclosure process** - Documented ✅ (included in template)
- [ ] **Security contact information** - Updated with your project details

#### Audit Logging

For organization-owned repositories:

- [ ] **Audit log monitoring** - Regular review of access changes
- [ ] **Repository insights** - Monitor access patterns
- [ ] **Webhook notifications** - Alert on security events

## 🛠️ Automated Security Setup Scripts

### Prerequisites

- Install and authenticate the GitHub CLI (`gh auth login`).
- Ensure your token has the `repo` scope and admin rights on the repository (`gh auth status`).
- Confirm you are an administrator within the `CivicTechWR` organization or have equivalent repository permissions.

### Branch Protection Configuration

Create `scripts/branch-protection.json`:

```json
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["ci", "security-scan", "dependency-check"]
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
```

### Security Setup Script

Add to `scripts/setup-security.sh`:

```bash
#!/bin/bash
set -e

# Requirements:
#   * GitHub CLI (`gh`) installed and authenticated (`gh auth login`).
#   * `repo` scope and admin permissions on the target repository.
#   * Network access to GitHub's API endpoints.

echo "🔒 Setting up repository security..."

# Enable secret scanning
echo "Enabling secret scanning..."
gh repo edit --enable-secret-scanning --enable-secret-scanning-push-protection

# Set up branch protection
echo "Setting up branch protection..."
gh api repos/$GITHUB_REPOSITORY/branches/main/protection \
  --method PUT \
  --input scripts/branch-protection.json

# Create dependabot config if it doesn't exist
if [ ! -f .github/dependabot.yml ]; then
  echo "Creating dependabot configuration..."
  mkdir -p .github
  cat > .github/dependabot.yml << 'EOF'
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
EOF
fi

echo "✅ Repository security setup complete!"
echo ""
echo "Next steps:"
echo "1. Review security settings in GitHub repository settings"
echo "2. Add team members with appropriate permissions"
echo "3. Set up monitoring for security alerts"
```

## 📊 Security Monitoring

### GitHub Security Features

- **Security Overview** - Dashboard showing security status
- **Dependabot Alerts** - Vulnerable dependency notifications
- **Secret Scanning Alerts** - Detected secrets in code
- **Code Scanning Alerts** - Static analysis findings

### Regular Security Tasks

- [ ] **Weekly**: Review Dependabot alerts and update dependencies
- [ ] **Monthly**: Review access permissions and remove unused accounts
- [ ] **Quarterly**: Audit security settings and update policies
- [ ] **As needed**: Respond to security alerts within 24-48 hours

### Civic Tech Specific Monitoring

- [ ] **Community data access** - Log who accesses sensitive community information
- [ ] **Partner integration** - Monitor API access from partner organizations
- [ ] **Public data exposure** - Regular review of what data is publicly visible
- [ ] **Compliance checks** - Ensure ongoing compliance with privacy regulations

## 🚨 Security Incident Response

### When Security Alerts Trigger

1. **Immediate (within 1 hour)**:
   - Assess severity of the alert
   - If critical, disable affected functionality
   - Notify team lead and security contact

2. **Short-term (within 24 hours)**:
   - Investigate root cause
   - Implement fix or workaround
   - Test fix in development environment

3. **Follow-up (within 1 week)**:
   - Deploy fix to production
   - Update security documentation
   - Conduct post-incident review

### Emergency Contacts

Update these contacts for your project:

- **Security Lead**: [Name and contact]
- **Technical Lead**: [Name and contact]
- **CTWR Community**: Weekly Wednesday meetings
- **External Support**: [Security consultant, if applicable]

## 🔧 Tool-Specific Security

### For Web Applications

```bash
# Install security scanning tools
npm install --save-dev eslint-plugin-security
npm install --save-dev helmet  # Security headers
npm install --save-dev express-rate-limit  # Rate limiting
```

### For Python Projects

```bash
# Install security tools
pip install bandit  # Security linter
pip install safety  # Dependency vulnerability scanner
pip install secrets  # Secure random generation
```

### For Data Projects

- [ ] **Data encryption** - Encrypt sensitive data at rest
- [ ] **Access logging** - Log all data access
- [ ] **Data retention** - Automatic deletion of old data
- [ ] **Anonymization** - Remove PII from analytics data

## 📋 Security Checklist for Project Phases

### Project Setup (Week 1-3)

- [ ] Enable repository security features
- [ ] Set up branch protection
- [ ] Configure dependabot
- [ ] Review and customize SECURITY.md
- [ ] Add security contacts

### Development Phase (Week 4-9)

- [ ] Follow secure coding practices from [Security Guide](SECURITY_GUIDE.md)
- [ ] Regular dependency updates
- [ ] Code security reviews
- [ ] Input validation testing

### Pre-Launch (Week 10-11)

- [ ] Security audit/penetration testing
- [ ] Review all security configurations
- [ ] Test incident response procedures
- [ ] Final security documentation review

### Post-Launch (Week 12+)

- [ ] Monitor security alerts
- [ ] Regular security updates
- [ ] Ongoing compliance checks
- [ ] Community feedback on security

## ❓ Common Questions

### "Do I need all these security features for a simple project?"

**Minimum required**:

- Secret scanning (always)
- Branch protection (if multiple contributors)
- Basic HTTPS (if web-facing)

**Add based on project needs**:

- Advanced scanning (if handling sensitive data)
- Audit logging (if partner integrations)
- Formal incident response (if mission-critical)

### "Our team is small - is this overkill?"

Start with the "Quick Security Setup" (5 minutes), then add features as you grow:

- **1-2 people**: Secret scanning + basic branch protection
- **3-5 people**: Add code reviews and dependency monitoring
- **5+ people**: Full security configuration with monitoring

### "How often should we review security settings?"

- **Weekly**: Check and resolve security alerts
- **Monthly**: Review access permissions
- **Quarterly**: Full security configuration audit
- **Annually**: Update security policies and procedures

## 🔗 Related Resources

- **[Security Guide](SECURITY_GUIDE.md)** - Comprehensive security development practices
- **[Contributing Guidelines](CONTRIBUTING.md)** - Security requirements for contributors
- **[Technical Design](TECHNICAL_DESIGN.md)** - Security architecture decisions
- **[Getting Started Guide](../GETTING_STARTED.md)** - Overall project setup including security

---

### Security is a shared responsibility

Every team member should understand basic security practices. Use this guide to build security into your civic tech project from day one.

**Questions about repository security?** Ask at CTWR Wednesday meetings or create a GitHub Discussion.

---

*This repository security guide is part of the CivicTechWR Project Template - helping civic technologists build secure, trustworthy tools for their communities.*
