"""
AI Marketing Content Generator
Usage: python content_generator.py --topic "Marketing Strategy" --keywords "SEO,analytics"
Requirements: pip install google-generativeai python-dotenv
"""

import os, json, argparse
from datetime import datetime
import google.generativeai as genai

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

def generate_blog_post(topic, keywords):
    prompt = f"""Write a 1200-word SEO-optimized blog post on: {topic}

Target Keywords: {keywords}

Include:
- Compelling H1 title with keyword
- Introduction with hook (150 words)
- 4-5 H2 sections
- Statistics and examples
- Actionable conclusion
- Meta description (155 characters)

Use professional yet approachable tone. UK English."""
    
    response = model.generate_content(prompt)
    return response.text

def generate_social_posts(blog_content):
    prompt = f"""Repurpose this blog post into social media content:

{blog_content[:3000]}

Generate:
1. 5 LinkedIn posts (varying angles)
2. 10 Twitter/X posts (under 280 chars each)
3. 3 Instagram captions
Format as JSON."""
    
    response = model.generate_content(prompt)
    return response.text

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--topic', required=True)
    parser.add_argument('--keywords', required=True)
    parser.add_argument('--output', default='outputs/generated_content.json')
    args = parser.parse_args()
    
    print(f"Generating content for: {args.topic}")
    blog = generate_blog_post(args.topic, args.keywords)
    print("✓ Blog post generated")
    
    social = generate_social_posts(blog)
    print("✓ Social posts generated")
    
    results = {
        "topic": args.topic,
        "generated_date": datetime.now().isoformat(),
        "blog_post": blog,
        "social_media": social
    }
    
    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    with open(args.output, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"✓ Content saved to: {args.output}")

if __name__ == "__main__":
    main()
