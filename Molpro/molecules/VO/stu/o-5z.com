***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

basis={
ECP,O,2,3,0;
1; 2,1.000000,0.000000; 
1; 2,12.968600,73.608600; 
1; 2,15.243000,-3.917200; 
1; 2,9.617200,-0.655900; 
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
