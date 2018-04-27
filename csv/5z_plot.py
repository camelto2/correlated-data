#! /usr/bin/env python

import sys,os
import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd


#os.system("module load texlive")
#os.system("module load python")

toev=27.21138602

ecps = ['uc','bfd-bfd','stu87-stu87','tn17-tn17','g43-lm', 'g73-lm','bfd-lm','stu87-lm','tn17-lm']
styles = {
'uc'        :{'label': 'UC',       'color':'#e41a1c','linestyle':'-'},
'bfd-bfd'       :{'label': 'BFD',      'color':'#377eb8','linestyle':'--','dashes': (3,1)      },
'stu87-stu87'	    :{'label': 'STU','color':'#ff7f00','linestyle':'--','dashes': (8,5,1,3)},
'tn17-tn17'      :{'label': 'eCEPP',    'color':'#984ea3','linestyle':'--','dashes': (6,1,3,1) },
'g43-lm'     :{'label': 'g43',      'color':'#4daf4a','linestyle':'--','dashes': (6,3)     },
'g73-lm'     :{'label': 'g73',      'color':'#4daf4a','linestyle':'--','dashes': (6,3)     },

'bfd-lm'       :{'label': 'BFD-LM',      'color':'#6600ff','linestyle':'--','dashes': (3,2)      },
'stu87-lm'     :{'label': 'STU-LM',      'color':'#006666','linestyle':'--','dashes': (4,3)     },
'tn17-lm'      :{'label': 'eCEPP-LM',    'color':'#cc0099','linestyle':'--','dashes': (4,2,1,2) },

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

def plot():
    fig,ax = init()
    data = pd.read_csv("ScO_5z.csv")
    #print data.head()
    #data.to_csv("ScO_5z.csv", sep=',', index=False)

    ax.axhspan(-0.05,0.05,alpha=0.25,color='gray')
    ax.axhline(0.0,color='black')
    ax.set_xlabel('Bond Length (\AA)')
    ax.set_ylabel('Discrepancy (eV)')
    for i,ecp in enumerate(ecps):
        x = data['r']
        y = (data[ecp] - data['ae'])*toev
        plt.plot(x,y,**styles[ecp])
    ax.set_xlim((1.2,2.0))
    plt.legend()
    #plt.savefig('ScO_5z.pdf')
    plt.show()

if __name__ == '__main__':
    plot()
