#!/bin/bash
# Deployment script for all portfolio projects
# Usage: ./deploy-all.sh YOUR_GITHUB_TOKEN

if [ -z "$1" ]; then
    echo "❌ Error: GitHub token required"
    echo "Usage: ./deploy-all.sh YOUR_GITHUB_TOKEN"
    exit 1
fi

GITHUB_TOKEN="$1"
GITHUB_USER="NatashaXav"

# Project definitions
declare -A PROJECTS=(
    ["social-media-sentiment"]="project-repos/social-media-sentiment|Social Media Sentiment Analysis|nlp,sentiment-analysis,python"
    ["customer-segmentation"]="project-repos/customer-segmentation|Customer Segmentation RFM Analysis|rfm-analysis,marketing-analytics"
    ["ai-competitor-analyzer"]="project-repos/ai-competitor-analyzer|AI Competitor Intelligence Analyzer|ai,gemini-api,automation"
    ["marketing-content-generator"]="project-repos/marketing-content-generator|AI Marketing Content Generator|ai,content-generation,gemini-api"
    ["hr-resume-screener"]="project-repos/hr-resume-screener|AI HR Resume Screener|ai,hr-tech,gemini-api"
    ["employee-engagement-ai"]="project-repos/employee-engagement-ai|AI Employee Engagement Analyzer|ai,hr-analytics,gemini-api"
    ["portfolio-website"]="project-repos/portfolio-website|Professional Portfolio Website|portfolio,website,html-css"
)

create_repo() {
    local name=$1
    local description=$2
    
    echo "📦 Creating repository: $name"
    
    curl -s -X POST "https://api.github.com/user/repos"         -H "Authorization: Bearer $GITHUB_TOKEN"         -H "Accept: application/vnd.github.v3+json"         -d "{"name":"$name","description":"$description","private":false}" > /dev/null
    
    echo "✓ Repository created"
}

echo "🚀 Portfolio Deployment Starting..."
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
    
    # Deploy
    cd "$path" || continue
    
    # Initialize git
    [ ! -d ".git" ] && git init > /dev/null 2>&1
    
    # Configure remote
    git remote remove origin 2>/dev/null
    git remote add origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${repo}.git" 2>/dev/null
    
    # Commit and push
    git add .
    git commit -m "Initial commit: $description" > /dev/null 2>&1
    git branch -M main
    
    echo "  → Pushing to GitHub..."
    if git push -u origin main --force > /dev/null 2>&1; then
        echo "✓ $repo deployed successfully!"
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

if [ $SUCCESS_COUNT -eq 7 ]; then
    echo ""
    echo "🎉 All projects deployed successfully!"
    echo "View your portfolio at: https://github.com/$GITHUB_USER"
fi
