"""
Simple Data Preparation Script for Sentiment Analysis
======================================================

What this script does:
- Loads the Sentiment140 dataset
- Cleans the data (removes duplicates, handles missing values)
- Samples 10,000 tweets for analysis
- Adds human-readable sentiment labels
- Exports to a clean CSV for Excel analysis

This is OPTIONAL - you can do all of this in Excel if you prefer!

Author: Natasha Xavier
Date: January 2025
Level: Absolute Beginner Friendly
"""

# Import libraries (install with: pip install pandas)
import pandas as pd
import os

# ============================================================================
# STEP 1: LOAD THE DATASET
# ============================================================================

print("📊 Starting data preparation...")
print("=" * 50)

# File path - change this if your data is in a different location
DATA_PATH = "../data/sentiment140.csv"

# Check if file exists
if not os.path.exists(DATA_PATH):
    print(f"❌ ERROR: File not found at {DATA_PATH}")
    print("Please download the dataset first!")
    print("See: DATASET_DOWNLOAD_GUIDE.md")
    exit()

print(f"✅ Found dataset at: {DATA_PATH}")

# Load the data
# The Sentiment140 dataset has these columns (no header in the file):
# 0: sentiment (0 = negative, 4 = positive)
# 1: tweet ID
# 2: date
# 3: query (not used)
# 4: user
# 5: tweet text

print("Loading data... (this may take a minute)")

# Column names (dataset doesn't have a header row)
columns = ['sentiment', 'tweet_id', 'date', 'query', 'user', 'text']

# Load the CSV
df = pd.read_csv(
    DATA_PATH,
    encoding='latin-1',  # Special encoding for this dataset
    names=columns,       # Add column names
    header=None          # No header row in file
)

print(f"✅ Loaded {len(df):,} tweets")

# ============================================================================
# STEP 2: CLEAN THE DATA
# ============================================================================

print("\n🧹 Cleaning data...")

# Keep only the columns we need
df = df[['sentiment', 'date', 'text']]

# Remove duplicates (same tweet text)
original_count = len(df)
df = df.drop_duplicates(subset=['text'])
duplicates_removed = original_count - len(df)
print(f"✅ Removed {duplicates_removed:,} duplicate tweets")

# Remove any rows with missing text
df = df.dropna(subset=['text'])
print(f"✅ Removed rows with missing data")

# ============================================================================
# STEP 3: ADD HUMAN-READABLE LABELS
# ============================================================================

print("\n🏷️ Adding sentiment labels...")

# The dataset uses 0 = negative, 4 = positive
# Let's add a clear text label

def label_sentiment(score):
    """Convert numeric sentiment to text label"""
    if score == 0:
        return 'Negative'
    elif score == 4:
        return 'Positive'
    else:
        return 'Neutral'

df['sentiment_label'] = df['sentiment'].apply(label_sentiment)

print("✅ Added sentiment labels")

# ============================================================================
# STEP 4: SAMPLE DATA FOR ANALYSIS
# ============================================================================

print("\n📉 Sampling 10,000 tweets for analysis...")

# Take a random sample (makes Excel analysis faster)
# If you want more data, change 10000 to a higher number

SAMPLE_SIZE = 10000

if len(df) > SAMPLE_SIZE:
    df_sample = df.sample(n=SAMPLE_SIZE, random_state=42)
    print(f"✅ Selected random sample of {SAMPLE_SIZE:,} tweets")
else:
    df_sample = df.copy()
    print(f"✅ Using all {len(df):,} tweets (dataset smaller than sample size)")

# ============================================================================
# STEP 5: EXPORT FOR EXCEL
# ============================================================================

print("\n💾 Exporting clean data...")

# Output file path
OUTPUT_PATH = "../data/sentiment_clean.csv"

# Save to CSV
df_sample.to_csv(OUTPUT_PATH, index=False)

print(f"✅ Exported to: {OUTPUT_PATH}")

# ============================================================================
# STEP 6: SHOW SUMMARY STATISTICS
# ============================================================================

print("\n📊 Summary Statistics:")
print("=" * 50)

# Count by sentiment
sentiment_counts = df_sample['sentiment_label'].value_counts()
sentiment_percentages = df_sample['sentiment_label'].value_counts(normalize=True) * 100

print("\nSentiment Distribution:")
for label in sentiment_counts.index:
    count = sentiment_counts[label]
    pct = sentiment_percentages[label]
    print(f"  {label:10s}: {count:6,} tweets ({pct:5.1f}%)")

print(f"\nTotal tweets in sample: {len(df_sample):,}")

# ============================================================================
# DONE!
# ============================================================================

print("\n" + "=" * 50)
print("✅ DATA PREPARATION COMPLETE!")
print("=" * 50)

print("\nNext steps:")
print("1. Open Excel")
print("2. Import the file: data/sentiment_clean.csv")
print("3. Follow the Excel Analysis Guide in README.md")
print("4. Create your insights and visualizations!")

print("\n💡 Remember: This script is optional!")
print("   You can import the original CSV directly into Excel")
print("   and do all the cleaning there if you prefer.\n")

# ============================================================================
# BONUS: SAVE A SMALL SAMPLE FOR QUICK TESTING
# ============================================================================

print("📝 Creating a tiny sample for quick testing...")

# Save first 100 tweets for quick Excel testing
tiny_sample = df_sample.head(100)
tiny_sample.to_csv("../data/sentiment_tiny_sample.csv", index=False)

print("✅ Saved 100-tweet sample to: data/sentiment_tiny_sample.csv")
print("   (Use this for quick Excel testing before analyzing all 10k tweets)\n")

# ============================================================================
# END OF SCRIPT
# ============================================================================

"""
TROUBLESHOOTING:

1. "ModuleNotFoundError: No module named 'pandas'"
   Solution: Install pandas with: pip install pandas

2. "FileNotFoundError"
   Solution: Make sure you downloaded the dataset first
   See: DATASET_DOWNLOAD_GUIDE.md

3. "UnicodeDecodeError"
   Solution: The script uses encoding='latin-1' which should work
   If not, try encoding='utf-8' or encoding='ISO-8859-1'

4. Script runs but creates empty file
   Solution: Check that the input CSV isn't empty
   Try printing df.head() to see if data loaded

WANT TO MODIFY THIS SCRIPT?

- Change SAMPLE_SIZE to get more/fewer tweets
- Add more cleaning steps (remove URLs, handle emojis, etc.)
- Filter for specific keywords or date ranges
- Add your own columns

This is YOUR script - customize it as needed!

Questions? Email: natashaxavier512@gmail.com
"""
