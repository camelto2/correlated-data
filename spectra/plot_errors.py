#!/usr/bin/env python

import pandas as pd
import numpy as np
import os
import matplotlib as mpl
import matplotlib.pyplot as plt

tms = ['Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn']
linestyles = {
'UC'         :{'color':'#e41a1c','linestyle':'-'},
'BFD'        :{'color':'#377eb8','linestyle':'-'},
'STU'        :{'color':'#ff7f00','linestyle':'-'},
'eCEPP'      :{'color':'#984ea3','linestyle':'-'},
'ccECP.S'    :{'color':'#4daf4a','linestyle':'-'},
'ccECP'      :{'color':'#DC0174','linestyle':'-'},
}
pointstyles = {
'UC'       :{'label': 'UC',      'color':'#e41a1c','marker': '.'},
'BFD'      :{'label': 'BFD',     'color':'#377eb8','marker': ','},
'STU'      :{'label': 'STU',     'color':'#ff7f00','marker': 'o'},
'eCEPP'    :{'label': 'eCEPP',   'color':'#984ea3','marker': 'x'},
'ccECP.S'  :{'label': r'ccECP.S','color':'#4daf4a','marker': '+'},
'ccECP'    :{'label': r'ccECP',  'color':'#DC0174','marker': 'd'},
}


def mpl_init():
    font = {'family' : 'serif',
            'size': 20}
    lines = {'linewidth':2,'markersize':8}
    axes = {'linewidth': 3}
    xtick = {'major.size': 5,
            'major.width':2}
    ytick = {'major.size': 5,
            'major.width':2,
            'minor.visible':True,
            'minor.size':3,
            'minor.width':2,
            'direction':'in'}
    legend = {'frameon':False,
              'fontsize':15,
              'handlelength':2.5}
    mpl.rc('font',**font)
    mpl.rc('lines',**lines)
    mpl.rc('axes',**axes)
    mpl.rc('xtick',**xtick)
    mpl.rc('ytick',**ytick)
    mpl.rc('legend',**legend)
    mpl.rcParams['text.usetex'] = True
    mpl.rcParams.update({'figure.autolayout':True})
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    return fig,ax1


def Is2dn_to_Is1dn1():
    df = pd.DataFrame()
    tmdf = {}
    for tm in tms:
        tmdf[tm] = pd.read_csv(tm+'.dat',skipinitialspace=True,delimiter='&')
    
    calcs = {'UC'       : [],
             'BFD'      : [],
             'STU'    : [],
             'eCEPP'    : [],
             'ccECP.S': [],
             'ccECP': []}
    for tm in tms:
            print(tm)
            if tm == 'Zn':
                calcs['UC'].append(np.nan)
                calcs['BFD'].append(np.nan)
                calcs['STU'].append(np.nan)
                calcs['eCEPP'].append(np.nan)
                calcs['ccECP.S'].append(np.nan)
                calcs['ccECP'].append(np.nan)
            else:
                calcs['UC'].append(tmdf[tm].filter(regex='UC').values[1][0])
                calcs['BFD'].append(tmdf[tm].filter(regex='BFD').values[1][0])
                calcs['STU'].append(tmdf[tm].filter(regex='STU').values[1][0])
                try:
                    calcs['eCEPP'].append(tmdf[tm].filter(regex='eCEPP').values[1][0])
                except:
                    calcs['eCEPP'].append(np.nan)
                calcs['ccECP.S'].append(tmdf[tm].filter(regex='ccECP.S').values[1][0])
                try:
                    calcs['ccECP'].append(tmdf[tm].filter(regex='ccECP ').values[1][0])
                except:
                    calcs['ccECP'].append(np.nan)
    
    fig,ax = mpl_init()
    itms = [i for i,tm in enumerate(tms)]
    ax.set_ylim(-0.1,0.2)
    ax.set_xlim(-0.5,9.5)
    ax.axhline(0.0,color='black')
    ax.axhspan(-0.021,0.021,alpha=0.25,color='gray')
    for calc in ['UC','BFD','STU','eCEPP','ccECP.S','ccECP']:
        ax.scatter(itms,calcs[calc],**pointstyles[calc])
        ax.plot(itms,calcs[calc],**linestyles[calc])
        ax.set_xticks(itms)
        ax.set_xticklabels(tms)
    ax.set_ylabel('Discrepancy (eV)')
    ax.legend(ncol=3,loc='lower center',handletextpad=0.1)
    ax.set_title(r'X$^0$  $s^2d^n$  $\rightarrow$  X$^0$  $s^1d^{n+1}$')
    plt.savefig('Is2dn_to_Is1dn1.pdf')
    plt.show()
    
def Is2dn_to_Idn2():
    df = pd.DataFrame()
    tmdf = {}
    for tm in tms:
        tmdf[tm] = pd.read_csv(tm+'.dat',skipinitialspace=True,delimiter='&')
    
    calcs = {'UC'       : [],
             'BFD'      : [],
             'STU'    : [],
             'eCEPP'    : [],
             'ccECP.S': [],
             'ccECP': []}
    for tm in tms:
            if tm == 'Zn' or tm == 'Cu':
                calcs['UC'].append(np.nan)
                calcs['BFD'].append(np.nan)
                calcs['STU'].append(np.nan)
                calcs['eCEPP'].append(np.nan)
                calcs['ccECP.S'].append(np.nan)
                calcs['ccECP'].append(np.nan)
            else:
                calcs['UC'].append(tmdf[tm].filter(regex='UC').values[2][0])
                calcs['BFD'].append(tmdf[tm].filter(regex='BFD').values[2][0])
                calcs['STU'].append(tmdf[tm].filter(regex='STU').values[2][0])
                try:
                    calcs['eCEPP'].append(tmdf[tm].filter(regex='eCEPP').values[2][0])
                except:
                    calcs['eCEPP'].append(np.nan)
                calcs['ccECP.S'].append(tmdf[tm].filter(regex='ccECP.S').values[2][0])
                try:
                    calcs['ccECP'].append(tmdf[tm].filter(regex='ccECP ').values[2][0])
                except:
                    calcs['ccECP'].append(np.nan)
    
    fig,ax = mpl_init()
    itms = [i for i,tm in enumerate(tms)]
    ax.set_ylim(-0.1,0.3)
    ax.set_xlim(-0.5,9.5)
    ax.axhline(0.0,color='black')
    ax.axhspan(-0.021,0.021,alpha=0.25,color='gray')
    for calc in ['UC','BFD','STU','eCEPP','ccECP.S','ccECP']:
        ax.scatter(itms,calcs[calc],**pointstyles[calc])
        ax.plot(itms,calcs[calc],**linestyles[calc])
        ax.set_xticks(itms)
        ax.set_xticklabels(tms)
    ax.set_ylabel('Discrepancy (eV)')
    ax.legend(ncol=3,loc='lower center',handletextpad=0.1)
    ax.set_title(r'X$^0$  $s^2d^n$  $\rightarrow$  X$^0$  $d^{n+2}$')
    plt.savefig('Is2dn_to_Idn2.pdf')
    plt.show()

def Is2dn_to_IIs1dn():
    df = pd.DataFrame()
    tmdf = {}
    for tm in tms:
        tmdf[tm] = pd.read_csv(tm+'.dat',skipinitialspace=True,delimiter='&')
    
    calcs = {'UC'       : [],
             'BFD'      : [],
             'STU'    : [],
             'eCEPP'    : [],
             'ccECP.S': [],
             'ccECP':[]}
    for tm in tms:
            if tm == 'Cu':
               calcs['UC'].append(tmdf[tm].filter(regex='UC').values[1][0])
               calcs['BFD'].append(tmdf[tm].filter(regex='BFD').values[1][0])
               calcs['STU'].append(tmdf[tm].filter(regex='STU').values[1][0])
               try:
                   calcs['eCEPP'].append(tmdf[tm].filter(regex='eCEPP').values[1][0])
               except:
                   calcs['eCEPP'].append(np.nan)
               calcs['ccECP.S'].append(tmdf[tm].filter(regex='ccECP.S').values[1][0])
               try:
                   calcs['ccECP'].append(tmdf[tm].filter(regex='ccECP ').values[1][0])
               except:
                   calcs['ccECP'].append(np.nan)
            elif tm == 'Zn':
               calcs['UC'].append(tmdf[tm].filter(regex='UC').values[0][0])
               calcs['BFD'].append(tmdf[tm].filter(regex='BFD').values[0][0])
               calcs['STU'].append(tmdf[tm].filter(regex='STU').values[0][0])
               try:
                   calcs['eCEPP'].append(tmdf[tm].filter(regex='eCEPP').values[0][0])
               except:
                   calcs['eCEPP'].append(np.nan)
               calcs['ccECP.S'].append(tmdf[tm].filter(regex='ccECP.S').values[0][0])
               try:
                   calcs['ccECP'].append(tmdf[tm].filter(regex='ccECP ').values[0][0])
               except:
                   calcs['ccECP'].append(np.nan)
            else:
                calcs['UC'].append(tmdf[tm].filter(regex='UC').values[3][0])
                calcs['BFD'].append(tmdf[tm].filter(regex='BFD').values[3][0])
                calcs['STU'].append(tmdf[tm].filter(regex='STU').values[3][0])
                try:
                    calcs['eCEPP'].append(tmdf[tm].filter(regex='eCEPP').values[3][0])
                except:
                    calcs['eCEPP'].append(np.nan)
                calcs['ccECP.S'].append(tmdf[tm].filter(regex='ccECP.S').values[3][0])
                try:
                    calcs['ccECP'].append(tmdf[tm].filter(regex='ccECP ').values[3][0])
                except:
                    calcs['ccECP'].append(np.nan)
    
    fig,ax = mpl_init()
    itms = [i for i,tm in enumerate(tms)]
    ax.set_ylim(-0.05,0.05)
    ax.set_xlim(-0.5,9.5)
    ax.axhline(0.0,color='black')
    ax.axhspan(-0.021,0.021,alpha=0.25,color='gray')
    for calc in ['UC','BFD','STU','eCEPP','ccECP.S','ccECP']:
        ax.scatter(itms,calcs[calc],**pointstyles[calc])
        ax.plot(itms,calcs[calc],**linestyles[calc])
        ax.set_xticks(itms)
        ax.set_xticklabels(tms)
    ax.set_ylabel('Discrepancy (eV)')
    ax.legend(ncol=3,loc='lower center',handletextpad=0.1)
    ax.set_title(r'X$^0$  $s^2d^n$  $\rightarrow$  X$^{+1}$  $s^1d^{n}$')
    plt.savefig('Is2dn_to_IIs1dn.pdf')
    plt.show()


def Is2dn_to_Ar():
    df = pd.DataFrame()
    tmdf = {}
    for tm in tms:
        tmdf[tm] = pd.read_csv(tm+'.dat',skipinitialspace=True,delimiter='&')
    
    calcs = {'UC'       : [],
             'BFD'      : [],
             'STU'    : [],
             'eCEPP'    : [],
             'ccECP.S': [],
             'ccECP':  []}
    for tm in tms:
                calcs['UC'].append(tmdf[tm].filter(regex='UC').values[-1][0])
                calcs['BFD'].append(tmdf[tm].filter(regex='BFD').values[-1][0])
                calcs['STU'].append(tmdf[tm].filter(regex='STU').values[-1][0])
                try:
                    calcs['eCEPP'].append(tmdf[tm].filter(regex='eCEPP').values[-1][0])
                except:
                    calcs['eCEPP'].append(np.nan)
                calcs['ccECP.S'].append(tmdf[tm].filter(regex='ccECP.S').values[-1][0])
                try:
                    calcs['ccECP'].append(tmdf[tm].filter(regex='ccECP ').values[-1][0])
                except:
                    calcs['ccECP'].append(np.nan)
    
    fig,ax = mpl_init()
    itms = [i for i,tm in enumerate(tms)]
    ax.set_xlim(-0.5,9.5)
    ax.axhline(0.0,color='black')
    ax.axhspan(-0.021,0.021,alpha=0.25,color='gray')
    for calc in ['UC','BFD','STU','eCEPP','ccECP.S','ccECP']:
        ax.scatter(itms,calcs[calc],**pointstyles[calc])
        ax.plot(itms,calcs[calc],**linestyles[calc])
        ax.set_xticks(itms)
        ax.set_xticklabels(tms)
    ax.set_ylabel('Discrepancy (eV)')
    ax.legend(ncol=2,loc='upper left',handletextpad=0.1)
    ax.set_title(r'X$^0$  $s^2d^n$  $\rightarrow$ [Ar]')
    plt.savefig('Is2dn_to_Ar.pdf')
    plt.show()

def mad():
    df = pd.DataFrame()
    tmdf = {}
    for tm in tms:
        tmdf[tm] = pd.read_csv(tm+'.dat',skipinitialspace=True,delimiter='&')
    
    calcs = {'UC'       : [],
             'BFD'      : [],
             'STU'    : [],
             'eCEPP'    : [],
             'ccECP.S': [],
             'ccECP':[]}
    for tm in tms:
           calcs['UC'].append(np.absolute(np.array(tmdf[tm].filter(regex='UC'))).mean())
           calcs['BFD'].append(np.absolute(np.array(tmdf[tm].filter(regex='BFD'))).mean())
           calcs['STU'].append(np.absolute(np.array(tmdf[tm].filter(regex='STU'))).mean())
           calcs['eCEPP'].append(np.absolute(np.array(tmdf[tm].filter(regex='eCEPP'))).mean())
           calcs['ccECP.S'].append(np.absolute(np.array(tmdf[tm].filter(regex='ccECP.S'))).mean())
           calcs['ccECP'].append(np.absolute(np.array(tmdf[tm].filter(regex='ccECP '))).mean())
    
    fig,ax = mpl_init()
    itms = [i for i,tm in enumerate(tms)]
    ax.set_xlim(-0.5,9.5)
    ax.axhline(0.0,color='black')
    ax.axhspan(-0.021,0.021,alpha=0.25,color='gray')
    for calc in ['UC','BFD','STU','eCEPP','ccECP.S','ccECP']:
        ax.scatter(itms,calcs[calc],**pointstyles[calc])
        ax.plot(itms,calcs[calc],**linestyles[calc])
        ax.set_xticks(itms)
        ax.set_xticklabels(tms)
    ax.set_ylabel('Mean Absolute Deviation(eV)')
    ax.legend(ncol=2,loc='upper left',handletextpad=0.1)
    plt.savefig('mad.pdf')
    plt.show()

if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        print('Need to provide which to plot')
        sys.exit()
    elif sys.argv[1] == 'Is2dn_to_Is1dn1':
        Is2dn_to_Is1dn1()
    elif sys.argv[1] == 'Is2dn_to_Idn2':
        Is2dn_to_Idn2()
    elif sys.argv[1] == 'Is2dn_to_IIs1dn':
        Is2dn_to_IIs1dn()
    elif sys.argv[1] == 'Is2dn_to_IIdn1':
        Is2dn_to_IIdn1()
    elif sys.argv[1] == 'Is2dn_to_Ar':
        Is2dn_to_Ar()
    elif sys.argv[1] == 'mad':
        mad()
    else:
        print('Incorrect state to plot')
        sys.exit()
