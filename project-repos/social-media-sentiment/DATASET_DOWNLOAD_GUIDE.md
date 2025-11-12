# Dataset Download Guide

## Getting the Sentiment140 Dataset

This project uses the Sentiment140 dataset from Stanford University, which contains 1.6 million tweets labeled for sentiment analysis.

### Option 1: Download from Kaggle (Recommended)

1. Visit the Kaggle dataset page:
   https://www.kaggle.com/datasets/kazanova/sentiment140

2. Click "Download" (you may need to create a free Kaggle account)

3. Extract the ZIP file - you'll get `training.1600000.processed.noemoticon.csv`

4. Rename it to `sentiment140.csv` and place it in the `data/` folder of this project

### Option 2: Direct Download

If you prefer not to use Kaggle:

1. Download directly from the source:
   http://cs.stanford.edu/people/alecmgo/trainingandtestdata.zip

2. Extract the ZIP file

3. Rename `training.1600000.processed.noemoticon.csv` to `sentiment140.csv`

4. Place in the `data/` folder

### Dataset Information

- **Size**: ~227 MB (uncompressed CSV)
- **Records**: 1,600,000 tweets
- **Columns**:
  - target: Sentiment (0 = negative, 4 = positive)
  - ids: Tweet ID
  - date: Tweet timestamp
  - flag: Query (if there is no query, this value is NO_QUERY)
  - user: Username
  - text: Tweet content

### Why isn't the dataset included in this repo?

GitHub has a 100 MB file size limit, and this dataset is 227 MB. Rather than use Git LFS or split the file, I'm providing download instructions so you can get the original, complete dataset directly from the source.

### After Downloading

Once you have the dataset in the `data/` folder, you can:

1. Run the Python script to prepare a sample:
   ```bash
   python scripts/prepare-data.py
   ```

2. Or import directly into Excel for analysis

3. The visualizations and analysis in this project are based on a balanced sample of 10,000 tweets (5,000 positive, 5,000 negative)

## Questions?

If you have trouble downloading the dataset, feel free to reach out or check the Kaggle discussion forums for help.
