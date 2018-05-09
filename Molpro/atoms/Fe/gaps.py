#! /usr/bin/env python

import pickle 
import pandas as pd
import numpy as np
import os
from scipy.optimize import curve_fit
import matplotlib as mpl
import matplotlib.pyplot as plt

ecps = ['uc','bfd','stu','eCEPP','ccECP.S','ccECP']

def table():
	df = pd.DataFrame()
	with open('ae/dkh/basis/gaps.p','rb') as f:
		ae = pickle.load(f)
		df['AE'] = ae['extrapolated gaps']
	for pp in ecps:
		with open(pp+'/basis/gaps.p','rb') as f:
			ecp = pickle.load(f)
		df[pp] = ecp['extrapolated gaps']
	
	diffs = 27.211386*df.copy()
	print("MADS")
	for pp in ecps: 
		diffs[pp] = diffs[pp] - diffs['AE']
		print(diffs[pp].abs().mean())
	print(diffs.to_latex())

table()
