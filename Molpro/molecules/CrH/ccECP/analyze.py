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
A_hf = [-86.047810691588,-86.048454537952,-86.048542303025]
A_cc = [-86.590035080525,-86.614484484558,-86.624535945469]
B_hf = [-0.49982132, -0.49994833, -0.49999479]
B_cc = [-0.49982132, -0.49994833, -0.49999479]

def extrapolate():
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
		y = cc.ix[i].values-scf.ix[i].values
		p0 = [-0.5,0,0]
		popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=y,p0=p0)
		corr_extrap.append(popt[0])
	
	scf_extrap = np.array(scf_extrap)
	corr_extrap = np.array(corr_extrap)
	
	
	A_cor = np.array(A_cc)-np.array(A_hf)
	B_cor = np.array(B_cc)-np.array(B_hf)
	
	p0 = [-950,1.0,1.0]
	popt,pcov = curve_fit(exp_fit,xdata=n,ydata=A_hf,p0=p0)
	A_hf_extrap = popt[0]
	popt,pcov = curve_fit(exp_fit,xdata=n,ydata=B_hf,p0=p0)
	B_hf_extrap = popt[0]
	
	
	p0 = [-0.5,0,0]
	popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=A_cor,p0=p0)
	A_cor_extrap = popt[0]
	popt,pcov = curve_fit(corr_fit3,xdata=n,ydata=B_cor,p0=p0)
	B_cor_extrap = popt[0]
	
	bind = pd.DataFrame()
	bind['z'] = scf.index.values
	bind.set_index('z',inplace=True)
	bind['bind'] = 27.211386*(scf_extrap+corr_extrap - (A_hf_extrap+A_cor_extrap) - (B_hf_extrap+B_cor_extrap))
	
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
	if len(sys.argv)!=2:
		extrapolate()
	else:
		if sys.argv[1]!='extrapolate':
			basis(int(sys.argv[1]))
		else:
			extrapolate()
