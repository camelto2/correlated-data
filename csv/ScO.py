#! /usr/bin/env python

import sys,os
import numpy as np
import pandas as pd
from scipy.optimize import curve_fit
import uncertainties
from uncertainties import ufloat
from uncertainties import umath
from uncertainties import unumpy as unp
import matplotlib.pyplot as plt
import matplotlib as mpl
import string


#~~~~~~~~~~~~~~input~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
name='ScO_5z'		# Name of csv file
ri=1.4			# Initial bond length (Angs)
rf=2.0			# Final bond length (Angs)
m1=44.955912		# Mass of first atom from PT (Scandium)
#m1=47.867		# Mass of first atom from PT (Titanium)

m2=15.9994		# Mass of second atom from PT (Oxygen)
#m2=1.00794		# Mass of second atom from PT (Hydrogen)

#~~~~~~~~~~~~~~~constants~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

toev=27.21138602
bohr=0.52917721067	# Bohr to Angs
amu=1822.888486		#amu to au
tocm=2.194746313702e5
mu=m1*m2/(m1+m2)
wconv=tocm*bohr/np.sqrt(amu)
#print wconv

#~~~~~~~Functions~~~~~~~~~~~~~~~~~~~~~~~~
def morse(x,D,a,re):
        y=D*(np.exp(-2*a*(x-re))-2*np.exp(-a*(x-re)))
        return y

umorse=uncertainties.wrap(morse)

def omega(D,a,mu):
	y=umath.sqrt(2*(a**2)*D/mu)
	return y

def rdis(re, a):	#Find dissaciation bond length
	y=re-unp.log(2)/a
	return y


class ShorthandFormatter(string.Formatter):
    def format_field(self, value, format_spec):
        if isinstance(value, uncertainties.UFloat):
            return value.format(format_spec+'S')  # Shorthand option added
        # Special formatting for other types can be added here (floats, etc.)
        else:
            # Usual formatting:
            return super(ShorthandFormatter, self).format_field(
                value, format_spec)
frmtr = ShorthandFormatter()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df = pd.read_csv("%s.csv" % name)	#,delim_whitespace=True)
#print df.head()
#print df.columns
x1=int(np.where(df['r'] == ri)[0])
x2=int(np.where(df['r'] == rf)[0])+1
#print x1
#print x2
#print df.iloc[x1:x2]

blatex=pd.DataFrame(columns=df.columns,  index=["$D_e$(eV)", "$r_e$(\AA)", "$\omega_e$(cm$^{-1}$)"]) #, "$D_{diss}$(heV)"])
del blatex['r']
#print blatex

# Fit the curve
for column in df:
	if column == "r":
		continue
	else:
		#print column	
		initial=[df[column].iloc[(x1+x2)/2], 1.75, df['r'].loc[(x1+x2)/2] ]
		popt_m, pcov_m = curve_fit(morse, df['r'].iloc[x1:x2], df[column].iloc[x1:x2], p0=initial)
		std=np.sqrt(np.diag(pcov_m))
		#print "popt_m:"
		#print popt_m
		#print "STD:"
		#print std
		D=ufloat(popt_m[0], std[0])
		#print D
		a=ufloat(popt_m[1], std[1])
		#print a
		re=ufloat(popt_m[2], std[2])
		#print re
		w=omega(D,a,mu)
		#print w

		if column=='ae':
			ae_D=D
			ae_re=re
			ae_w=w
			#ae_rdis=rdis(re,a)
			#print ae_rdis
			#ae_Ddis=umorse(ae_rdis,D,a,re)
			blatex[column].iloc[0]=frmtr.format("{0:.1u}", D*toev)  # 1-digit uncertainty
			blatex[column].iloc[1]=frmtr.format("{0:.1u}", re) 
			blatex[column].iloc[2]=frmtr.format("{0:.2u}", w*wconv)  
			#blatex[column].iloc[3]=frmtr.format("{0:.1u}", (ae_Ddis)*toev*100)
			#blatex[column].iloc[3]=0.0

		else:
			blatex[column].iloc[0]=frmtr.format("{0:.1u}", (D-ae_D)*toev)
			blatex[column].iloc[1]=frmtr.format("{0:.1u}", re-ae_re)
			blatex[column].iloc[2]=frmtr.format("{0:.2u}", (w-ae_w)*wconv)
			#blatex[column].iloc[3]=frmtr.format("{0:.3u}", (umorse(ae_rdis,D,a,re)-ae_Ddis)*toev*100)
		
#print blatex

#~~~~~~~Get rid of some ECPs and export to Latex~~~~~~

##~~~~~~~~~~~~~Oxides~~~~~~~~~~~~~~~~~~
blatex=blatex[['ae','uc','bfd-bfd','stu87-stu87','tn17-tn17','g43-lm','g73-lm' ]]
blatex=blatex.rename(index=str, columns={"ae": "AE", "uc": "UC", "bfd-bfd": "BFD", "stu87-stu87": "STU", "tn17-tn17": "eCEPP"}) #, "g43-lm": "Our ccECP"})


#~~~~~~~~~~~~~~Hydrides~~~~~~~~~~~~~~~~~~~~~~~
#blatex=blatex[['ae','uc','bfd','stu87','tn17','g43', 'g73']]
#blatex=blatex.rename(index=str, columns={"ae": "AE", "uc": "UC", "bfd": "BFD", "stu87": "STU", "tn17": "eCEPP"}) #, "g43": "Our ccECP"})



blatex.insert(loc=0, column='Exp.', value=0)
blatex=blatex.transpose()
print blatex.to_latex(escape=False)





