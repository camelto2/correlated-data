import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd
import pickle
import sys


ecps = ['uc','bfd','stu','eCEPP','ccECP.S','ccECP']
styles = {
'uc'        :{'label': 'UC',       'color':'#e41a1c','linestyle':'-'},
'bfd'       :{'label': 'BFD',      'color':'#377eb8','linestyle':'--','dashes': (6,3)      }, 
'stu'     :{'label': 'STU',      'color':'#ff7f00','linestyle':'--','dashes': (18,12,3,6)},
'eCEPP'      :{'label': 'eCEPP',    'color':'#984ea3','linestyle':'--','dashes': (12,3,6,3) },
'ccECP.S' :{'label': 'ccECP.S',  'color': '#a65628','linestyle':'--','dashes': (3,1)},
'ccECP':{'label': 'ccECP','color':'#4daf4a','linestyle':'--','dashes': (12,6)     },
}

def init():
	font = {'family' : 'serif',
			'size': 20}
	lines = {'linewidth':4}
	axes = {'linewidth': 3}
	tick = {'major.size': 5,
			'major.width':2}
	legend = {'frameon':False,
			  'fontsize':18}

	mpl.rc('font',**font)
	mpl.rc('lines',**lines)
	mpl.rc('axes',**axes)
	mpl.rc('xtick',**tick)
	mpl.rc('ytick',**tick)
	mpl.rc('legend',**legend)

	mpl.rcParams['text.usetex'] = True
	mpl.rcParams.update({'figure.autolayout':True})
	fig = plt.figure()
	ax1 = fig.add_subplot(111)
	return fig,ax1

def get_data():
	with open('ae/bind.p','rb') as f:
		ae = pickle.load(f)
	dfs = pd.DataFrame()
	for ecp in ecps:
		with open(ecp+'/bind.p','rb') as f:
			df = pickle.load(f)
		dfs[ecp] = df['bind']
	ha = dfs.copy()
	for col in ha:
		ha[col] = ha[col]/27.211386
	ha['ae'] = ae/27.211386
	ha.to_csv('CrH_5z.to_csv')
	return ae,dfs

def plot(skip=None,r0=None):
	fig,ax = init()
	ae,ecps = get_data()

	ax.axhspan(-0.043,0.043,alpha=0.25,color='gray')
	ax.axhline(0.0,color='black')
	ax.set_xlabel('Bond Length (\AA)')
	ax.set_ylabel('Discrepancy (eV)')
	for i,ecp in enumerate(ecps):
		if skip is not None:
			x = ecps.index.values[skip:]
			y = ecps[ecp].values[skip:] - ae['bind'].values[skip:]
		else:
			x = ecps.index.values
			y = ecps[ecp].values - ae['bind'].values
		plt.plot(x,y,**styles[ecp])
	ax.set_xlim((x[0],x[-1]))
	if r0:
		ax.axvline(r0,color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
		#ax.annotate(r'All-electron $R_{\rm eq}$ ', xy=(r0, 0.85*ax.get_ylim()[1]), xytext=(0.85*r0, 0.85*ax.get_ylim()[1]),color='red',va='center',ha='center',
        #    arrowprops=dict(arrowstyle='->',color='red'),
        #    )
		#ax.annotate('Near Dissociation ',xy=(ax.get_xlim()[0],0.8*ax.get_ylim()[0]), xytext=(1.15*ax.get_xlim()[0],0.8*ax.get_ylim()[0]),color='red',va='center',ha='left',
        #    arrowprops=dict(arrowstyle='->',color='red'),
        #    )

	plt.legend()
	plt.savefig('discrep.pdf')
	plt.show()

if __name__ == '__main__':
	if len(sys.argv) == 3:
		plot(skip=int(sys.argv[1]),r0=float(sys.argv[2]))
	else:
		plot()
