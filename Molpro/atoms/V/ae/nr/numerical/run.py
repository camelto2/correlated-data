import shutil
import sys
import os
import subprocess
import numpy as np
from scipy.optimize import minimize
import pickle
from pyECP import ecp

def get_en_ae():
	states = ['I-s2d3','I-s1d4','I-d5','II-s1d3','II-d4','VI','XII','A-s2d4','III','IV','V']
	energies = []
	for i,state in enumerate(states):
		statefile = 'states/'+state+'.ip.d'
		shutil.copy(statefile,'ip.d')
		f = open('tmp.txt','w')
		subprocess.call('./numHF',stdout=f)
		f.close()
		outfile = open('out','rb')
		energy = float(outfile.readline().split()[0])
		energies.append(energy)
		outfile.close()
	return energies

print(get_en_ae())
