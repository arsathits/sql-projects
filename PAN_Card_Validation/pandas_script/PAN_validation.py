import pandas as pd

df = pd.read_csv("dataset/PAN Number Validation Dataset.csv")
print(df.head(10))
print('Total records = ',len(df))

df['Pan_Numbers'] = df['Pan_Numbers'].astype('string').str.strip().str.upper()
print(df.head(10))