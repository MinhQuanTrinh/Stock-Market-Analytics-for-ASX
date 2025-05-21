import yfinance as yf
import boto3
import pandas as pd
import json
from datetime import date, datetime

tickers = ['TMK.AX', 'DTR.AX', 'NDQ.AX', 'CBA.AX', 'RMD.AX']
data = yf.download(tickers, period='1d', interval='1h', group_by='ticker')

# Convert timestamp to readable datetime
def convert_timestamp(ts):
    return ts.strftime('%Y-%m-%d %H:%M:%S')

# Transform the data into a more readable format
transformed_data = []
for ticker in tickers:
    for metric in ['Open', 'High', 'Low', 'Close', 'Volume']:
        if (ticker, metric) in data.columns:
            for timestamp, value in data[(ticker, metric)].items():
                if pd.notna(value):  # Skip null values
                    transformed_data.append({
                        'timestamp': convert_timestamp(timestamp),
                        'ticker': ticker,
                        'metric': metric,
                        'value': float(value)
                    })

# Convert to JSON with proper formatting
json_data = json.dumps(transformed_data, indent=2)

# Preview the transformed data
print("\n=== Transformed Data Preview ===")
print(f"Total records: {len(transformed_data)}")
print("\nSample record:")
print(json.dumps(transformed_data[0], indent=2))

# Configure AWS S3 Bucket for source data
s3 = boto3.client('s3')
s3.put_object(Bucket='asx-stock-raw-data-bucket', 
              Key=f"raw/{date.today().isoformat()}/stock.json",
              Body=json_data)

print("\nData has been saved to S3 successfully!")