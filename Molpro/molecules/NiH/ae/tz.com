***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,aug-cc-pwCVTZ-dk.basis
}

ne    =29
symm  =4
ss    =1

do i=1,1
    z(i) = 1.1 + 0.05*(i-1)
    geometry={
        2
        Oxygen
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
   Vanadium
   Ni 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,28,6,2;
 occ,6,2,2,1,2,1,1,0;
 open,1.4,1.7
 sym,1,1,1,1,1,3,2
}
Ni_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Ni_ccsd=energy

geometry={
   1
   Oxygen
   H 0.0 0.0 0.0
}
{rhf;
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}
H_scf=energy

table,z,scf,ccsd
save
type,csv
