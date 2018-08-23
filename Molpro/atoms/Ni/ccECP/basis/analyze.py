import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

def exp_fit(x,*parms):
	return parms[0] + parms[1]*np.exp(-parms[2]*x)

def corr_fit1(x,*parms):
	return parms[0] + parms[1]/x**3

def corr_fit2(x,*parms):
	return parms[0] + parms[1]/(x+1)**3

def corr_fit3(x,*parms):
	return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5

df=pd.DataFrame()
for bas in ['tz','qz','5z']:
	x = pd.read_csv(bas+'.csv',skip_blank_lines=True,skipinitialspace=True)
	df[bas+'_scf'] = x['SCF']
	df[bas+'_ccsd'] = x['CCSD']

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

n = [3,4,5]
x = np.linspace(3,5,50)

scf_extrap = []
corr_extrap = []
for i in df.index:
	print(i)
	y = scf.ix[i].values
	p0 = [min(y),1.0,1.0]
	limit=([-np.inf, -np.inf, -np.inf], [min(y), np.inf, np.inf] )
	try:
		popt,pcov = curve_fit(exp_fit,xdata=n,ydata=y,p0=p0,bounds=limit)
		scf_extrap.append(popt[0])
	except:
		scf_extrap.append(y[2])
		print('Extrapolation unsuccesful!')
	plt.plot(n,y,'o')
	plt.plot(x,exp_fit(x,*popt), '--')
	plt.axhline(y=popt[0], ls='dashed', color='red')
	plt.show()

	y = cc.ix[i].values-scf.ix[i].values
	p0 = [min(y),0,0]
	popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=y,p0=p0)
	corr_extrap.append(popt[0])

        plt.plot(n,y,'o')
        plt.plot(x,corr_fit3(x,*popt), '--')
        plt.axhline(y=popt[0], ls='dashed', color='red')
        plt.show()


scf['extrap'] = scf_extrap
scf['numerical'] = [-168.474947, -168.416604, -168.255921, -168.214758, -168.178142, -167.621886, -166.419637, -164.470962, -161.755701, -157.822771, -152.949193, -146.997103, -139.897826, -131.667882, -42.732722, -168.414103] 
scf['diffs'] = scf['extrap'] - scf['numerical']
scf['extrap_gaps'] = scf['extrap'].values - scf['extrap'].values[0]
scf['numerical_gaps'] = scf['numerical'].values - scf['numerical'].values[0]
scf['gap_diffs'] = scf['extrap_gaps'] - scf['numerical_gaps']
print(scf.to_latex())

cc['extrap'] = np.array(corr_extrap)+np.array(scf_extrap)

corr = pd.DataFrame()
corr['TZ'] = cc['tz_ccsd'] - scf['tz_scf']
corr['QZ'] = cc['qz_ccsd'] - scf['qz_scf']
corr['5Z'] = cc['5z_ccsd'] - scf['5z_scf']
corr['Extrap.'] = cc['extrap'] - scf['extrap']
corr['Extrap. Gaps'] = corr['Extrap.'].values - corr['Extrap.'].values[0]
print(corr.to_latex())


import pickle
gaps = pd.DataFrame()
gaps['extrapolated gaps'] = scf['extrap_gaps'] + corr['Extrap. Gaps']
gaps.drop(gaps.index[0],inplace=True)
with open('gaps.p','wb') as f:
	pickle.dump(gaps,f,protocol=2)
