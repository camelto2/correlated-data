***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,O-aug-cc-CVQZ.basis
}

geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 open,1.3,1.5;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy
