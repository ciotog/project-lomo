# GitHub Pages Setup for CivicTechWR Projects

GitHub Pages provides free hosting for project websites, documentation, and live demos - perfect for civic tech projects that need public-facing sites.

## 🚀 Quick Start: Enable GitHub Pages (2 Minutes)

### 1. Enable Pages in Repository Settings

```bash
# Enable GitHub Pages via CLI (requires admin permissions)
gh api repos/OWNER/REPO/pages \
  --method POST \
  --field source='{"branch":"main","path":"/docs"}' \
  --field build_type="workflow"
```

**Or manually:**

1. Go to your repository on GitHub
2. Click **Settings** → **Pages**
3. Set **Source** to "Deploy from a branch"
4. Choose **Branch**: `main` and **Folder**: `/docs` or `/`
5. Click **Save**

### 2. Your Site Will Be Available At

`https://USERNAME.github.io/REPOSITORY-NAME`

## 📋 GitHub Pages Use Cases for Civic Tech

### 🌐 Project Website

**Perfect for:** Public-facing project information, team bios, project status

**Setup:** Use `/docs` folder for Jekyll site with project information

- Landing page explaining the project's civic impact
- Team member profiles and contact information
- Project timeline and current status
- Links to live demo and GitHub repository

### 📚 Documentation Site

**Perfect for:** User guides, API documentation, setup instructions

**Setup:** Use automated documentation generation (MkDocs, Gitiles, etc.)

- User manuals for community members
- Developer documentation and API references
- Setup and installation guides
- FAQ and troubleshooting

### 🎯 Live Demo/Prototype

**Perfect for:** Interactive demos, data visualizations, web applications

**Setup:** Deploy built application to GitHub Pages

- Working prototypes for user testing
- Data dashboards and visualizations
- Interactive tools for community use
- Demo versions for presentations

## 🛠️ Setup Options

### Option 1: Simple Jekyll Site (Recommended for Project Websites)

Create `/docs` folder structure:

```text
docs/
├── _config.yml          # Jekyll configuration
├── index.md            # Home page
├── about.md            # About the project
├── team.md             # Team information
├── demo.md             # Live demo links
└── _layouts/
    └── default.html    # Site layout
```

**Basic `_config.yml`:**

```yaml
title: "[Your Project Name]"
description: "CivicTechWR Season X Project"
theme: minima
plugins:
  - jekyll-feed
  - jekyll-sitemap

# CivicTechWR branding
header_pages:
  - about.md
  - team.md
  - demo.md

# Social links
github_username: CivicTechWR
civictech_url: "https://civictechwr.org"
```

### Option 2: Custom HTML/CSS Site

Create `/docs` folder with static files:

```
docs/
├── index.html          # Main page
├── style.css           # Custom styling
├── script.js           # Interactive elements
└── assets/
    ├── images/
    └── data/
```

### Option 3: GitHub Actions Deployment

For React, Vue, Angular, or other built applications:

```text
project-root/
├── src/                # Source code
├── public/             # Static assets
├── package.json        # Dependencies
└── .github/workflows/
    └── deploy-pages.yml # Deployment workflow
```

## 🔧 GitHub Pages Deployment Workflows

### Jekyll Site Deployment

Create `.github/workflows/pages-jekyll.yml`:

```yaml
name: Deploy Jekyll Site to Pages

on:
  push:
    branches: [ main ]
    paths: [ 'docs/**' ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.1'
          bundler-cache: true
          working-directory: docs

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4

      - name: Build with Jekyll
        run: bundle exec jekyll build --baseurl "${{ steps.pages.outputs.base_path }}"
        working-directory: docs
        env:
          JEKYLL_ENV: production

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: docs/_site

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### React/Vue/Angular App Deployment

Create `.github/workflows/pages-spa.yml`:

```yaml
name: Deploy SPA to Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build application
        run: npm run build
        env:
          # Set base URL for GitHub Pages
          PUBLIC_URL: ${{ github.event.repository.name }}

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./dist  # or ./build for Create React App

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

## 📖 Documentation Site with MkDocs

### Setup MkDocs for Documentation

```bash
# Install MkDocs
pip install mkdocs mkdocs-material

# Initialize MkDocs site
mkdocs new docs-site
cd docs-site

# Configure mkdocs.yml
cat > mkdocs.yml << 'EOF'
site_name: '[Your Project] Documentation'
site_description: 'CivicTechWR Project Documentation'
site_author: 'CivicTechWR Team'
site_url: 'https://USERNAME.github.io/REPO-NAME'

theme:
  name: material
  palette:
    primary: 'blue'
    accent: 'light blue'
  features:
    - navigation.sections
    - navigation.top

nav:
  - Home: index.md
  - User Guide: user-guide.md
  - Developer Docs: developer.md
  - API Reference: api.md
  - Contributing: contributing.md

markdown_extensions:
  - admonition
  - codehilite
  - toc:
      permalink: true
EOF

# Build and test locally
mkdocs serve
```

### MkDocs Deployment Workflow

Create `.github/workflows/docs.yml`:

```yaml
name: Deploy Documentation

on:
  push:
    branches: [ main ]
    paths: [ 'docs-site/**' ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: 3.x

      - name: Install dependencies
        run: |
          pip install mkdocs mkdocs-material

      - name: Build docs
        run: mkdocs build --config-file docs-site/mkdocs.yml

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: site

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

## 🎨 Civic Tech Website Templates

### Project Landing Page Template

Create `docs/index.md`:

```markdown
---
layout: default
title: Home
---

# [Your Project Name]

## Solving [Community Problem] for [Target Community]

**CivicTechWR Season X Project**

### 🎯 Project Mission
[One sentence describing what your project does and who it helps]

### 🏛️ Civic Impact
- **Community Partner**: [Partner organization name]
- **Target Users**: [Who will use this?]
- **Expected Impact**: [What change will this create?]

### 🚀 Current Status
- **Phase**: [Research/Development/Testing/Live]
- **Last Updated**: [Date]
- **Next Milestone**: [What's coming next?]

### 📊 Key Metrics
- **Users Served**: [Number]
- **Community Feedback**: [Rating/summary]
- **Partnership Status**: [Active/developing]

### 🔗 Quick Links
- [Live Demo]({{ '/demo/' | relative_url }}) - Try the tool
- [GitHub Repository](https://github.com/OWNER/REPO) - Source code
- [Team Information](team.html) - Meet the team
- [Project Documentation](docs/) - Technical details

### 📅 Demo Day Presentation
[Embed or link to final presentation when available]

---

**Built with ❤️ by the CivicTechWR community** • [Learn more about CivicTechWR](https://civictechwr.org)
```

### Team Page Template

Create `docs/team.md`:

```markdown
---
layout: default
title: Team
---

# Meet the Team

## Project Lead
**[Name]** - [Role]
- GitHub: [@username](https://github.com/username)
- Focus: [Primary responsibility]
- Why civic tech: [Personal motivation]

## Team Members
**[Name]** - [Role]
- GitHub: [@username](https://github.com/username)
- Skills: [Key skills]
- Contribution: [What they're working on]

## Community Partners
**[Organization Name]**
- Contact: [Name, role]
- Partnership: [How they're involved]
- Website: [URL]

## How to Join
Interested in contributing? Check out our [Contributing Guide](../CONTRIBUTING.md) or join us at [CTWR Wednesday meetings](https://civictechwr.org).

## Acknowledgments
- CivicTechWR community
- [Data sources, inspiration, other credits]
```

## 🔒 Security Considerations for GitHub Pages

### Public Repository Content

- **All content is public** - Never include sensitive data in Pages sites
- **Environment variables** - Use GitHub Secrets for build-time configuration
- **API keys** - Never expose API keys in client-side code

### Content Security

- **Input validation** - Sanitize any user-generated content
- **HTTPS enforcement** - GitHub Pages enforces HTTPS by default
- **Domain security** - Use custom domains with proper DNS configuration

### Privacy Compliance

- **Analytics** - Use privacy-focused analytics (avoid Google Analytics for government data)
- **Cookies** - Minimal cookie usage, clear privacy policy
- **Data collection** - Document what data (if any) is collected

## 📈 Analytics and Monitoring

### Simple Analytics Setup

Add to your Jekyll `_config.yml`:

```yaml
# Privacy-focused analytics
plausible:
  domain: yourdomain.github.io
  src: https://plausible.io/js/plausible.js

# Or use GitHub's built-in insights
google_analytics: false  # Avoid for civic projects
```

### Monitoring Site Health

- **GitHub Actions status** - Monitor deployment success
- **Link checking** - Validate external links regularly
- **Accessibility testing** - Automated a11y checks in CI
- **Performance monitoring** - Lighthouse CI integration

## 🚀 Advanced GitHub Pages Features

### Custom Domain Setup

1. **Add CNAME file** to `/docs` folder with your domain
2. **Configure DNS** - Point CNAME record to `USERNAME.github.io`
3. **Enable HTTPS** - GitHub automatically provisions SSL certificates

### Multi-language Support

```text
docs/
├── en/
│   ├── index.md
│   └── about.md
├── fr/
│   ├── index.md
│   └── about.md
└── _config.yml
```

### API Integration

For dynamic content, use client-side API calls:

```javascript
// Fetch live data from your project's API
fetch('/api/status')
  .then(response => response.json())
  .then(data => updateStatusDisplay(data));
```

## 📋 GitHub Pages Checklist

### Initial Setup

- [ ] Enable GitHub Pages in repository settings
- [ ] Choose deployment source (branch + folder or GitHub Actions)
- [ ] Create basic site structure
- [ ] Configure Jekyll theme (if using Jekyll)
- [ ] Test site locally before deploying

### Content Creation

- [ ] Write compelling project landing page
- [ ] Create team member profiles
- [ ] Document project status and milestones
- [ ] Add links to live demo and repository
- [ ] Include civic impact metrics

### Technical Configuration

- [ ] Set up automated deployment workflow
- [ ] Configure custom domain (if applicable)
- [ ] Add security headers and privacy policy
- [ ] Set up analytics (privacy-focused)
- [ ] Test accessibility and performance

### Ongoing Maintenance

- [ ] Update project status regularly
- [ ] Monitor site performance and uptime
- [ ] Keep dependencies updated
- [ ] Review and update content monthly
- [ ] Respond to community feedback

## ❓ Common Questions

### "Do I need GitHub Pages for my civic tech project?"

**Yes, if you need:**

- Public project website for community engagement
- Documentation site for users and developers
- Live demo hosting for stakeholder reviews
- Professional presence for Demo Day

**Maybe, if you have:**

- Simple projects that only need a README
- Enterprise hosting requirements
- Complex backend services (consider GitHub Pages + external API)

### "What's the difference between Jekyll and custom HTML?"

- **Jekyll**: Better for content-heavy sites, blog posts, documentation
- **Custom HTML**: More control, better for interactive applications
- **Static Site Generators**: MkDocs for docs, Gatsby/Next.js for apps

### "How do I handle sensitive civic data?"

- **Never put sensitive data in GitHub Pages** (it's public)
- **Use external APIs** for dynamic data (with proper authentication)
- **Static analysis only** - pre-process sensitive data before publishing
- **Link to secure services** - Pages as frontend, secure backend elsewhere

## 🔗 Related Resources

- **[Technical Design](TECHNICAL_DESIGN.md)** - Architecture decisions including Pages integration
- **[Security Guide](SECURITY_GUIDE.md)** - Security considerations for public sites
- **[Accessibility Guide](ACCESSIBILITY_GUIDE.md)** - Making your Pages site accessible
- **[Demo Prep](DEMO_PREP.md)** - Using Pages for Demo Day presentations

---

### GitHub Pages makes your civic tech project accessible to the entire community

Use Pages to showcase your work, engage stakeholders, and demonstrate the real-world impact of your civic technology project.

**Questions about GitHub Pages?** Ask at CTWR Wednesday meetings or create a GitHub Discussion.

---

*This GitHub Pages guide is part of the CivicTechWR Project Template - helping civic technologists share their work with the world.*
