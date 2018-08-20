***,Calculation of binding energy
memory,512,m
gthresh,twoint=1.0E-12

basis={

include,Ni.pp
include,aug-cc-pwCVTZ-dk.basis

ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825; 
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
s, H , 33.8700000, 5.0950000, 1.1590000, 0.3258000, 0.1027000, 0.0252600
p, H , 1.4070000, 0.3880000, 0.1020000
d, H , 1.0570000, 0.2470000

}

ne    =19
symm  =4
ss    =1

do i=1,20
    z(i) = 1.125 + 0.05*(i-1)
    geometry={
        2
        NiH
        Ni  0.0 0.0 0.0
        H  0.0 0.0 z(i)
    }
    {rhf
     wf,ne,symm,ss
     print,orbitals=3
    }
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t);maxit,100;core}
    ccsd(i)=energy
enddo

geometry={
   1
   Ni
   Ni 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,18,6,2;
 occ,4,1,1,1,1,1,1,0;
 open,1.4,1.7
 sym,1,1,1,3,2
}
A_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
A_ccsd=energy

geometry={
   1
   H
   H 0.0 0.0 0.0
}
{rhf;
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}
B_scf=energy

table,z,scf,ccsd, A_scf,A_ccsd,B_scf !,B_ccsd
save, tz.csv, new


