***,Calculation of binding energy
memory,512,m
gthresh,twoint=1.0E-12

basis={

include,Ni.pp
include,aug-cc-pwCVQZ-dk.basis

ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825; 
1,   21.24359508259891 ,       1.00000000000000;
3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
s, H , 82.64, 12.41, 2.824, 0.7977, 0.2581, 0.08989, 0.0236300
p, H , 2.292, 0.838, 0.292, 0.0848000
d, H , 2.062, 0.662, 0.1900000
f, H , 1.397, 0.3600000
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
save, qz.csv, new
