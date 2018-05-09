***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
geometry={
1
Ni
Ni  0.0 0.0 0.0
}

basis={
ecp,Ni,10,2,0
4
1,38.19016518708151, 18.0
3,24.03684211260990, 687.4229733674671800
2,20.07919881181531, -173.66167749670311
2,3.50552061477890 ,0.26722388134541
2
2,13.54781166259397, 91.82327253876116
2,27.88162353303155, 332.28045793896922
2
2,6.35311971856395 ,7.34190524720420
2,23.69565989268865, 266.33719342555571
include,aug-cc-pwCVQZ-dk.basis
}

include,states.proc

do i=1,16
    if (i.eq.1) then
        Is2d8
    else if (i.eq.2) then
        Is1d9
    else if (i.eq.3) then
        Idten
    else if (i.eq.4) then
        IIs1d8
    else if (i.eq.5) then
        IId9
    else if (i.eq.6) then
        IIId8
    else if (i.eq.7) then
        IVd7
    else if (i.eq.8) then
        Vd6
    else if (i.eq.9) then
        VId5
    else if (i.eq.10) then
        VIId4
    else if (i.eq.11) then
        VIIId3
    else if (i.eq.12) then
        IXd2
    else if (i.eq.13) then
        Xd1
    else if (i.eq.14) then
        XI
    else if (i.eq.15) then
        XVII
    else if (i.eq.16) then
        As2d9
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
