"""
AI-Powered HR Resume Screener
Scores and ranks resumes against a job description using GPT-4.

Usage:
    python resume_screener.py --job-description "path/to/jd.txt" --resumes "path/to/resumes_dir/"

Requirements:
    pip install openai python-pdf PyMuPDF python-docx

Environment:
    export OPENAI_API_KEY='your-key-here'
"""

import os
import json
import argparse
import fitz  # PyMuPDF
import docx
from openai import OpenAI
from datetime import datetime

client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

def read_text_file(filepath):
    """Reads content from a plain text file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

def parse_resume(filepath):
    """Extracts text from PDF or DOCX files."""
    try:
        if filepath.endswith('.pdf'):
            with fitz.open(filepath) as doc:
                text = "".join(page.get_text() for page in doc)
            return text
        elif filepath.endswith('.docx'):
            doc = docx.Document(filepath)
            return "\n".join([para.text for para in doc.paragraphs])
        else:
            return f"Unsupported file type: {filepath}"
    except Exception as e:
        return f"Error parsing {filepath}: {str(e)}"

def screen_resume(job_description, resume_text, resume_filename):
    """Uses GPT-4 to score and analyze a resume."""
    prompt = f"""
    You are an expert HR recruiter for the UK market, specializing in marketing and HR roles.
    Analyze the following resume against the provided job description.

    Your task is to provide a quantitative score and a qualitative assessment.

    **Job Description:**
    ---
    {job_description}
    ---

    **Resume Content:**
    ---
    {resume_text}
    ---

    **Instructions:**
    1.  **Score:** Provide a "fit_score" from 0 to 100, where 100 is a perfect match. The score should be based on these weighted criteria:
        -   Relevant Skills & Technologies (40%)
        -   Years and Quality of Work Experience (30%)
        -   Education & Relevant Certifications (15%)
        -   Presence of Quantifiable Achievements (e.g., "increased ROI by 20%") (15%)
    2.  **Summary:** Write a 2-3 sentence "summary" of the candidate's profile as it relates to the role.
    3.  **Skills Analysis:** Create a list of "extracted_skills" found in the resume that match the job description, and a list of "missing_skills".
    4.  **Overall Assessment:** Provide a brief "overall_assessment" explaining the reasoning behind your score.

    Return your analysis as a single, valid JSON object. Do not include any text outside of the JSON.
    The JSON object must contain these keys: `fit_score`, `summary`, `extracted_skills`, `missing_skills`, `overall_assessment`.
    """
    try:
        response = client.chat.completions.create(
            model="gpt-4-turbo-preview",
            messages=[
                {"role": "system", "content": "You are an AI-powered recruitment assistant providing structured JSON output."},
                {"role": "user", "content": prompt}
            ],
            response_format={"type": "json_object"},
            temperature=0.2,
            max_tokens=1500
        )
        analysis = json.loads(response.choices[0].message.content)
        analysis['resume_filename'] = resume_filename
        analysis['analysis_date'] = datetime.now().isoformat()
        return analysis
    except Exception as e:
        return {"error": str(e), "resume_filename": resume_filename}

def main():
    """Main execution flow."""
    parser = argparse.ArgumentParser(description='AI-powered resume screening tool.')
    parser.add_argument('--job-description', required=True, help='Path to the job description file (.txt).')
    parser.add_argument('--resumes', required=True, help='Path to the directory containing resumes (PDFs or DOCXs).')
    parser.add_argument('--output', default='outputs/sample_screening_results.json', help='Output file path for the results.')
    args = parser.parse_args()

    print("--- AI Resume Screener Initializing ---")

    # Read job description
    try:
        job_description = read_text_file(args.job_description)
        print(f"✓ Job description loaded from: {args.job_description}")
    except Exception as e:
        print(f"✗ Error: Could not read job description file. {e}")
        return

    # Find resumes
    resume_files = [f for f in os.listdir(args.resumes) if f.endswith(('.pdf', '.docx'))]
    if not resume_files:
        print(f"✗ Error: No resumes found in '{args.resumes}'.")
        return

    print(f"✓ Found {len(resume_files)} resumes to screen.\n")

    all_screenings = []
    for filename in resume_files:
        filepath = os.path.join(args.resumes, filename)
        print(f"Processing: {filename}")

        # Step 1: Parse resume
        print("  → Parsing resume content...")
        resume_text = parse_resume(filepath)
        if "Error" in resume_text or "Unsupported" in resume_text:
            print(f"  ✗ {resume_text}")
            continue

        # Step 2: AI screening
        print("  → Running AI analysis...")
        screening_result = screen_resume(job_description, resume_text, filename)
        if "error" in screening_result:
            print(f"  ✗ Analysis failed: {screening_result['error']}")
        else:
            all_screenings.append(screening_result)
            print(f"  ✓ Score: {screening_result.get('fit_score', 'N/A')}")

    # Sort candidates by score
    all_screenings.sort(key=lambda x: x.get('fit_score', 0), reverse=True)

    # Prepare final output
    final_results = {
        "job_description_file": args.job_description,
        "screening_date": datetime.now().isoformat(),
        "total_candidates_screened": len(all_screenings),
        "candidate_rankings": all_screenings
    }

    # Save results
    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    with open(args.output, 'w') as f:
        json.dump(final_results, f, indent=2)

    print(f"\n--- Screening Complete ---")
    print(f"✓ Results for {len(all_screenings)} candidates saved to: {args.output}")

if __name__ == "__main__":
    main()
