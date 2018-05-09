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
	x = pd.read_csv(bas+'.table1.txt',skip_blank_lines=True,skipinitialspace=True)
	df[bas+'_scf'] = x['SCF']
	df[bas+'_ccsd'] = x['CCSD']

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

n = [3,4,5]
x = np.linspace(2,10,50)

scf_extrap = []
corr_extrap = []
for i in df.index:
	y = scf.ix[i].values
	p0 = [-1600,1.0,1.0]
	popt,pcov = curve_fit(exp_fit,xdata=n,ydata=y,p0=p0)
	scf_extrap.append(popt[0])
#	plt.scatter(n,y)
#	plt.plot(x,exp_fit(x,*popt))
#	plt.show()

	y = cc.ix[i].values-scf.ix[i].values
	p0 = [-1.0,0,0]
	popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=y,p0=p0)
	corr_extrap.append(popt[0])

scf['extrap'] = scf_extrap
scf['numerical'] = [-1638.949068, -1638.962706, -1638.68013, -1638.727207, -1638.083505, -1636.81909, -1634.781622, -1631.88437, -1628.122555, -1623.015642, -1616.88255, -1609.583435, -1601.054099, -1591.321216, -1490.603937, -1638.963107]
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
