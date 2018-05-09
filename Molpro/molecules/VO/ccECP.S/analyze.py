import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
import sys

def exp_fit(x,*parms):
	return parms[0] + parms[1]*np.exp(-parms[2]*x)

def corr_fit1(x,*parms):
	return parms[0] + parms[1]/x**3

def corr_fit2(x,*parms):
	return parms[0] + parms[1]/(x+1)**3

def corr_fit3(x,*parms):
	return parms[0]+parms[1]/(x+3./8.)**3 + parms[2]/(x+3./8.)**5


    

A_hf = [-70.84668507, -70.84716950, -70.84719802]
A_cc = [-71.35154342, -71.37074739, -71.37849117 ]
B_hf = [-15.68718830, -15.68927383, -15.68976815]
B_cc = [-15.86568007, -15.87652869, -15.88033301]  
def extrapolate(plot=False):
	df=pd.DataFrame()
	for bas in ['tz','qz','5z']:
		x = pd.read_csv(bas+'.table1.txt',skip_blank_lines=True,skipinitialspace=True)
		df[bas+'_scf'] = x['SCF']
		df[bas+'_ccsd'] = x['CCSD']
	df['z'] = x['Z']
	df.set_index('z',inplace=True)
	
	scf = df.filter(regex='scf')
	cc = df.filter(regex='ccsd')
	
	n = [3,4,5]
	x = np.linspace(2,10,50)
	
	scf_extrap = []
	corr_extrap = []
	for i in df.index:
		y = scf.ix[i].values
		p0 = [-950,1.0,1.0]
		popt,pcov = curve_fit(exp_fit,xdata=n,ydata=y,p0=p0)
		scf_extrap.append(popt[0])
		y = cc.ix[i].values-scf_extrap[-1]
		p0 = [-0.5,0,0]
		popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=y,p0=p0)
		corr_extrap.append(popt[0])
	
	scf_extrap = np.array(scf_extrap)
	corr_extrap = np.array(corr_extrap)
	
	
	p0 = [-950,1.0,1.0]
	popt,pcov = curve_fit(exp_fit,xdata=n,ydata=A_hf,p0=p0)
	A_hf_extrap = popt[0]
	popt,pcov = curve_fit(exp_fit,xdata=n,ydata=B_hf,p0=p0)
	B_hf_extrap = popt[0]
	
	A_cor = np.array(A_cc)-A_hf_extrap
	B_cor = np.array(B_cc)-B_hf_extrap
	p0 = [-70,1,1]
	popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=A_cor,p0=p0)
	A_cor_extrap = popt[0]
	popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=B_cor,p0=p0)
	B_cor_extrap = popt[0]
	
	bind = pd.DataFrame()
	bind['z'] = scf.index.values
	bind.set_index('z',inplace=True)
	bind['bind'] = 27.211386*(scf_extrap+corr_extrap - (A_hf_extrap+A_cor_extrap) - (B_hf_extrap+B_cor_extrap))
	
	if plot:
		bind.plot()
		plt.show()
	
	import pickle
	with open('bind.p','wb') as f:
		pickle.dump(bind,f)


def basis(n=3,plot=False):
	n_lab = {3:'tz',
			 4:'qz',
			 5:'5z'}
	n_idx = {3:0,
			 4:1,
			 5:2}
	df = pd.read_csv(n_lab[n]+'.table1.txt',skip_blank_lines=True,skipinitialspace=True)
	df.set_index('Z',inplace=True)
	
	scf_extrap = np.array(df['SCF'])
	corr_extrap = np.array(df['CCSD'])-np.array(df['SCF'])
	
	A_cor = np.array(A_cc)-np.array(A_hf)
	B_cor = np.array(B_cc)-np.array(B_hf)
	
	A_hf_extrap = A_hf[n_idx[n]]
	B_hf_extrap = B_hf[n_idx[n]]
	
	A_cor_extrap = A_cor[n_idx[n]]
	B_cor_extrap = B_cor[n_idx[n]]
	
	bind = pd.DataFrame()
	bind['z'] = df.index.values
	bind.set_index('z',inplace=True)
	bind['bind'] = 27.211386*(scf_extrap+corr_extrap - (A_hf_extrap+A_cor_extrap) - (B_hf_extrap+B_cor_extrap))
	
	if plot:
		bind.plot()
		plt.show()
	
	import pickle
	with open('bind.p','wb') as f:
		pickle.dump(bind,f)

if __name__ == '__main__':
	if len(sys.argv) != 2:
		extrapolate()
	else:
		if sys.argv[1] != 'extrapolate':
			basis(int(sys.argv[1]))
		else:
			extrapolate()

