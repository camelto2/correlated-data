***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,aug-cc-pwCVQZ-dk.basis
include,O-aug-cc-CVQZ.basis
}

ne    =31
symm  =4
ss    =3

A1=10
B1=3
B2=3
A2=1

do i=1,21
    z(i) = 1.16 + 0.05*(i-1)
    geometry={
        2
        Oxygen
        V  0.0 0.0 0.0
        O  0.0 0.0 z(i)
    }
    {rhf
     wf,ne,symm,ss
     occ,A1,B1,B2,A2
     open,9.1,10.1,1.4
     sym,1,1,1,1,1,1,1,1,1,2,1
     print,orbitals=3
    }
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t);maxit,100;core,4,1,1,0}
    ccsd(i)=energy
enddo

geometry={
   1
   Vanadium
   V 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,23,6,3;
 occ,6,2,2,0,2,1,0,0;
 open,5.1,6.1,1.6;
 sym,1,1,1,1,1,3,2
}
V_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,2,1,1,0,1,0,0,0}
V_ccsd=energy

geometry={
   1
   Oxygen
   O 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,8,7,2;
 occ,2,1,1,0,1,0,0,0;
 open,1.3,1.5;
}
O_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,1,0,0,0,0,0,0,0}
O_ccsd=energy

table,z,scf,ccsd
save
type,csv
