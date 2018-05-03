import pandas as pd

df = pd.read_csv('Mn_new.dat',delimiter='&',index_col=0)

print(df)
print(df.iloc[:5].abs().mean().round(6).tolist())
print(df.abs().mean().round(6).tolist())
