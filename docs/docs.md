---
layout: default
title: Documentation
---

## CivicTechWR Project Documentation Hub

Welcome! This page gathers all of the key resources bundled with the CivicTechWR Project Template. Customize it with links that make sense for your project once you populate the repo.

### Quick Start

- ✅ Run the setup scripts in order (`./scripts/setup.sh --check`, then `./scripts/setup.sh`, `./scripts/setup-project.sh`, `./scripts/setup-security.sh`).
- ✅ Update the README and wiki home with your project details.
- ✅ Create your first issues using the quick templates below and assign them in your GitHub Project.
- ⏩ Come back here whenever you need the deep-dive docs linked in the sections below.
- ℹ️ Host your repo under [github.com/CivicTechWR](https://github.com/CivicTechWR) when possible; if you stay in a personal namespace, make it public so GitHub Pages can publish the docs site.

### Core References

- [Getting Started Guide]({{ site.github.repository_url }}/blob/main/GETTING_STARTED.md)
- [Project Pitch Template]({{ site.github.repository_url }}/blob/main/docs/PROJECT_PITCH.md)
- [Technical Design Doc]({{ site.github.repository_url }}/blob/main/docs/TECHNICAL_DESIGN.md)
- [User Research Toolkit]({{ site.github.repository_url }}/blob/main/docs/USER_RESEARCH.md)

### Operations & Governance

- [Project Management Guide]({{ site.github.repository_url }}/blob/main/docs/PROJECT_MANAGEMENT.md)
- [Security Guide]({{ site.github.repository_url }}/blob/main/docs/SECURITY_GUIDE.md)
- [Repository Security Checklist]({{ site.github.repository_url }}/blob/main/docs/REPOSITORY_SECURITY.md)
- [Accessibility Guide]({{ site.github.repository_url }}/blob/main/docs/ACCESSIBILITY_GUIDE.md)
- [Demo Prep Guide]({{ site.github.repository_url }}/blob/main/docs/DEMO_PREP.md)

### Additional Resources

- [Impact Tracking Framework]({{ site.github.repository_url }}/blob/main/docs/IMPACT_TRACKING.md)
- [Contributing Guidelines]({{ site.github.repository_url }}/blob/main/docs/CONTRIBUTING.md)
- [Wiki Templates]({{ site.github.repository_url }}/blob/main/wiki-template/README.md)
- [Quick Task Issue Template]({{ site.github.repository_url }}/blob/main/.github/ISSUE_TEMPLATE/quick_task.yml) – 2-minute lightweight ticket

### Linting & Formatting Workflow

- Run `npm run lint` to execute ESLint with the template’s flat config (`eslint.config.cjs`).
- Run `npm run format` for a non-destructive Prettier check or `npm run format:fix` to write changes.
- Our CI `lint-validation` job runs both commands on every push/PR; ensure local runs are clean before committing.

> ℹ️ Update links and add any project-specific documentation (API references, user manuals, research reports) as your team builds them out.
