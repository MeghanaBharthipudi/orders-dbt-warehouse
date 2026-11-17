import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

load_dotenv()                                    # reads DATABASE_URL from your .env
engine = create_engine(os.environ["DATABASE_URL"])

df = pd.read_csv(r"C:\Users\Admin\Downloads\customers.csv")
df.to_sql("customers", engine, if_exists="replace", index=False)
print("Loaded", len(df), "customers")