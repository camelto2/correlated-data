***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
geometry={
1
Ni
Ni  0.0 0.0 0.0
}

basis={
ecp,Ni,10,2,0;
3;1,4.22878924,18.00000000;3,4.46202418,76.11820629;2,4.44960456,-82.85330412;
1;2,11.62700064,120.84003628;
1;2,9.57327085,58.54148726;
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