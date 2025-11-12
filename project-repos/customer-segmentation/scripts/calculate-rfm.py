"""
Simple RFM Calculator for Customer Segmentation
===============================================

What this script does:
- Loads e-commerce transaction data
- Calculates Recency, Frequency, and Monetary metrics for each customer
- Assigns RFM scores (1-5 scale)
- Creates customer segments
- Exports results to Excel-friendly CSV

This is OPTIONAL - you can do all calculations in Excel!

Author: Natasha Xavier
Date: January 2025
Level: Beginner Friendly
"""

import pandas as pd
from datetime import datetime
import os

print("🎯 RFM Customer Segmentation Calculator")
print("=" * 50)

# ============================================================================
# STEP 1: LOAD DATA
# ============================================================================

DATA_PATH = "../data/ecommerce-data.csv"

if not os.path.exists(DATA_PATH):
    print(f"❌ ERROR: File not found at {DATA_PATH}")
    print("Please download the dataset first!")
    print("See: DATASET_DOWNLOAD_GUIDE.md")
    exit()

print(f"✅ Loading data from: {DATA_PATH}")

# Load the e-commerce dataset
df = pd.read_csv(DATA_PATH, encoding='latin-1')

print(f"✅ Loaded {len(df):,} transactions")

# ============================================================================
# STEP 2: CLEAN DATA
# ============================================================================

print("\n🧹 Cleaning data...")

# Remove transactions without CustomerID
df = df[df['CustomerID'].notna()]

# Remove returns (negative quantities)
df = df[df['Quantity'] > 0]

# Remove invalid prices
df = df[df['UnitPrice'] > 0]

# Calculate total amount
df['TotalAmount'] = df['Quantity'] * df['UnitPrice']

# Convert date to datetime
df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])

print(f"✅ Clean dataset: {len(df):,} valid transactions")
print(f"✅ Unique customers: {df['CustomerID'].nunique():,}")

# ============================================================================
# STEP 3: CALCULATE RFM METRICS
# ============================================================================

print("\n📊 Calculating RFM metrics...")

# Reference date (latest date in dataset + 1 day)
reference_date = df['InvoiceDate'].max() + pd.Timedelta(days=1)

# Calculate RFM for each customer
rfm = df.groupby('CustomerID').agg({
    'InvoiceDate': lambda x: (reference_date - x.max()).days,  # Recency
    'InvoiceNo': 'count',                                       # Frequency
    'TotalAmount': 'sum'                                        # Monetary
}).reset_index()

# Rename columns
rfm.columns = ['CustomerID', 'Recency', 'Frequency', 'Monetary']

print(f"✅ Calculated RFM for {len(rfm):,} customers")

# ============================================================================
# STEP 4: ASSIGN RFM SCORES (1-5 scale)
# ============================================================================

print("\n🏷️ Assigning RFM scores...")

# Score Recency (1-5, where 5 is most recent)
rfm['R_Score'] = pd.cut(rfm['Recency'], bins=5, labels=[5,4,3,2,1])

# Score Frequency (1-5, where 5 is most frequent)
rfm['F_Score'] = pd.qcut(rfm['Frequency'], q=5, labels=[1,2,3,4,5], duplicates='drop')

# Score Monetary (1-5, where 5 is highest value)
rfm['M_Score'] = pd.qcut(rfm['Monetary'], q=5, labels=[1,2,3,4,5], duplicates='drop')

# Convert scores to integers
rfm['R_Score'] = rfm['R_Score'].astype(int)
rfm['F_Score'] = rfm['F_Score'].astype(int)
rfm['M_Score'] = rfm['M_Score'].astype(int)

# Create combined RFM score
rfm['RFM_Score'] = rfm['R_Score'].astype(str) + rfm['F_Score'].astype(str) + rfm['M_Score'].astype(str)

print("✅ RFM scores assigned")

# ============================================================================
# STEP 5: CREATE CUSTOMER SEGMENTS
# ============================================================================

print("\n🎯 Creating customer segments...")

def assign_segment(row):
    """Assign customer to segment based on RFM scores"""
    r, f, m = row['R_Score'], row['F_Score'], row['M_Score']

    # Champions: Best customers
    if r == 5 and f == 5 and m == 5:
        return 'Champions'

    # Loyal: High frequency and monetary
    elif r >= 4 and f >= 4 and m >= 4:
        return 'Loyal Customers'

    # Big Spenders: High monetary but low frequency
    elif r >= 4 and f <= 3 and m == 5:
        return 'Big Spenders'

    # Promising: Recent customers with potential
    elif r >= 4 and f <= 2 and m <= 3:
        return 'Promising'

    # New Customers: Very recent, low frequency
    elif r == 5 and f == 1:
        return 'New Customers'

    # At Risk: Were loyal but haven't bought recently
    elif r <= 2 and f >= 4 and m >= 4:
        return 'At Risk'

    # About to Sleep: Below average recency and frequency
    elif r == 2 and f <= 3 and m <= 3:
        return 'About to Sleep'

    # Need Attention: Below average across the board
    elif r == 3 and f <= 2 and m <= 3:
        return 'Need Attention'

    # Can't Lose Them: Highest value but haven't bought recently
    elif r == 1 and f == 5 and m == 5:
        return 'Can\'t Lose Them'

    # Hibernating: Lost customers with decent history
    elif r == 1 and f >= 2 and m >= 3:
        return 'Hibernating'

    # Lost: Haven't purchased in long time, low value
    else:
        return 'Lost'

rfm['Segment'] = rfm.apply(assign_segment, axis=1)

print("✅ Segments assigned")

# ============================================================================
# STEP 6: SHOW SUMMARY
# ============================================================================

print("\n📈 Segmentation Summary:")
print("=" * 50)

segment_summary = rfm.groupby('Segment').agg({
    'CustomerID': 'count',
    'Monetary': ['sum', 'mean']
}).round(2)

segment_summary.columns = ['Customer_Count', 'Total_Revenue', 'Avg_Value']
segment_summary = segment_summary.sort_values('Total_Revenue', ascending=False)

print(segment_summary)

print(f"\nTotal Customers: {len(rfm):,}")
print(f"Total Revenue: ${rfm['Monetary'].sum():,.2f}")

# ============================================================================
# STEP 7: EXPORT RESULTS
# ============================================================================

print("\n💾 Exporting results...")

OUTPUT_PATH = "../data/rfm_customer_segments.csv"

rfm.to_csv(OUTPUT_PATH, index=False)

print(f"✅ Exported to: {OUTPUT_PATH}")

# ============================================================================
# DONE!
# ============================================================================

print("\n" + "=" * 50)
print("✅ RFM ANALYSIS COMPLETE!")
print("=" * 50)

print("\nNext steps:")
print("1. Open the exported CSV in Excel")
print("2. Create pivot tables to analyze segments")
print("3. Develop targeted strategies for each segment")
print("4. Implement campaigns and measure results!")

print("\n💡 Remember: This script is optional!")
print("   You can do all of this directly in Excel.\n")
