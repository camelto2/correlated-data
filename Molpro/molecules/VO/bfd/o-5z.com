***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

basis={
ecp,O,2,1,0;
3;1,9.29793903,6.00000000;3,8.86492204,55.78763416;2,8.62925665,-38.81978498;
1;2,8.71924452,38.41914135;
include,O-aug-cc-CV5Z.basis
}

geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,6,7,2;
 occ,1,1,1,0,1,0,0,0;
 open,1.3,1.5;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
O_ccsd=energy
