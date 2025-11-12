# URGENT: Deploy Portfolio to GitHub NOW

## Status: Files are ready locally - just need to push to GitHub!

**All your enhanced files are committed and ready. Follow these 3 steps to deploy:**

---

## Step 1: Create GitHub Repository (2 minutes)

1. Go to: https://github.com/new
2. Repository name: **natashaxavier.github.io** (MUST be exactly this)
3. Make it: **PUBLIC** (required for GitHub Pages)
4. **DO NOT** initialize with README (you already have files)
5. Click "Create repository"

---

## Step 2: Push Your Portfolio (1 minute)

Copy and paste these commands in your terminal:

```bash
cd /Users/rj/Claude_code/natash

# Add GitHub as remote (replace USERNAME with your actual GitHub username)
git remote add origin https://github.com/natashaxavier/natashaxavier.github.io.git

# Rename branch to 'main' (GitHub prefers 'main' over 'master')
git branch -M main

# Push all your files to GitHub
git push -u origin main
```

**If you get a password prompt:** Use a GitHub Personal Access Token (not your password). Create one at: https://github.com/settings/tokens

---

## Step 3: Enable GitHub Pages (1 minute)

1. Go to: https://github.com/natashaxavier/natashaxavier.github.io/settings/pages
2. Under "Source": Select branch **main**
3. Under "Folder": Select **/ (root)**
4. Click "Save"
5. Wait 2-3 minutes for deployment

**Your site will be live at:** https://natashaxavier.github.io

---

## What's Included (All Ready to Deploy)

✅ **Main Portfolio Website** (`index.html`) - with all 6 projects
✅ **6 Enhanced Project Reports** (in `projects/` folder):
   - Social Media Sentiment Analysis
   - Customer Segmentation (RFM)
   - AI Competitor Intelligence Analyzer
   - Marketing Content Generator
   - HR Resume Screener
   - Employee Engagement Analyzer

✅ **Professional Resume** (`Natasha_Xavier_Resume_FINAL.docx`)
✅ **GitHub Profile README** (`PROFILE_README.md`)
✅ **Deployment Script** (`deploy.sh`)
✅ **Documentation** (README.md, PROJECT_STATUS.md, DELIVERY_INSTRUCTIONS.md)

---

## Troubleshooting

**"Permission denied" error?**
- Use a Personal Access Token instead of password
- Generate at: https://github.com/settings/tokens
- Select scopes: `repo`, `workflow`

**"Repository not found"?**
- Make sure you created the repository first (Step 1)
- Use your actual GitHub username in the URL

**"Branch 'master' set up to track remote branch 'main'"?**
- That's fine! Your branch was renamed correctly.

---

## After Deployment

1. Visit https://natashaxavier.github.io to see your live site
2. Create profile README repository:
   - Create new repo named exactly: **natashaxavier** (same as username)
   - Copy content from `PROFILE_README.md`
3. Convert resume to PDF:
   - Open `Natasha_Xavier_Resume_FINAL.docx` in Word
   - File → Save As → PDF
   - Test all hyperlinks work

---

## GitHub Repo Links

Your portfolio references these GitHub repositories (create them later):
- https://github.com/natashaxavier/social-media-sentiment-analysis
- https://github.com/natashaxavier/customer-segmentation-rfm
- https://github.com/natashaxavier/ai-competitor-analyzer
- https://github.com/natashaxavier/marketing-content-generator
- https://github.com/natashaxavier/hr-resume-screener
- https://github.com/natashaxavier/employee-engagement-analyzer

You can create these individual project repos later - the main portfolio will work without them.

---

## Next Steps After Site is Live

1. Test all navigation links
2. Verify all 6 project pages load correctly
3. Convert resume DOCX to PDF
4. Share portfolio URL with job applications
5. Create individual GitHub project repos (optional, can do later)

---

**DEPLOY NOW - Everything is ready!**

Total time: ~4 minutes to go live
