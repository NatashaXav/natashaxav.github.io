#!/bin/bash
# Simple deployment script for macOS compatibility
# Each project deployed individually

TOKEN="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"
USER="NatashaXav"
EMAIL="natashaxavier125@gmail.com"

echo "🚀 Starting Portfolio Deployment"
echo "========================================"

deploy_project() {
    local PROJECT_NAME=$1
    local PROJECT_PATH=$2
    local DESCRIPTION=$3

    echo ""
    echo "📂 Deploying: $PROJECT_NAME"

    if [ ! -d "$PROJECT_PATH" ]; then
        echo "✗ Path not found: $PROJECT_PATH"
        return 1
    fi

    # Create GitHub repo
    echo "  → Creating GitHub repository..."
    curl -s -X POST "https://api.github.com/user/repos" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{\"name\":\"$PROJECT_NAME\",\"description\":\"$DESCRIPTION\",\"private\":false}" > /dev/null 2>&1

    # Deploy
    cd "$PROJECT_PATH" || return 1

    # Initialize git if needed
    if [ ! -d ".git" ]; then
        git init > /dev/null 2>&1
    fi

    # Configure git for THIS repo only
    git config user.name "$USER"
    git config user.email "$EMAIL"

    # Configure remote
    git remote remove origin 2>/dev/null
    git remote add origin "https://${TOKEN}@github.com/${USER}/${PROJECT_NAME}.git" 2>/dev/null

    # Stage and commit
    git add . > /dev/null 2>&1
    git commit -m "Initial commit: $DESCRIPTION

Professional data analytics and AI portfolio project.
Includes analysis code, documentation, and real-world applications.

Created by: Natasha Xavier" > /dev/null 2>&1

    # Push
    echo "  → Pushing to GitHub..."
    git branch -M main > /dev/null 2>&1

    if git push -u origin main --force > /dev/null 2>&1; then
        echo "✓ $PROJECT_NAME deployed!"
        echo "  URL: https://github.com/$USER/$PROJECT_NAME"
        cd - > /dev/null
        return 0
    else
        echo "✗ Failed to push $PROJECT_NAME"
        cd - > /dev/null
        return 1
    fi
}

# Deploy each project
SUCCESS=0
TOTAL=7

deploy_project "social-media-sentiment" "project-repos/social-media-sentiment" "Social Media Sentiment Analysis - 10K tweets NLP project" && ((SUCCESS++))

deploy_project "customer-segmentation" "project-repos/customer-segmentation" "Customer Segmentation RFM Analysis - £685K revenue insights" && ((SUCCESS++))

deploy_project "ai-competitor-analyzer" "project-repos/ai-competitor-analyzer" "AI Competitor Intelligence Analyzer - Automated market research with Gemini AI" && ((SUCCESS++))

deploy_project "marketing-content-generator" "project-repos/marketing-content-generator" "AI Marketing Content Generator - 4x output increase with Gemini AI" && ((SUCCESS++))

deploy_project "hr-resume-screener" "project-repos/hr-resume-screener" "AI HR Resume Screener - 90% time reduction in candidate screening" && ((SUCCESS++))

deploy_project "employee-engagement-ai" "project-repos/employee-engagement-ai" "AI Employee Engagement Analyzer - Survey sentiment analysis with Gemini AI" && ((SUCCESS++))

deploy_project "portfolio-website" "project-repos/portfolio-website" "Professional Portfolio Website - Data Analytics & AI Projects Showcase" && ((SUCCESS++))

echo ""
echo "========================================"
echo "📊 Deployment Summary"
echo "  ✓ Successful: $SUCCESS/$TOTAL"
echo ""

if [ $SUCCESS -eq $TOTAL ]; then
    echo "🎉 All projects deployed successfully!"
    echo ""
    echo "View your portfolio at:"
    echo "  https://github.com/$USER"
else
    echo "⚠ Some deployments had issues"
fi
