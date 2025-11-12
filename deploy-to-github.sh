#!/bin/bash

# GitHub Deployment Script with Token Authentication
# Usage: ./deploy-to-github.sh YOUR_GITHUB_TOKEN

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}GitHub Portfolio Deployment${NC}"
echo -e "${GREEN}========================================${NC}\n"

# Check if token provided
if [ -z "$1" ]; then
    echo -e "${RED}ERROR: GitHub token required${NC}"
    echo "Usage: ./deploy-to-github.sh YOUR_GITHUB_TOKEN"
    echo ""
    echo "Get your token at: https://github.com/settings/tokens"
    echo "Required permissions: repo (all)"
    exit 1
fi

GITHUB_TOKEN=$1
GITHUB_USER="natashaxavier"

# Projects to deploy
PROJECTS=(
    "social-media-sentiment"
    "customer-segmentation"
    "hr-attrition-prediction"
    "marketing-roi-dashboard"
    "employee-engagement-analysis"
)

# Function to create GitHub repo via API
create_repo() {
    PROJECT=$1
    echo -e "\n${BLUE}Creating repository: ${PROJECT}${NC}"

    RESPONSE=$(curl -s -X POST \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/user/repos \
        -d "{
            \"name\": \"${PROJECT}\",
            \"description\": \"Data analytics portfolio project: ${PROJECT}\",
            \"private\": false,
            \"auto_init\": false
        }")

    if echo "$RESPONSE" | grep -q "\"name\": \"${PROJECT}\""; then
        echo -e "${GREEN}✓ Repository created${NC}"
        return 0
    elif echo "$RESPONSE" | grep -q "name already exists"; then
        echo -e "${YELLOW}Repository already exists${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to create repository${NC}"
        echo "$RESPONSE"
        return 1
    fi
}

# Function to add topics to repo
add_topics() {
    PROJECT=$1
    echo "Adding topics..."

    curl -s -X PUT \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/${GITHUB_USER}/${PROJECT}/topics \
        -d '{
            "names": ["data-analysis", "excel", "portfolio", "marketing-analytics", "hr-analytics", "business-intelligence"]
        }' > /dev/null

    echo -e "${GREEN}✓ Topics added${NC}"
}

# Function to deploy a project
deploy_project() {
    PROJECT=$1
    PROJECT_DIR="project-repos/${PROJECT}"

    echo -e "\n${YELLOW}========================================${NC}"
    echo -e "${YELLOW}Deploying: ${PROJECT}${NC}"
    echo -e "${YELLOW}========================================${NC}"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Directory $PROJECT_DIR not found${NC}"
        return 1
    fi

    cd "$PROJECT_DIR"

    # Remove empty directories
    find . -type d -empty -delete

    # Initialize git if needed
    if [ ! -d ".git" ]; then
        echo "Initializing git..."
        git init
        git branch -M main
    fi

    # Create .gitignore if missing
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*.so
.Python
venv/
ENV/
env/

# Jupyter
.ipynb_checkpoints

# Data (keep small samples only)
data/*.csv
!data/sample_*.csv

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
EOF
    fi

    # Add all files
    git add .

    # Check if there are changes
    if git diff --cached --quiet; then
        echo -e "${YELLOW}No changes to commit${NC}"
    else
        # Commit
        git commit -m "Portfolio project: ${PROJECT}

Complete analysis with Excel workbooks, visualizations, and business insights.

Skills: Data Analysis, Excel, Business Strategy, Analytics

🤖 Portfolio Project"

        # Set remote with token
        REMOTE_URL="https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${PROJECT}.git"

        if git remote get-url origin > /dev/null 2>&1; then
            git remote set-url origin "$REMOTE_URL"
        else
            git remote add origin "$REMOTE_URL"
        fi

        # Push
        echo "Pushing to GitHub..."
        git push -u origin main --force

        echo -e "${GREEN}✓ Successfully deployed${NC}"
    fi

    cd - > /dev/null
}

# Main execution
echo "This will deploy all 5 portfolio projects to GitHub"
echo ""
echo "Projects:"
for PROJECT in "${PROJECTS[@]}"; do
    echo "  - ${PROJECT}"
done
echo ""

read -p "Continue? (y/n): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Create all repositories
echo -e "\n${BLUE}Creating GitHub repositories...${NC}"
for PROJECT in "${PROJECTS[@]}"; do
    create_repo "$PROJECT"
    sleep 1
done

# Deploy all projects
echo -e "\n${BLUE}Deploying projects...${NC}"
for PROJECT in "${PROJECTS[@]}"; do
    deploy_project "$PROJECT"
    add_topics "$PROJECT"
    sleep 1
done

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo "Your repositories:"
for PROJECT in "${PROJECTS[@]}"; do
    echo "  🔗 https://github.com/${GITHUB_USER}/${PROJECT}"
done
echo ""
echo -e "${GREEN}Success! 🚀${NC}\n"
