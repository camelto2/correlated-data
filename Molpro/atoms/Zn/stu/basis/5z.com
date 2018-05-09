***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
geometry={
1
Zn
Zn  0.0 0.0 0.0
}

basis={
ECP,Zn,10,4,0;
1; 2,1.000000,0.000000; 
2; 2,34.174001,399.986399; 2,14.456371,85.489750; 
4; 2,39.888683,92.381077; 2,39.655017,184.771176; 2,15.290546,23.002541; 2,14.903524,46.057427; 
4; 2,43.708296,-13.690734; 2,43.698536,-20.543980; 2,15.150718,-1.316154; 2,15.282441,-1.838715; 
2; 2,8.160014,-0.370360; 2,12.228422,-1.062943; 
include,aug-cc-pwCV5Z-dk.basis
}

include,states.proc

do i=1,15
    if (i.eq.1) then
        Is2dten
    else if (i.eq.2) then
        IIs1dten
    else if (i.eq.3) then
        IIs2d9
    else if (i.eq.4) then
        IIIdten
    else if (i.eq.5) then
        IVd9
    else if (i.eq.6) then
        Vd8
    else if (i.eq.7) then
        VId7
    else if (i.eq.8) then
        VIId6
    else if (i.eq.9) then
        VIIId5
    else if (i.eq.10) then
        IXd4
    else if (i.eq.11) then
        Xd3
    else if (i.eq.12) then
        XId2
    else if (i.eq.13) then
        XIId1
    else if (i.eq.14) then
        XIII
    else if (i.eq.15) then
        XIX
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
