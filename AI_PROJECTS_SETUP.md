# API Key Setup

All AI projects use Google Gemini API (free tier available).

## Quick Setup:

1. Get your API key: https://makersuite.google.com/app/apikey
2. Copy `.env.example` to `.env`
3. Add your API key to `.env`

The `.env` file is gitignored for security.

## Testing:

```bash
# Install dependencies
pip3 install -r project-repos/ai-competitor-analyzer/requirements.txt

# Test the API
python3 -c "
import os
from dotenv import load_dotenv
import google.generativeai as genai

load_dotenv()
genai.configure(api_key=os.getenv('GEMINI_API_KEY'))
model = genai.GenerativeModel('gemini-1.5-flash')
response = model.generate_content('Say hello in 10 words')
print(response.text)
"
```

## Running Projects:

```bash
# Competitor Analysis
cd project-repos/ai-competitor-analyzer
python3 scripts/analyzer.py --competitors example.com

# Content Generation  
cd project-repos/marketing-content-generator
python3 scripts/content_generator.py --topic "Marketing Tips" --keywords "SEO,analytics"

# Resume Screening
cd project-repos/hr-resume-screener
python3 scripts/resume_screener.py --job-description jd.txt --resumes ./resumes/

# Engagement Analysis
cd project-repos/employee-engagement-ai
python3 scripts/engagement_analyzer.py --survey-data survey.csv --comment-column "Feedback"
```

All scripts save results to `outputs/` directory.
