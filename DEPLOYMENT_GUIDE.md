# Deployment Guide

## Quick Start

Deploy all 7 repositories (6 projects + 1 website) to GitHub:

**Windows (PowerShell):**
```powershell
./deploy-all.ps1 YOUR_GITHUB_TOKEN
```

**Mac/Linux (Bash):**
```bash
./deploy-all.sh YOUR_GITHUB_TOKEN
```

## What Gets Deployed

1. **social-media-sentiment** - Sentiment Analysis (10K tweets)
2. **customer-segmentation** - RFM Analysis (£685K revenue)
3. **ai-competitor-analyzer** - AI competitor monitoring
4. **marketing-content-generator** - AI content creation
5. **hr-resume-screener** - AI resume screening
6. **employee-engagement-ai** - AI survey analysis
7. **portfolio-website** - Main portfolio site (private repo)

## Prerequisites

1. Get GitHub Personal Access Token:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select scopes: `repo`, `user`
   - Copy the token

2. Ensure all project files are in `project-repos/` directory

## Post-Deployment

### Deploy Website to Vercel:

1. Import `portfolio-website` repo to Vercel
2. Configure:
   - Framework Preset: Other
   - Build Command: (leave empty)
   - Output Directory: `.`
   - Install Command: (leave empty)

3. Deploy!

### GitHub Repository Settings:

For each project repo:
- Add description and topics (done automatically)
- Enable GitHub Pages if desired
- Add README badges

## Manual Deployment (Single Project)

```bash
cd project-repos/PROJECT_NAME
git init
git remote add origin https://YOUR_TOKEN@github.com/natashaxav/PROJECT_NAME.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

## Troubleshooting

**Error: Repository already exists**
- Script will update existing repo automatically

**Error: Authentication failed**
- Check your GitHub token is valid
- Ensure token has `repo` scope

**Error: Path not found**
- Verify `project-repos/` directory structure
- Ensure all projects are in correct paths

## Security Notes

- Token is used in memory only, not stored
- `.env` file with Gemini API key is gitignored
- Website repo is set to private by default
