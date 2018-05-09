***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

basis={
ecp,V,10,2,0;
4;
1,20.2553013762707, 13.000 ;
3,19.5088778400405, 263.318917891519;
2,17.3088758203163,-114.916486604966 ;
2,5.04502199681890,-0.68289799957596;
2;
2,15.4637410000600, 195.609510670332  ;
2,6.10337317130682, 23.2299358975926  ;
2;
2,15.5891849786496, 126.699271677201;
2,5.87628647826524, 15.8646131466216;
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
