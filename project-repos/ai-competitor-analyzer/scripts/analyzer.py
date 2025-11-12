"""
AI Competitor Intelligence Analyzer
Automates competitor website analysis using Gemini AI

Usage:
    python analyzer.py --competitors competitor1.com competitor2.com

Requirements:
    pip install google-generativeai beautifulsoup4 requests pandas

Environment:
    export GEMINI_API_KEY='your-key-here'  (or use .env file)
"""

import os
import json
import requests
from bs4 import BeautifulSoup
from datetime import datetime
import google.generativeai as genai

# Configure Gemini
GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
if not GEMINI_API_KEY:
    try:
        from dotenv import load_dotenv
        load_dotenv()
        GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
    except:
        pass

genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-1.5-flash')

def scrape_website(url):
    """Extract text content from competitor website"""
    try:
        if not url.startswith('http'):
            url = f'https://{url}'
        
        response = requests.get(url, timeout=10, headers={
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        soup = BeautifulSoup(response.content, 'html.parser')
        
        for tag in soup(['script', 'style', 'nav', 'footer', 'header']):
            tag.decompose()
        
        text = soup.get_text(separator=' ', strip=True)
        return text[:8000]
    
    except Exception as e:
        return f"Error scraping {url}: {str(e)}"

def analyze_competitor(url, content):
    """Use Gemini to extract competitive intelligence"""
    
    prompt = f"""Analyze this competitor website content and extract key business intelligence.

Website: {url}
Content: {content}

Provide analysis in JSON format with these fields:
1. value_proposition: Main message (2-3 sentences)
2. target_audience: Who they serve
3. pricing_strategy: Pricing model if available
4. key_differentiators: What makes them unique (3-5 points)
5. content_themes: Main topics (3-5 themes)
6. competitive_positioning: How they position vs competitors

Return only valid JSON."""
    
    try:
        response = model.generate_content(prompt)
        analysis_text = response.text
        
        # Extract JSON from response
        start = analysis_text.find('{')
        end = analysis_text.rfind('}') + 1
        if start >= 0 and end > start:
            analysis_json = json.loads(analysis_text[start:end])
        else:
            analysis_json = json.loads(analysis_text)
        
        analysis_json['analyzed_url'] = url
        analysis_json['analyzed_date'] = datetime.now().isoformat()
        return analysis_json
    
    except Exception as e:
        return {"error": str(e), "url": url}

def generate_executive_summary(all_analyses):
    """Generate comparative summary across competitors"""
    
    prompt = f"""Based on these competitor analyses, create an executive summary highlighting:

1. Market positioning gaps (opportunities we can exploit)
2. Pricing opportunities
3. Content strategy insights
4. Competitive threats

Competitor Data:
{json.dumps(all_analyses, indent=2)}

Write a concise 3-paragraph executive summary."""
    
    try:
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"Error generating summary: {str(e)}"

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Analyze competitor websites using AI')
    parser.add_argument('--competitors', nargs='+', required=True)
    parser.add_argument('--output', default='outputs/analysis_results.json')
    args = parser.parse_args()
    
    print(f"Analyzing {len(args.competitors)} competitors...\n")
    
    all_analyses = []
    for url in args.competitors:
        print(f"Processing: {url}")
        print("  → Scraping website...")
        content = scrape_website(url)
        
        if content.startswith("Error"):
            print(f"  ✗ {content}")
            continue
        
        print("  → Running AI analysis...")
        analysis = analyze_competitor(url, content)
        
        if "error" in analysis:
            print(f"  ✗ Analysis failed: {analysis['error']}")
        else:
            all_analyses.append(analysis)
            print(f"  ✓ Complete\n")
    
    print("Generating executive summary...")
    summary = generate_executive_summary(all_analyses)
    
    results = {
        "analysis_date": datetime.now().isoformat(),
        "competitors_analyzed": len(all_analyses),
        "individual_analyses": all_analyses,
        "executive_summary": summary
    }
    
    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    with open(args.output, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"\n✓ Analysis complete!")
    print(f"Results saved to: {args.output}")
    print(f"\nExecutive Summary:\n{summary}")

if __name__ == "__main__":
    main()
