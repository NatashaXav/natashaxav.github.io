# GitHub Deployment Script for Windows PowerShell
# Usage: .\deploy-to-github.ps1 YOUR_GITHUB_TOKEN

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubToken
)

$ErrorActionPreference = "Stop"

# Configuration
$GitHubUser = "natashaxavier"
$Projects = @(
    "social-media-sentiment",
    "customer-segmentation",
    "hr-attrition-prediction",
    "marketing-roi-dashboard",
    "employee-engagement-analysis"
)

Write-Host "========================================" -ForegroundColor Green
Write-Host "GitHub Portfolio Deployment" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

# Function to create GitHub repository
function Create-GitHubRepo {
    param([string]$ProjectName)

    Write-Host "`nCreating repository: $ProjectName" -ForegroundColor Blue

    $body = @{
        name = $ProjectName
        description = "Data analytics portfolio project: $ProjectName"
        private = $false
        auto_init = $false
    } | ConvertTo-Json

    $headers = @{
        Authorization = "token $GitHubToken"
        Accept = "application/vnd.github.v3+json"
    }

    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
            -Method Post `
            -Headers $headers `
            -Body $body `
            -ContentType "application/json"

        Write-Host "✓ Repository created" -ForegroundColor Green
        return $true
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "Repository already exists" -ForegroundColor Yellow
            return $true
        }
        else {
            Write-Host "✗ Failed to create repository" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
            return $false
        }
    }
}

# Function to add topics to repository
function Add-RepoTopics {
    param([string]$ProjectName)

    Write-Host "Adding topics..." -ForegroundColor Gray

    $body = @{
        names = @(
            "data-analysis",
            "excel",
            "portfolio",
            "marketing-analytics",
            "hr-analytics",
            "business-intelligence"
        )
    } | ConvertTo-Json

    $headers = @{
        Authorization = "token $GitHubToken"
        Accept = "application/vnd.github.v3+json"
    }

    try {
        Invoke-RestMethod -Uri "https://api.github.com/repos/$GitHubUser/$ProjectName/topics" `
            -Method Put `
            -Headers $headers `
            -Body $body `
            -ContentType "application/json" | Out-Null

        Write-Host "✓ Topics added" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠ Could not add topics" -ForegroundColor Yellow
    }
}

# Function to deploy a project
function Deploy-Project {
    param([string]$ProjectName)

    $ProjectDir = "project-repos\$ProjectName"

    Write-Host "`n========================================" -ForegroundColor Yellow
    Write-Host "Deploying: $ProjectName" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow

    if (!(Test-Path $ProjectDir)) {
        Write-Host "Error: Directory $ProjectDir not found" -ForegroundColor Red
        return $false
    }

    Push-Location $ProjectDir

    try {
        # Remove empty directories
        Get-ChildItem -Directory -Recurse |
            Where-Object { (Get-ChildItem $_.FullName -Force | Measure-Object).Count -eq 0 } |
            Remove-Item -Force

        # Initialize git if needed
        if (!(Test-Path ".git")) {
            Write-Host "Initializing git repository..." -ForegroundColor Gray
            git init
            git branch -M main
        }

        # Create .gitignore if missing
        if (!(Test-Path ".gitignore")) {
            @"
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
"@ | Out-File -FilePath ".gitignore" -Encoding utf8
        }

        # Add all files
        git add .

        # Check if there are changes
        $status = git status --porcelain

        if (!$status) {
            Write-Host "No changes to commit" -ForegroundColor Yellow
        }
        else {
            # Commit
            Write-Host "Committing changes..." -ForegroundColor Gray
            $commitMsg = @"
Portfolio project: $ProjectName

Complete analysis with Excel workbooks, visualizations, and business insights.

Skills: Data Analysis, Excel, Business Strategy, Analytics

🤖 Portfolio Project
"@
            git commit -m $commitMsg

            # Set remote with token
            $remoteUrl = "https://${GitHubToken}@github.com/${GitHubUser}/${ProjectName}.git"

            try {
                git remote get-url origin | Out-Null
                git remote set-url origin $remoteUrl
            }
            catch {
                git remote add origin $remoteUrl
            }

            # Push
            Write-Host "Pushing to GitHub..." -ForegroundColor Gray
            git push -u origin main --force

            Write-Host "✓ Successfully deployed" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "✗ Deployment failed" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Pop-Location
        return $false
    }

    Pop-Location
    return $true
}

# Main execution
Write-Host "This will deploy all 5 portfolio projects to GitHub`n"
Write-Host "Projects:"
foreach ($project in $Projects) {
    Write-Host "  - $project"
}
Write-Host ""

$confirmation = Read-Host "Continue? (y/n)"
if ($confirmation -ne 'y') {
    Write-Host "Cancelled" -ForegroundColor Yellow
    exit
}

# Create all repositories
Write-Host "`nCreating GitHub repositories..." -ForegroundColor Blue
foreach ($project in $Projects) {
    Create-GitHubRepo $project
    Start-Sleep -Seconds 1
}

# Deploy all projects
Write-Host "`nDeploying projects..." -ForegroundColor Blue
foreach ($project in $Projects) {
    Deploy-Project $project
    Add-RepoTopics $project
    Start-Sleep -Seconds 1
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✓ Deployment Complete!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "Your repositories:"
foreach ($project in $Projects) {
    Write-Host "  🔗 https://github.com/${GitHubUser}/${project}"
}
Write-Host "`nSuccess! 🚀`n" -ForegroundColor Green
