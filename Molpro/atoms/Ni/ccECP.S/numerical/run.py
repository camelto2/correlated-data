import shutil
import sys
import os
import subprocess
import numpy as np
from scipy.optimize import minimize
import pickle
from pyECP import ecp

def plot_ecps(ecps,rmax):
	import matplotlib.pyplot as plt
	npts=100
	x = np.linspace(0.001,rmax,npts)
	lines=['-','--','-.',':']
	for i,ecp in enumerate(ecps):
		for l in range(len(ecp.n)-1):
			y = [ ecp.eval_channel(l,x[i]) for i in range(npts) ]
			plt.plot(x,y,label='l = '+str(l)+' ECP'+str(i),linestyle = lines[i])
		y = [ ecp.eval_local(x[i]) for i in range(npts) ]
		plt.plot(x,y,label='local ECP'+str(i),linestyle= lines[i])
	plt.legend(frameon=False)
	plt.show()

def get_en_ae():
	states = ['I-s2d8','I-s1d9','I-d10','II-s1d8','II-d9','III','IV','V','VI','VII','VIII','IX','X','XI','XVII','A-s2d9']
	energies = []
	for i,state in enumerate(states):
		statefile = 'states/'+state+'.ip.d'
		shutil.copy(statefile,'runs/ip.d')
		shutil.copy('numHF','runs')
		f = open('runs/tmp.txt','w')
		subprocess.call('./numHF',stdout=f,cwd='runs')
		f.close()
		outfile = open('runs/out','rb')
		energy = float(outfile.readline().split()[0])
		energies.append(energy)
		outfile.close()
	return energies

def get_en_pp():
	states = ['I-s2d8','I-s1d9','I-d10','II-s1d8','II-d9','III','IV','V','VI','VII','VIII','IX','X','XI','XVII','A-s2d9']
	energies = []
	for i,state in enumerate(states):
		statefile = 'pp_states/'+state+'.ip.d'
		shutil.copy(statefile,'runs/ip.d')
		shutil.copy('numHF','runs')
		f=open('runs/tmp.txt','w')
		subprocess.call('./numHF',stdout=f,cwd='runs')
		f.close()
		outfile = open('runs/out','rb')
		energy = float(outfile.readline().split()[0])
		energies.append(energy)
		outfile.close()
	return energies

def generate_objective(opt,obs,show=False):
	opt_vals = []
	[ opt_vals.append(opt[i] - opt[0]) for i in range(1,len(opt)) ] 
	opt_vals = np.array(opt_vals)

	obs_vals = []
	[ obs_vals.append(obs[i] - obs[0]) for i in range(1,len(obs)) ] 
	obs_vals = np.array(obs_vals)

	f = ((opt_vals-obs_vals)**2).mean()

	if show:
		print(opt_vals)
		print(obs_vals)
		print(obs_vals-opt_vals)
		print(f)

	return f

def optECP(x,*args):
	ae = args[0]
	Zeff = args[1]
	n = args[2]
	log_expt = args[3]
	a = []
	c = []
	k = 0
	for i in range(len(n)):
		a.append([])
		c.append([])
		for j in range(len(n[i])):
			if log_expt:
				a[i].append(np.exp(x[k]))
			else:
				a[i].append(x[k])
			k+=1
			c[i].append(x[k])
			k+=1
	pp = ecp.ECP(Zeff,n,a,c)
	pp.write_ecp('runs/pp.d')
	obs = get_en_pp()
	return generate_objective(ae,obs)

Nfeval = 1
def callbackF(Xi):
	global Nfeval
	f = open('progress.dat','a')
	f.write('{}    '.format(Nfeval))
	for i in range(len(Xi)):
		if i%2 == 0:
			f.write('{}    '.format(Xi[i]))
		else:
			f.write('{}    '.format(Xi[i]))
	f.write('\n')
	f.close()
	Nfeval += 1

def run_optimization(log_expt=True):
	init_pp = ecp.ECP()
	init_pp.read_ecp('initial.pp.d')
	ae = get_en_ae()
	
	x0 = []
	for i in range(len(init_pp.n)):
		for j in range(len(init_pp.n[i])):
			if log_expt:
				x0.append(np.log(init_pp.alpha[i][j]))
			else:
				x0.append(init_pp.alpha[i][j])
			x0.append(init_pp.coeff[i][j])
	
	bounds = []
	for x in x0:
		x1=x/10
		x2= x*10
		if x1>x2:
			bounds.append((x2,x1))
		else:
			bounds.append((x1,x2))
	#adding shift and bounds on shift
	#x0.append(0.0)
	#bounds.append((None,None))
	#bounds = tuple(bounds)
	
	if log_expt:
		cons = ({'type': 'eq',   'fun': lambda x: x[9]*np.exp(x[8]) - x[11]},                                  #bfd local constraint
				{'type': 'eq',   'fun': lambda x: x[9] - init_pp.zeff},                                         # has to be Zeff
				{'type': 'ineq', 'fun': lambda x: np.exp(x[14])*x[15] + np.exp(x[12])*x[13] + np.exp(x[0])*x[1] + np.exp(x[2])*x[3]}, #s smooth constraint
				{'type': 'ineq', 'fun': lambda x: np.exp(x[14])*x[15] + np.exp(x[12])*x[13] + np.exp(x[4])*x[5] + np.exp(x[6])*x[7]}) #p smooth constraint
	else:
		cons = ({'type': 'eq',   'fun': lambda x: x[9]*x[8] - x[11]},                  #bfd local constraint
				{'type': 'eq',   'fun': lambda x: x[9] - init_pp.zeff},                 # has to be Zeff
				{'type': 'ineq', 'fun': lambda x: x[14]*x[15] + x[12]*x[13] + x[0]*x[1] + x[2]*x[3]}, #s smooth constraint
				{'type': 'ineq', 'fun': lambda x: x[14]*x[15] + x[12]*x[13] + x[4]*x[5] + x[6]*x[7]}) #p smooth constraint
	
	
	print('Starting optimizations')
	for eps in [1.0,0.1,0.01,0.001,0.0001]:
		try:
			with open('results/res_eps'+str(eps)+'.p','rb') as f:
				print('Already completed optimization with eps {}'.format(eps))
				prev_result = pickle.load(f)
				x0 = prev_result.x
		except IOError:
			f = open('progress.dat','w')
			f.write('EPS: {}   \n'.format(eps))
			f.write('{}    '.format('It'))
			for i in range(len(x0)):
				f.write('X{}    '.format(i))
			f.write('\n')
			f.close()
			result = minimize(optECP, x0, args=(ae,init_pp.zeff,init_pp.n,log_expt),
					 method='SLSQP',
					 constraints = cons,
					 bounds = bounds,
					 callback=callbackF,
					 options={'eps': eps,
						      'ftol': 1e-07,
							  'maxiter': 200})
			x0 = result.x
			pickle.dump(result,open('results/res_eps'+str(eps)+'.p','wb'))

def test_results(log_expt=True):
	opts = []
	for eps in [1.0,0.1,0.01,0.001,0.0001]:
		print('eps: {}'.format(eps))
		try:
			with open('results/res_eps'+str(eps)+'.p','rb') as f:
				opt = pickle.load(f)
				print(opt)
				opts.append(opt)
		except:
			continue
		print()
		print()

	init_pp = ecp.ECP()
	init_pp.read_ecp('initial.pp.d')
	init_pp.write_ecp('runs/pp.d')
	init = get_en_pp()

	pps = []
	for opt in opts:
		a = []
		c = []
		k = 0                            	
		for i in range(len(init_pp.n)):
			a.append([])  
			c.append([])
			for j in range(len(init_pp.n[i])):
				if log_expt:
					a[i].append(np.exp(opt.x[k]))
				else:
					a[i].append(opt.x[k])
				k+=1
				c[i].append(opt.x[k])
				k+=1
		opt_pp = ecp.ECP(init_pp.zeff,init_pp.n,a,c)
		pps.append(opt_pp)
	#plot_ecps([init_pp]+pps,1.5)
	pps[-1].write_ecp('pp.d')
	pps[-1].write_ecp('runs/pp.d')
	en = get_en_pp()
	ae = get_en_ae()
	print('INITIAL')
	generate_objective(ae,init,show=True)
	print('FINAL')
	generate_objective(ae,en,show=True)


if __name__ == '__main__':
	pp = ecp.ECP()
	pp.read_ecp('initial.pp.d')
	pp.write_ecp('runs/pp.d')
	print(get_en_pp())
