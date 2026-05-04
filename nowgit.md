# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | SaySpend |
| **Git URL** | git@github.com:asunnyboy861/SaySpend.git |
| **Repo URL** | https://github.com/asunnyboy861/SaySpend |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/SaySpend/ | ✅ Active |
| Support | https://asunnyboy861.github.io/SaySpend/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/SaySpend/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/SaySpend/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

```
SaySpend/
├── SaySpend/                        # iOS App Source Code
│   ├── SaySpend.xcodeproj/          # Xcode Project
│   ├── SaySpend/                    # Swift Source Files
│   │   ├── Views/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Extensions/
│   │   └── ...
│   └── ...
├── docs/                            # Policy Pages (GitHub Pages)
│   ├── index.html                   # Landing Page
│   ├── support.html                 # Support Page
│   ├── privacy.html                 # Privacy Policy
│   └── terms.html                   # Terms of Use
├── .github/workflows/
│   └── deploy.yml                   # GitHub Pages deployment
├── us.md                            # English Development Guide
├── keytext.md                       # App Store Metadata
├── capabilities.md                  # Capabilities Configuration
├── icon.md                          # App Icon Details
├── price.md                         # Pricing Configuration
└── nowgit.md                        # This File
```
