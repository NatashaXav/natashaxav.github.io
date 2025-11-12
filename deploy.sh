#!/bin/bash

# Portfolio Deployment Script
# Natasha Xavier - Professional Portfolio
# ========================================

set -e  # Exit on error

echo "🚀 Starting Portfolio Deployment..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "${YELLOW}Initializing git repository...${NC}"
    git init
    echo "${GREEN}✓ Git initialized${NC}"
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "master" ]; then
    echo "${YELLOW}Renaming branch from master to main...${NC}"
    git branch -M main
    echo "${GREEN}✓ Branch renamed to main${NC}"
fi

# Check if remote exists
if ! git remote | grep -q "origin"; then
    echo ""
    echo "${RED}❌ No remote configured!${NC}"
    echo ""
    echo "Please create a GitHub repository first:"
    echo "  1. Go to https://github.com/new"
    echo "  2. Repository name: ${YELLOW}natashaxavier.github.io${NC}"
    echo "  3. Make it ${YELLOW}public${NC}"
    echo "  4. Do NOT initialize with README"
    echo ""
    echo "Then run this command to add the remote:"
    echo "${YELLOW}  git remote add origin https://github.com/natashaxavier/natashaxavier.github.io.git${NC}"
    echo ""
    echo "After that, run this script again."
    exit 1
fi

# Stage all important files
echo "${YELLOW}Staging files...${NC}"

# Add essential files
git add index.html
git add projects/*.html
git add project-repos/**/*.md
git add README.md
git add PROFILE_README.md
git add Natasha_Xavier_Resume_FINAL.docx
git add Natasha_Xavier_Resume_Final.txt
git add .gitignore

# Add documentation
git add DELIVERY_INSTRUCTIONS.md 2>/dev/null || true
git add PROJECT_STATUS.md 2>/dev/null || true

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "${YELLOW}No changes to commit. Checking if initial commit needed...${NC}"
    if git log --oneline -1 &> /dev/null; then
        echo "${GREEN}✓ Repository is up to date${NC}"
        exit 0
    fi
fi

echo "${GREEN}✓ Files staged${NC}"

# Show what's being committed
echo ""
echo "${YELLOW}Files to be committed:${NC}"
git diff --cached --name-status
echo ""

# Create commit
echo "${YELLOW}Creating commit...${NC}"
git commit -m "Portfolio deployment - Nov 2025

✨ Complete professional portfolio for UK job market

Deliverables:
- Professional resume with hyperlinks (DOCX format)
- 6 enhanced project HTML reports with publication quality
- GitHub profile README and project READMEs
- Consistent branding across all materials
- ATS-optimized content focused on UK market

Key Features:
- Social Media Sentiment Analysis (87% accuracy, £5K+ savings)
- Customer Segmentation RFM (973 customers, £685K revenue)
- AI Competitor Analyzer (20x ROI vs traditional research)
- Marketing Content Generator (4x output, 15 hrs/week saved)
- HR Resume Screener (90% faster screening)
- Employee Engagement Analyzer (40 hrs/survey saved)

Technical Stack:
- AI & Automation: CrewAI, LangChain, Gemini AI, Claude AI
- Marketing: SEMrush, Google Analytics, Tableau, RFM Analysis
- HR Tech: ATS platforms, Workday, HRIS systems
- Non-technical positioning for business roles

Target Roles: Marketing Analytics (£40-60K), HR Tech (£45-70K)

🤖 Generated with Claude Code (https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

echo "${GREEN}✓ Commit created${NC}"

# Push to GitHub
echo ""
echo "${YELLOW}Pushing to GitHub...${NC}"

# Check if branch exists on remote
if git ls-remote --exit-code --heads origin main &> /dev/null; then
    # Branch exists, just push
    git push origin main
else
    # First push, set upstream
    git push -u origin main
fi

echo ""
echo "${GREEN}✅ Deployment successful!${NC}"
echo ""
echo "================================================"
echo "📋 ${YELLOW}NEXT STEPS:${NC}"
echo "================================================"
echo ""
echo "1. ${YELLOW}Enable GitHub Pages:${NC}"
echo "   - Go to: https://github.com/natashaxavier/natashaxavier.github.io/settings/pages"
echo "   - Source: Deploy from a branch"
echo "   - Branch: ${YELLOW}main${NC}"
echo "   - Folder: ${YELLOW}/ (root)${NC}"
echo "   - Click ${YELLOW}Save${NC}"
echo ""
echo "2. ${YELLOW}Wait 2-3 minutes${NC} for deployment"
echo ""
echo "3. ${YELLOW}Visit your live site:${NC}"
echo "   https://natashaxav.github.io"
echo ""
echo "4. ${YELLOW}Create GitHub Profile README:${NC}"
echo "   - Create new repo: ${YELLOW}natashaxavier${NC} (same as username)"
echo "   - Make it public"
echo "   - Copy content from ${YELLOW}PROFILE_README.md${NC}"
echo ""
echo "5. ${YELLOW}Convert Resume to PDF:${NC}"
echo "   - Open ${YELLOW}Natasha_Xavier_Resume_FINAL.docx${NC}"
echo "   - Save As → PDF"
echo "   - Test all hyperlinks"
echo ""
echo "================================================"
echo ""
echo "${GREEN}Portfolio repository: https://github.com/natashaxavier/natashaxavier.github.io${NC}"
echo "${GREEN}Profile README: Copy from PROFILE_README.md${NC}"
echo ""
echo "✨ Your professional portfolio is now live!"
echo ""
