import pickle 
import pandas as pd

df = pd.DataFrame()
with open('ae/dkh/basis/gaps.p','rb') as f:
	ae = pickle.load(f)
	df['AE'] = ae['extrapolated gaps']

pps=['uc','bfd','stu','eCEPP','ccECP']
for pp in pps:
	with open(pp+'/basis/gaps.p','rb') as f:
		ecp = pickle.load(f)
	df[pp] = ecp['extrapolated gaps']

diffs = 27.211386*df.copy()

print("MADS")
for pp in pps: 
	diffs[pp] = diffs[pp] - diffs['AE']
	print(diffs[pp].abs().mean())

print(diffs.to_latex())
