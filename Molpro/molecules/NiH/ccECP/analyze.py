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

#~~~~~ Molecules ~~~~~~

A_hf = []
A_cc = []
B_hf = []
B_cc = []

df=pd.DataFrame()
#for bas in ['tz','qz','5z']:
for bas in ['5z']:
	x = pd.read_csv(bas+'.csv',skip_blank_lines=True,skipinitialspace=True)
	df[bas+'_scf'] = x['SCF']
	df[bas+'_ccsd'] = x['CCSD']

	A_hf.append(x['A_SCF'].iloc[0])
	A_cc.append(x['A_CCSD'].iloc[0])
	B_hf.append(x['B_SCF'].iloc[0])
	#B_cc.append(x['B_CCSD'].iloc[0])
	B_cc.append(x['B_SCF'].iloc[0])

print(A_hf)
print(A_cc)
print(B_hf)
print(B_cc)

df['z'] = x['Z']
df.set_index('z',inplace=True)

scf = df.filter(regex='scf')
cc = df.filter(regex='ccsd')

n = [3,4,5]
x = np.linspace(3,5,50)

scf_extrap = []
corr_extrap = []
for i in df.index:
	y = scf.ix[i].values
	p0 = [min(y),1.0,1.0]
	limit=([-np.inf, -np.inf, -np.inf], [min(y), np.inf, np.inf] )
	popt,pcov = curve_fit(exp_fit,xdata=n,ydata=y,p0=p0,bounds=limit)
	scf_extrap.append(popt[0])
	y = cc.ix[i].values-scf.ix[i].values
	p0 = [min(y),0,0]
	popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=y,p0=p0)
	corr_extrap.append(popt[0])

scf_extrap = np.array(scf_extrap)
corr_extrap = np.array(corr_extrap)

#~~~~~ Atoms ~~~~~

#A_hf = [-168.396370116655, -168.398209058072, -168.398393234654]
#A_cc = [-169.221924008028, -169.265898701086, -169.285110375423]
#B_hf = [-0.49982785, -0.49995494, -0.50000143]
#B_cc = [-0.49982785, -0.49995494, -0.50000143]

#A_cor = np.array(A_cc)-np.array(A_hf)
#B_cor = np.array(B_cc)-np.array(B_hf)
#
#p0 = [min(A_hf),1.0,1.0]
#limit=([-np.inf, -np.inf, -np.inf], [min(A_hf), np.inf, np.inf] )
#popt,pcov = curve_fit(exp_fit,xdata=n,ydata=A_hf,p0=p0,bounds=limit)
#A_hf_extrap = popt[0]
#
#p0 = [min(B_hf),1.0,1.0]
#limit=([-np.inf, -np.inf, -np.inf], [min(B_hf), np.inf, np.inf] )
#popt,pcov = curve_fit(exp_fit,xdata=n,ydata=B_hf,p0=p0,bounds=limit)
#B_hf_extrap = popt[0]
#
#
#p0 = [min(A_cor),0,0]
#popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=A_cor,p0=p0)
#A_cor_extrap = popt[0]
#
##p0 = [min(B_cor),0,0]
##popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=B_cor,p0=p0)
##B_cor_extrap = popt[0]
#B_cor_extrap = 0.0

#~~~~~~~~~~~~~~~~~

bind = pd.DataFrame()
bind['z'] = scf.index.values
bind.set_index('z',inplace=True)
#bind['bind'] = 27.211386*(scf_extrap+corr_extrap - (A_hf_extrap+A_cor_extrap) - (B_hf_extrap+B_cor_extrap))
#bind['bind'] = df['5z_ccsd'] - A_cc[2] - B_cc[2]
bind['bind'] = df['5z_ccsd'] - A_cc[0] - B_cc[0]
print(bind['bind'])
bind.plot()
plt.show()

import pickle
with open('bind.p','wb') as f:
	pickle.dump(bind,f)
bind.to_csv('bind.csv', sep=',')
