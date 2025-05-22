import yfinance as yf
import boto3
import pandas as pd
import json
from datetime import date, datetime

tickers = ['TMK.AX', 'DTR.AX', 'NDQ.AX', 'CBA.AX', 'RMD.AX']
data = yf.download(tickers, period='1d', interval='1h', group_by='ticker')

# Transform the data into a DataFrame with 7 columns
transformed_data = []
for ticker in tickers:
    # Get all metrics for this ticker
    ticker_data = data[ticker].copy()
    ticker_data['Ticker'] = ticker
    ticker_data = ticker_data.reset_index()
    ticker_data.columns = ['Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Ticker']
    transformed_data.append(ticker_data)

# Combine all ticker data
df_transformed = pd.concat(transformed_data, ignore_index=True)

# Reorder columns
columns_to_keep = ['Date', 'Ticker', 'Open', 'High', 'Low', 'Close', 'Volume']
df_transformed = df_transformed[columns_to_keep]

# Convert Date to string format
df_transformed['Date'] = df_transformed['Date'].dt.strftime('%Y-%m-%d %H:%M:%S')

# Convert to JSON with proper formatting
json_data = json.dumps(df_transformed.to_dict(orient='records'), indent=2)

# Preview the transformed data
print(f"Total records: {len(df_transformed)}")
print("\nDataFrame Info:")
print(df_transformed.info())
print("\nSample record:")
print(json.dumps(df_transformed.to_dict(orient='records')[0], indent=2))

# Configure AWS S3 Bucket for source data
s3 = boto3.client('s3')
s3.put_object(Bucket='asx-stock-raw-data-bucket', 
              Key=f"raw/{date.today().isoformat()}/stock.json",
              Body=json_data)

print("\nData has been saved to S3 successfully!")