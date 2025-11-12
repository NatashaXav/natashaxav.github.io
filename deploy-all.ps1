#!/usr/bin/env pwsh
# Deployment script for all portfolio projects
# Usage: ./deploy-all.ps1 YOUR_GITHUB_TOKEN

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubToken
)

$GitHubUser = "NatashaXav"

# Define all projects
$Projects = @{
    "social-media-sentiment" = @{
        path = "project-repos/social-media-sentiment"
        description = "Social Media Sentiment Analysis - NLP project analyzing 10K tweets"
        topics = @("nlp", "sentiment-analysis", "python", "data-analytics")
    }
    "customer-segmentation" = @{
        path = "project-repos/customer-segmentation"
        description = "Customer Segmentation using RFM Analysis - £685K revenue analysis"
        topics = @("rfm-analysis", "customer-segmentation", "marketing-analytics", "python")
    }
    "ai-competitor-analyzer" = @{
        path = "project-repos/ai-competitor-analyzer"
        description = "AI Competitor Intelligence Analyzer - Automated monitoring using Gemini AI"
        topics = @("ai", "gemini-api", "competitive-intelligence", "automation")
    }
    "marketing-content-generator" = @{
        path = "project-repos/marketing-content-generator"
        description = "AI Marketing Content Generator - Blog & social media automation"
        topics = @("ai", "content-generation", "marketing-automation", "gemini-api")
    }
    "hr-resume-screener" = @{
        path = "project-repos/hr-resume-screener"
        description = "AI HR Resume Screener - Automated candidate screening with 90% time reduction"
        topics = @("ai", "hr-tech", "recruitment", "gemini-api")
    }
    "employee-engagement-ai" = @{
        path = "project-repos/employee-engagement-ai"
        description = "AI Employee Engagement Analyzer - Survey feedback analysis"
        topics = @("ai", "hr-analytics", "sentiment-analysis", "gemini-api")
    }
    "portfolio-website" = @{
        path = "project-repos/portfolio-website"
        description = "Professional Portfolio Website - Showcasing data analytics & AI projects"
        topics = @("portfolio", "website", "html-css-javascript")
        private = $true
    }
}

function Create-GitHubRepo {
    param(
        [string]$Name,
        [string]$Description,
        [array]$Topics,
        [bool]$Private = $false
    )
    
    Write-Host "`n📦 Creating repository: $Name" -ForegroundColor Cyan
    
    $body = @{
        name = $Name
        description = $Description
        private = $Private
        auto_init = $false
        has_issues = $true
        has_wiki = $false
    } | ConvertTo-Json
    
    $headers = @{
        Authorization = "Bearer $GitHubToken"
        Accept = "application/vnd.github.v3+json"
    }
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
            -Method Post -Headers $headers -Body $body -ContentType "application/json"
        
        # Add topics
        if ($Topics -and $Topics.Count -gt 0) {
            $topicsBody = @{ names = $Topics } | ConvertTo-Json
            Invoke-RestMethod -Uri "https://api.github.com/repos/$GitHubUser/$Name/topics" `
                -Method Put -Headers @{
                    Authorization = "Bearer $GitHubToken"
                    Accept = "application/vnd.github.mercy-preview+json"
                } -Body $topicsBody -ContentType "application/json" | Out-Null
        }
        
        Write-Host "✓ Repository created successfully" -ForegroundColor Green
        return $true
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "⚠ Repository already exists, will update instead" -ForegroundColor Yellow
            return $true
        }
        Write-Host "✗ Failed: $_" -ForegroundColor Red
        return $false
    }
}

# Main deployment loop
Write-Host "🚀 Portfolio Deployment Starting..." -ForegroundColor Cyan
Write-Host "=" * 60

$successCount = 0
$failCount = 0

foreach ($project in $Projects.GetEnumerator()) {
    $name = $project.Key
    $config = $project.Value
    $projectPath = $config.path
    
    Write-Host "`n📂 Processing: $name" -ForegroundColor Yellow
    
    if (-not (Test-Path $projectPath)) {
        Write-Host "✗ Path not found: $projectPath" -ForegroundColor Red
        $failCount++
        continue
    }
    
    # Create GitHub repo
    $created = Create-GitHubRepo -Name $name -Description $config.description `
        -Topics $config.topics -Private $config.private
    
    if (-not $created) {
        $failCount++
        continue
    }
    
    # Initialize and push
    try {
        Push-Location $projectPath
        
        # Initialize git if needed
        if (-not (Test-Path ".git")) {
            git init | Out-Null
        }
        
        # Configure remote
        $remoteUrl = "https://${GitHubToken}@github.com/${GitHubUser}/${name}.git"
        git remote remove origin 2>$null
        git remote add origin $remoteUrl 2>$null
        
        # Add and commit
        git add . | Out-Null
        $commitMsg = "Initial commit: $($config.description)`n`n🤖 Generated with Claude Code"
        git commit -m $commitMsg 2>$null | Out-Null
        
        # Push
        Write-Host "  → Pushing to GitHub..." -ForegroundColor Cyan
        git branch -M main | Out-Null
        git push -u origin main --force 2>$null | Out-Null
        
        Write-Host "✓ $name deployed successfully!" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "✗ Failed to push: $_" -ForegroundColor Red
        $failCount++
    }
    finally {
        Pop-Location
    }
}

Write-Host "`n" + ("=" * 60)
Write-Host "`n📊 Deployment Summary:" -ForegroundColor Cyan
Write-Host "  ✓ Successful: $successCount" -ForegroundColor Green
Write-Host "  ✗ Failed: $failCount" -ForegroundColor Red

if ($successCount -eq 7) {
    Write-Host "`n🎉 All projects deployed successfully!" -ForegroundColor Green
    Write-Host "`nView your portfolio at:"
    Write-Host "  https://github.com/$GitHubUser" -ForegroundColor Cyan
} else {
    Write-Host "`n⚠ Some deployments failed. Check errors above." -ForegroundColor Yellow
}
