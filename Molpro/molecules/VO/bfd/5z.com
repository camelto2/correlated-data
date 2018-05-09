***,Calculation for Be atom, singlet and triplet
memory,2500,m
gthresh,twoint=1.0E-12

basis={
ecp,V,10,2,0;
3;1,2.16361754,13.00000000;3,4.07901780,28.12702797;2,3.21436396,-48.27656329;
1;2,8.44326050,96.23226580;
1;2,6.53136059,41.58043539;
include,aug-cc-pwCV5Z-dk.basis
ecp,O,2,1,0;
3;1,9.29793903,6.00000000;3,8.86492204,55.78763416;2,8.62925665,-38.81978498;
1;2,8.71924452,38.41914135;
include,O-aug-cc-CV5Z.basis
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
ecp,V,10,2,0;
3;1,2.16361754,13.00000000;3,4.07901780,28.12702797;2,3.21436396,-48.27656329;
1;2,8.44326050,96.23226580;
1;2,6.53136059,41.58043539;
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

table,z,scf,ccsd
save
type,csv
