#!/bin/bash
# Isolated deployment script - won't affect terminal git config
# Usage: ./deploy-all-isolated.sh

GITHUB_TOKEN="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"
GITHUB_USER="NatashaXav"
GITHUB_EMAIL="natashaxavier125@gmail.com"

# Project definitions
declare -A PROJECTS=(
    ["social-media-sentiment"]="project-repos/social-media-sentiment|Social Media Sentiment Analysis - 10K tweets NLP|nlp,sentiment-analysis,python,data-analytics"
    ["customer-segmentation"]="project-repos/customer-segmentation|Customer Segmentation RFM Analysis - £685K revenue|rfm-analysis,marketing-analytics,python"
    ["ai-competitor-analyzer"]="project-repos/ai-competitor-analyzer|AI Competitor Intelligence Analyzer - Gemini AI automation|ai,gemini-api,market-research,automation"
    ["marketing-content-generator"]="project-repos/marketing-content-generator|AI Marketing Content Generator - 4x output increase|ai,content-generation,marketing,gemini-api"
    ["hr-resume-screener"]="project-repos/hr-resume-screener|AI HR Resume Screener - 90% time reduction|ai,hr-tech,recruiting,gemini-api"
    ["employee-engagement-ai"]="project-repos/employee-engagement-ai|AI Employee Engagement Analyzer - Survey sentiment analysis|ai,hr-analytics,sentiment-analysis,gemini-api"
    ["portfolio-website"]="project-repos/portfolio-website|Professional Portfolio Website - Data Analytics & AI Projects|portfolio,website,html-css-javascript"
)

create_repo() {
    local name=$1
    local description=$2
    
    echo "📦 Creating repository: $name"
    
    curl -s -X POST "https://api.github.com/user/repos" \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{\"name\":\"$name\",\"description\":\"$description\",\"private\":false}" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✓ Repository created/exists"
        return 0
    else
        echo "⚠ Repository may already exist"
        return 0
    fi
}

echo "🚀 Portfolio Deployment Starting..."
echo "Using credentials: $GITHUB_USER <$GITHUB_EMAIL>"
echo "============================================================"

SUCCESS_COUNT=0
FAIL_COUNT=0

for repo in "${!PROJECTS[@]}"; do
    IFS='|' read -r path description topics <<< "${PROJECTS[$repo]}"
    
    echo ""
    echo "📂 Processing: $repo"
    
    if [ ! -d "$path" ]; then
        echo "✗ Path not found: $path"
        ((FAIL_COUNT++))
        continue
    fi
    
    # Create GitHub repo
    create_repo "$repo" "$description"
    
    # Deploy with project-specific git config
    cd "$path" || continue
    
    # Initialize git if needed
    if [ ! -d ".git" ]; then
        git init > /dev/null 2>&1
        echo "✓ Git initialized"
    fi
    
    # Configure git for THIS repo only (not global)
    git config user.name "$GITHUB_USER"
    git config user.email "$GITHUB_EMAIL"
    echo "✓ Git configured for this project only"
    
    # Configure remote
    git remote remove origin 2>/dev/null
    git remote add origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${repo}.git" 2>/dev/null
    
    # Stage all files
    git add .
    
    # Create commit with meaningful message
    COMMIT_MSG="Initial commit: $description

Professional data analytics and AI automation portfolio project.
Includes real data analysis, technical documentation, and production-ready code.

Created by: $GITHUB_USER
Date: $(date +%Y-%m-%d)"
    
    git commit -m "$COMMIT_MSG" > /dev/null 2>&1
    
    echo "  → Pushing to GitHub..."
    git branch -M main > /dev/null 2>&1
    
    if git push -u origin main --force > /dev/null 2>&1; then
        echo "✓ $repo deployed successfully!"
        echo "  URL: https://github.com/$GITHUB_USER/$repo"
        ((SUCCESS_COUNT++))
    else
        echo "✗ Failed to push $repo"
        ((FAIL_COUNT++))
    fi
    
    cd - > /dev/null
done

echo ""
echo "============================================================"
echo "📊 Deployment Summary:"
echo "  ✓ Successful: $SUCCESS_COUNT"
echo "  ✗ Failed: $FAIL_COUNT"
echo ""

if [ $SUCCESS_COUNT -eq 7 ]; then
    echo "🎉 All projects deployed successfully!"
    echo ""
    echo "View your portfolio at:"
    echo "  https://github.com/$GITHUB_USER"
    echo ""
    echo "Next steps:"
    echo "  1. Check each repo on GitHub"
    echo "  2. Deploy portfolio-website to Vercel"
    echo "  3. Enhance technical report pages progressively"
else
    echo "⚠ Some deployments had issues. Check errors above."
fi
