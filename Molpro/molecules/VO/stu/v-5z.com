***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

basis={
ECP,V,10,3,0;
1; 2,1.000000,0.000000; 
2; 2,14.490000,178.447971; 2,6.524000,19.831375; 
2; 2,14.300000,109.529763; 2,6.021000,12.570310; 
2; 2,17.480000,-19.219657; 2,5.709000,-0.642775; 
include,aug-cc-pwCV5Z-dk.basis
}
geometry={
   1
   Vanadium
   V 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,13,6,3;
 occ,4,1,1,0,1,1,0,0;
 open,3.1,4.1,1.6;
 sym,1,1,1,3,2
}
V_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
V_ccsd=energy
