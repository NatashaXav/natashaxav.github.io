#!/bin/bash

# Master GitHub Deployment Script for Portfolio Projects
# Author: Natasha Xavier
# Date: January 2025

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Portfolio Projects Deployment Script${NC}"
echo -e "${GREEN}========================================${NC}\n"

# GitHub username
GITHUB_USER="natashaxavier"

# Project directories
PROJECTS=(
    "social-media-sentiment"
    "customer-segmentation"
    "hr-attrition-prediction"
    "marketing-roi-dashboard"
    "employee-engagement"
)

# Function to check if gh CLI is installed
check_gh_cli() {
    if command -v gh &> /dev/null; then
        echo -e "${GREEN}✓ GitHub CLI found${NC}"
        return 0
    else
        echo -e "${YELLOW}! GitHub CLI not found${NC}"
        echo "Install it from: https://cli.github.com/"
        return 1
    fi
}

# Function to create GitHub repository using gh CLI
create_github_repo() {
    PROJECT_NAME=$1
    echo -e "\n${BLUE}Creating GitHub repository: ${PROJECT_NAME}${NC}"

    # Check if repo already exists
    if gh repo view "${GITHUB_USER}/${PROJECT_NAME}" &> /dev/null; then
        echo -e "${YELLOW}Repository already exists${NC}"
        return 0
    fi

    # Create repository
    gh repo create "${GITHUB_USER}/${PROJECT_NAME}" \
        --public \
        --description "Data science portfolio project demonstrating ${PROJECT_NAME} analysis" \
        --confirm

    echo -e "${GREEN}✓ Repository created${NC}"
}

# Function to deploy a single project
deploy_project() {
    PROJECT_NAME=$1
    PROJECT_DIR="project-repos/${PROJECT_NAME}"

    echo -e "\n${YELLOW}========================================${NC}"
    echo -e "${YELLOW}Deploying: ${PROJECT_NAME}${NC}"
    echo -e "${YELLOW}========================================${NC}"

    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Directory $PROJECT_DIR does not exist${NC}"
        return 1
    fi

    cd "$PROJECT_DIR"

    # Initialize git if not already initialized
    if [ ! -d ".git" ]; then
        echo "Initializing git repository..."
        git init
        git branch -M main
    fi

    # Create .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        echo "Creating .gitignore..."
        cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
ENV/
env/

# Jupyter Notebook
.ipynb_checkpoints

# Data files (large)
*.csv
*.xlsx
*.json
data/raw/
!data/sample_data.csv

# Models (large)
models/*.h5
models/*.pkl
!models/.gitkeep

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Environment variables
.env
EOF
    fi

    # Add all files
    echo "Adding files..."
    git add .

    # Check if there are changes to commit
    if git diff --cached --quiet; then
        echo -e "${YELLOW}No changes to commit for ${PROJECT_NAME}${NC}"
    else
        # Commit changes
        echo "Committing changes..."
        git commit -m "feat: Initial commit - ${PROJECT_NAME} portfolio project

- Complete project structure with src/, notebooks/, tests/
- Implemented data analysis and modeling
- Comprehensive documentation and README
- Added tests and requirements

Technologies: Python, Pandas, Scikit-learn, Data Visualization
Skills demonstrated: Data Science, Machine Learning, Analytics"

        # Add remote
        if ! git remote get-url origin &> /dev/null; then
            echo "Adding remote origin..."
            git remote add origin "https://github.com/${GITHUB_USER}/${PROJECT_NAME}.git"
        fi

        # Push to GitHub
        echo "Pushing to GitHub..."
        git push -u origin main --force

        echo -e "${GREEN}✓ Successfully deployed ${PROJECT_NAME}${NC}"

        # Add topics using gh CLI
        if command -v gh &> /dev/null; then
            echo "Adding repository topics..."
            gh repo edit "${GITHUB_USER}/${PROJECT_NAME}" \
                --add-topic "data-science" \
                --add-topic "machine-learning" \
                --add-topic "python" \
                --add-topic "analytics" \
                --add-topic "portfolio-project" \
                2>/dev/null || true
        fi
    fi

    cd - > /dev/null
}

# Main execution
echo "This script will deploy all portfolio projects to GitHub"
echo ""
echo "Projects to deploy:"
for PROJECT in "${PROJECTS[@]}"; do
    echo "  - ${PROJECT}"
done
echo ""
echo "Requirements:"
echo "  1. GitHub account created"
echo "  2. Git configured with your credentials"
echo "  3. GitHub CLI (gh) installed (optional but recommended)"
echo ""

# Check for GitHub CLI
if check_gh_cli; then
    echo -e "${BLUE}GitHub CLI will be used to create repositories automatically${NC}"
    AUTO_CREATE=true
else
    echo -e "${YELLOW}You'll need to create repositories manually on GitHub${NC}"
    AUTO_CREATE=false
fi

echo ""
read -p "Continue with deployment? (y/n): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 1
fi

# If gh CLI available, create all repos first
if [ "$AUTO_CREATE" = true ]; then
    echo -e "\n${BLUE}Creating GitHub repositories...${NC}"
    for PROJECT in "${PROJECTS[@]}"; do
        create_github_repo "$PROJECT"
    done
fi

# Deploy each project
echo -e "\n${BLUE}Deploying projects...${NC}"
for PROJECT in "${PROJECTS[@]}"; do
    deploy_project "$PROJECT"
    sleep 1  # Brief pause between deployments
done

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo "Next steps:"
echo "  1. Verify all repositories on GitHub"
echo "  2. Add detailed descriptions and topics to each repo"
echo "  3. Enable GitHub Pages if needed for dashboards"
echo "  4. Update portfolio website with repository links"
echo "  5. Add README screenshots and badges"
echo ""
echo "Your repositories:"
for PROJECT in "${PROJECTS[@]}"; do
    echo "  🔗 https://github.com/${GITHUB_USER}/${PROJECT}"
done
echo ""
echo -e "${GREEN}Happy showcasing your work! 🚀${NC}"
