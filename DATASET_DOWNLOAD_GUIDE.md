# Dataset Download Guide
## Step-by-Step Instructions for All 5 Projects

**IMPORTANT**: You'll need a free Kaggle account. Sign up at https://www.kaggle.com/

---

## 🔑 One-Time Kaggle Setup

### Step 1: Create Kaggle Account
1. Go to https://www.kaggle.com/
2. Click "Register" (top right)
3. Sign up with Google/email
4. Verify your email

### Step 2: Accept Competition Rules (if needed)
- Some datasets require accepting terms
- Just click "I Understand and Accept" when prompted

---

## 📊 Project 1: Social Media Sentiment Analysis

### Dataset: Sentiment140 (1.6 million tweets)
**Download Link**: https://www.kaggle.com/datasets/kazanova/sentiment140

### Steps:
1. Go to the link above
2. Click blue "Download" button (top right)
3. Save `training.1600000.processed.noemoticon.csv` to your computer
4. Move file to: `/Users/rj/Claude_code/natash/project-repos/social-media-sentiment/data/`
5. Rename to: `sentiment140.csv`

### What's in this dataset:
- 1.6 million tweets
- Columns: sentiment (0=negative, 4=positive), tweet text, user, date
- Perfect for brand monitoring and sentiment tracking

---

## 📊 Project 2: Customer Segmentation (RFM Analysis)

### Dataset: E-Commerce Data (500k transactions)
**Download Link**: https://www.kaggle.com/datasets/carrie1/ecommerce-data

### Steps:
1. Go to the link above
2. Click "Download" button
3. Save `data.csv` to your computer
4. Move file to: `/Users/rj/Claude_code/natash/project-repos/customer-segmentation/data/`
5. Rename to: `ecommerce-data.csv`

### What's in this dataset:
- UK-based online retail transactions (2010-2011)
- Columns: InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
- Perfect for RFM analysis and customer segmentation

---

## 📊 Project 3: HR Attrition Prediction

### Dataset: IBM HR Analytics Employee Attrition
**Download Link**: https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset

### Steps:
1. Go to the link above
2. Click "Download" button
3. Save `WA_Fn-UseC_-HR-Employee-Attrition.csv` to your computer
4. Move file to: `/Users/rj/Claude_code/natash/project-repos/hr-attrition-prediction/data/`
5. Rename to: `hr-attrition-data.csv`

### What's in this dataset:
- 1,470 employee records
- 35 features: Age, Department, JobRole, MonthlyIncome, YearsAtCompany, Attrition, etc.
- Created by IBM data scientists
- Perfect for predicting employee turnover

---

## 📊 Project 4: Marketing Campaign ROI Dashboard

### Dataset: Marketing Campaign Performance
**Download Link**: https://www.kaggle.com/datasets/rodsaldanha/arketing-campaign

### Steps:
1. Go to the link above
2. Click "Download" button
3. Save `marketing_campaign.csv` to your computer
4. Move file to: `/Users/rj/Claude_code/natash/project-repos/marketing-roi-dashboard/data/`
5. Keep filename as: `marketing_campaign.csv`

### What's in this dataset:
- 2,240 customer records with campaign responses
- Columns: Customer demographics, purchase history, campaign responses
- Multiple marketing channels (email, catalog, web, store)
- Perfect for ROI analysis and channel optimization

---

## 📊 Project 5: Employee Engagement Analysis

### Dataset: Mental Health in Tech Survey
**Download Link**: https://www.kaggle.com/datasets/osmi/mental-health-in-tech-survey

### Steps:
1. Go to the link above
2. Click "Download" button
3. Save `survey.csv` to your computer
4. Move file to: `/Users/rj/Claude_code/natash/project-repos/employee-engagement-analysis/data/`
5. Rename to: `employee-survey-data.csv`

### What's in this dataset:
- Tech industry employee mental health and workplace survey
- Columns: Company size, remote work, benefits, work interference, mental health history
- Perfect for analyzing workplace culture and engagement

---

## ✅ Verification Checklist

After downloading all datasets, verify you have these files:

```
project-repos/
├── social-media-sentiment/data/sentiment140.csv (1.6M tweets)
├── customer-segmentation/data/ecommerce-data.csv (500k transactions)
├── hr-attrition-prediction/data/hr-attrition-data.csv (1,470 employees)
├── marketing-roi-dashboard/data/marketing_campaign.csv (2,240 customers)
└── employee-engagement-analysis/data/employee-survey-data.csv (survey responses)
```

---

## 🚨 Troubleshooting

### Issue: "Download requires phone verification"
**Solution**: Kaggle occasionally requires phone verification for security. Just verify your phone number once.

### Issue: "Can't find the file on Kaggle"
**Solution**: Make sure you're logged in to Kaggle. Some datasets are only visible to logged-in users.

### Issue: "File is too large / slow download"
**Solution**:
- Sentiment140 dataset is ~80MB - this is normal
- Use a stable internet connection
- Download one at a time

### Issue: "Dataset removed or unavailable"
**Solution**: If any dataset link is broken, let me know and I'll provide an alternative source.

---

## ⏱️ Estimated Time

- **Kaggle account setup**: 5 minutes
- **Each dataset download**: 2-5 minutes
- **Total time**: ~20-30 minutes

---

## 🎯 Next Steps After Downloading

Once all datasets are downloaded:

1. ✅ Open each CSV file in Excel to verify it downloaded correctly
2. ✅ Check the data looks reasonable (no corruption)
3. ✅ Note the file sizes (should match expectations)
4. ✅ Ready to start building Excel analyses!

---

**Need Help?**
- Kaggle Help Center: https://www.kaggle.com/contact
- Check MASTER_REQUIREMENTS_CHECKLIST.md for next steps after download
