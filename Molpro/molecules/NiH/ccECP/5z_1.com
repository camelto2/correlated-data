***,Calculation of binding energy
memory,512,m
gthresh,twoint=1.0E-12

basis={

include,Ni.pp
include,aug-cc-pwCV5Z-dk.basis

ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825; 
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
s, H , 402.0000000, 60.2400000, 13.7300000, 3.9050000, 1.2830000, 0.4655000, 0.1811000, 0.0727900, 0.0207000
p, H , 4.5160000, 1.7120000, 0.6490000, 0.2460000, 0.0744000
d, H , 2.9500000, 1.2060000, 0.4930000, 0.1560000
f, H , 2.5060000, 0.8750000, 0.2740000
g, H , 2.3580000, 0.5430000
}

ne    =19
symm  =4
ss    =1

do i=1,10
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
save, 5z_1.csv, new
