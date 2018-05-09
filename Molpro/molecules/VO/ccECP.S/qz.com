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
include,aug-cc-pwCVQZ-dk.basis
 ecp,O,2,1,0;
 3; 1,12.3099743608243,6; 3,14.7696229283522,73.8598461649458; 2,13.7141954216007,-47.8760050413118;
 1; 2,13.6551200129796,85.8640652580159;
include,O-aug-cc-CVQZ.basis
}

ne    =19
symm  =4
ss    =3

A1=6
B1=2
B2=2
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
     open,5.1,6.1,1.4
     sym,1,1,1,1,1,2,1
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

table,z,scf,ccsd
save
type,csv
