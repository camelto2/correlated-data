***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

basis={
ECP,V,10,3,0;
1; 2,1.000000,0.000000; 
2; 2,14.490000,178.447971; 2,6.524000,19.831375; 
2; 2,14.300000,109.529763; 2,6.021000,12.570310; 
2; 2,17.480000,-19.219657; 2,5.709000,-0.642775; 
include,aug-cc-pwCVQZ-dk.basis
ECP,O,2,3,0;
1; 2,1.000000,0.000000; 
1; 2,12.968600,73.608600; 
1; 2,15.243000,-3.917200; 
1; 2,9.617200,-0.655900; 
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

basis={
ECP,V,10,3,0;
1; 2,1.000000,0.000000; 
2; 2,14.490000,178.447971; 2,6.524000,19.831375; 
2; 2,14.300000,109.529763; 2,6.021000,12.570310; 
2; 2,17.480000,-19.219657; 2,5.709000,-0.642775; 
include,aug-cc-pwCVQZ-dk.basis
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

basis={
ECP,O,2,3,0;
1; 2,1.000000,0.000000; 
1; 2,12.968600,73.608600; 
1; 2,15.243000,-3.917200; 
1; 2,9.617200,-0.655900; 
include,O-aug-cc-CVQZ.basis
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

table,z,scf,ccsd
save
type,csv
