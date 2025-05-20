import yfinance as yf
import boto3
import pandas as pd
import json
from datetime import date

tickers = ['TMK.AX', 'DTR.AX', 'NDQ.AX', 'CBA.AX', 'RMD.AX']
data = yf.download(tickers, period='1d', interval='1h', group_by='ticker')

json_data = data.to_json()

# Configure AWS S3 Bucket for source data
s3 = boto3.client('s3')
s3.put_object(Bucket='asx-stock-raw-data-bucket', 
              Key=f"raw/{date.today().isoformat()}/stock.json",
              Body=json_data)