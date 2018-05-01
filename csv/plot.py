import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd
import pickle
import sys
import glob

ecps = ['uc','bfd','stu','tn17','ccECP.S','ccECP']

styles = {
        'uc'         :{'label': 'UC',       'color':'#e41a1c','linestyle':'--','dashes': (1000000,1)},
        'bfd'        :{'label': 'BFD',      'color':'#377eb8','linestyle':'--','dashes': (16,2)      },
        'stu'        :{'label': 'STU',      'color':'#ff7f00','linestyle':'--','dashes': (7,2)},
        'tn17'       :{'label': 'eCEPP',    'color':'#984ea3','linestyle':'--','dashes': (2.5,2) },
        'ccECP.S'    :{'label': 'ccECP.S',  'color':'#4daf4a','linestyle':'--','dashes': (13,2,4,2,13,9)},
        'ccECP'      :{'label': 'ccECP',    'color':'#DC0174','linestyle':'--','dashes': (10,2,4,2,4,2,10,9)     },
        }

toeV = 27.211386

mols = ['ScH','ScO','TiH','TiO','VH','VO',\
        'CrH','CrO','MnH','MnO','FeH','FeO',\
        'CoH','CoO','NiH','NiO','CuH','CuO','ZnO']

req = {'ScH':1.8,## AE
       'ScO':1.668,
       'TiH':1.779,
       'TiO':1.62,
       'VH' :1.7,##AE
       'VO' :1.589,
       'CrH':1.656,
       'CrO':1.615,
       'MnH':1.731,
       'MnO':1.646,
       'FeH':1.589,
       'FeO':1.616,
       'CoH':1.52,
       'CoO':1.629,
       'NiH':1.475,
       'NiO':1.627,
       'CuH':1.463,
       'CuO':1.724,
       'ZnO':1.7 ##AE
       }

def init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':4}
    axes = {'linewidth': 3}
    tick = {'major.size': 5,
            'major.width':2}
    legend = {'frameon':False,
              'fontsize':18,
              'handlelength':2.5}

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

def get_data(mol):
    files = glob.glob(mol+'*.csv')
    if len(files) > 1:
        print('Too many csv files for {}'.format(mol))
        sys.exit()
    elif len(files) == 0:
        df = pd.DataFrame()
    else:
        df = pd.read_csv(files[0],index_col=0)
    df.dropna(inplace=True)
    for col in df:
        df[col] = df[col]*toeV
    return df


def plot(mol):
    if mol == 'NiH': 
    	pass
    else:
        print('Molecule: {}'.format(mol))
        fig,ax = init()
        df = get_data(mol)

        ax.axhspan(-0.043,0.043,alpha=0.25,color='gray')
        ax.axhline(0.0,color='black')
        ax.set_xlabel('Bond Length (\AA)')
        ax.set_ylabel('Discrepancy (eV)')
        for i,ecp in enumerate(ecps):
            if (mol in ['TiH','TiO'] and ecp == 'ccECP') \
	    	or (mol in ['CoH','CoO','NiH','NiO','ZnO'] and ecp == 'tn17'):
            	pass
            else:
            	x = df.index.values
            	y = df[ecp].values - df['ae'].values
            	plt.plot(x,y,**styles[ecp])
        ax.set_xlim((x[0],x[-1]))

        ax.axvline(req[mol],color='black',linestyle='--',linewidth=1.5,dashes=(2,2))
	    
        if mol in ['ScH']:
        	plt.legend(loc='lower left')
        elif mol in ['FeH']:
            plt.legend(loc='upper left')
        elif mol in ['MnH','CrO','FeO','MnO','CoO','NiO','CuO','ZnO']:
        	plt.legend(loc='lower right')
        else:
        	plt.legend(loc='upper right')
        plt.savefig('figs/'+mol+'.pdf')
        plt.show()

for mol in mols:
    plot(mol)
