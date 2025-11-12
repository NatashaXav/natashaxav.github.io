"""
Sentiment Analysis Module
Analyzes text sentiment using multiple models (VADER, TextBlob, RoBERTa)
"""

import pandas as pd
import numpy as np
from typing import List, Dict, Tuple
import re
from textblob import TextBlob
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
import warnings
warnings.filterwarnings('ignore')


class SentimentAnalyzer:
    """
    Multi-model sentiment analyzer for social media text
    """

    def __init__(self, model_type: str = 'roberta'):
        """
        Initialize sentiment analyzer

        Args:
            model_type: 'vader', 'textblob', or 'roberta'
        """
        self.model_type = model_type
        self.vader_analyzer = SentimentIntensityAnalyzer()

        if model_type == 'roberta':
            # Load pre-trained RoBERTa model for sentiment
            self.tokenizer = AutoTokenizer.from_pretrained(
                'cardiffnlp/twitter-roberta-base-sentiment'
            )
            self.model = AutoModelForSequenceClassification.from_pretrained(
                'cardiffnlp/twitter-roberta-base-sentiment'
            )
            self.model.eval()

    def preprocess_text(self, text: str) -> str:
        """
        Clean and preprocess text

        Args:
            text: Raw tweet text

        Returns:
            Cleaned text
        """
        # Remove URLs
        text = re.sub(r'http\S+|www\S+|https\S+', '', text, flags=re.MULTILINE)

        # Remove mentions and hashtags
        text = re.sub(r'@\w+', '', text)

        # Remove special characters and extra spaces
        text = re.sub(r'[^\w\s]', ' ', text)
        text = re.sub(r'\s+', ' ', text).strip()

        return text.lower()

    def analyze_vader(self, text: str) -> Dict[str, float]:
        """
        Analyze sentiment using VADER

        Args:
            text: Input text

        Returns:
            Dictionary with sentiment scores
        """
        scores = self.vader_analyzer.polarity_scores(text)

        # Classify based on compound score
        if scores['compound'] >= 0.05:
            sentiment = 'positive'
            label = 1
        elif scores['compound'] <= -0.05:
            sentiment = 'negative'
            label = -1
        else:
            sentiment = 'neutral'
            label = 0

        return {
            'sentiment': sentiment,
            'label': label,
            'score': scores['compound'],
            'positive': scores['pos'],
            'negative': scores['neg'],
            'neutral': scores['neu']
        }

    def analyze_textblob(self, text: str) -> Dict[str, float]:
        """
        Analyze sentiment using TextBlob

        Args:
            text: Input text

        Returns:
            Dictionary with sentiment scores
        """
        blob = TextBlob(text)
        polarity = blob.sentiment.polarity
        subjectivity = blob.sentiment.subjectivity

        # Classify based on polarity
        if polarity > 0.1:
            sentiment = 'positive'
            label = 1
        elif polarity < -0.1:
            sentiment = 'negative'
            label = -1
        else:
            sentiment = 'neutral'
            label = 0

        return {
            'sentiment': sentiment,
            'label': label,
            'score': polarity,
            'subjectivity': subjectivity
        }

    def analyze_roberta(self, text: str) -> Dict[str, float]:
        """
        Analyze sentiment using RoBERTa model

        Args:
            text: Input text

        Returns:
            Dictionary with sentiment scores
        """
        # Tokenize text
        encoded_input = self.tokenizer(
            text,
            return_tensors='pt',
            truncation=True,
            max_length=512,
            padding=True
        )

        # Get model predictions
        with torch.no_grad():
            output = self.model(**encoded_input)
            scores = output[0][0].detach().numpy()
            scores = torch.nn.functional.softmax(torch.tensor(scores), dim=0).numpy()

        # scores: [negative, neutral, positive]
        label_map = {0: -1, 1: 0, 2: 1}  # negative, neutral, positive
        predicted_label = np.argmax(scores)

        sentiment_map = {0: 'negative', 1: 'neutral', 2: 'positive'}

        return {
            'sentiment': sentiment_map[predicted_label],
            'label': label_map[predicted_label],
            'score': float(scores[predicted_label]),
            'negative_prob': float(scores[0]),
            'neutral_prob': float(scores[1]),
            'positive_prob': float(scores[2])
        }

    def analyze_text(self, text: str) -> Dict[str, any]:
        """
        Analyze text using selected model

        Args:
            text: Input text

        Returns:
            Sentiment analysis results
        """
        # Preprocess
        cleaned_text = self.preprocess_text(text)

        # Analyze using selected model
        if self.model_type == 'vader':
            result = self.analyze_vader(cleaned_text)
        elif self.model_type == 'textblob':
            result = self.analyze_textblob(cleaned_text)
        elif self.model_type == 'roberta':
            result = self.analyze_roberta(cleaned_text)
        else:
            raise ValueError(f"Unknown model type: {self.model_type}")

        result['original_text'] = text
        result['cleaned_text'] = cleaned_text

        return result

    def analyze_batch(self, texts: List[str], show_progress: bool = True) -> pd.DataFrame:
        """
        Analyze multiple texts

        Args:
            texts: List of text strings
            show_progress: Show progress bar

        Returns:
            DataFrame with sentiment results
        """
        results = []

        if show_progress:
            from tqdm import tqdm
            iterator = tqdm(texts, desc="Analyzing sentiment")
        else:
            iterator = texts

        for text in iterator:
            try:
                result = self.analyze_text(text)
                results.append(result)
            except Exception as e:
                # Handle errors gracefully
                results.append({
                    'sentiment': 'error',
                    'label': 0,
                    'score': 0.0,
                    'original_text': text,
                    'error': str(e)
                })

        return pd.DataFrame(results)

    def get_sentiment_summary(self, df: pd.DataFrame) -> Dict[str, any]:
        """
        Generate summary statistics

        Args:
            df: DataFrame with sentiment results

        Returns:
            Summary statistics dictionary
        """
        # Remove error rows
        df_clean = df[df['sentiment'] != 'error']

        sentiment_counts = df_clean['sentiment'].value_counts()
        total = len(df_clean)

        summary = {
            'total_analyzed': total,
            'positive_count': int(sentiment_counts.get('positive', 0)),
            'neutral_count': int(sentiment_counts.get('neutral', 0)),
            'negative_count': int(sentiment_counts.get('negative', 0)),
            'positive_pct': round(sentiment_counts.get('positive', 0) / total * 100, 2),
            'neutral_pct': round(sentiment_counts.get('neutral', 0) / total * 100, 2),
            'negative_pct': round(sentiment_counts.get('negative', 0) / total * 100, 2),
            'avg_score': round(df_clean['score'].mean(), 3),
            'errors': len(df) - total
        }

        return summary


# Example usage
if __name__ == '__main__':
    # Initialize analyzer
    analyzer = SentimentAnalyzer(model_type='roberta')

    # Sample tweets
    sample_tweets = [
        "I absolutely love this product! Best purchase ever! 😍",
        "This is terrible. Worst customer service I've experienced.",
        "The product is okay. Nothing special but it works.",
        "Just received my order. Let's see how it performs.",
        "Amazing quality and fast shipping! Highly recommend! ⭐⭐⭐⭐⭐"
    ]

    # Analyze batch
    results = analyzer.analyze_batch(sample_tweets, show_progress=False)

    # Print results
    print("\nSentiment Analysis Results:")
    print("=" * 80)
    for idx, row in results.iterrows():
        print(f"\nTweet: {row['original_text'][:60]}...")
        print(f"Sentiment: {row['sentiment'].upper()} (Score: {row['score']:.3f})")

    # Get summary
    summary = analyzer.get_sentiment_summary(results)
    print("\n" + "=" * 80)
    print("Summary Statistics:")
    print(f"Total Analyzed: {summary['total_analyzed']}")
    print(f"Positive: {summary['positive_count']} ({summary['positive_pct']}%)")
    print(f"Neutral: {summary['neutral_count']} ({summary['neutral_pct']}%)")
    print(f"Negative: {summary['negative_count']} ({summary['negative_pct']}%)")
    print(f"Average Score: {summary['avg_score']}")
