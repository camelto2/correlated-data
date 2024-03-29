***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
geometry={
1
Zn
Zn  0.0 0.0 0.0
}

basis={
ecp,Zn,10,2,0;
3;1,5.25282726,20.00000000;3,5.85433298,105.05654526;2,5.80452897,-105.08806248;
1;2,12.52174964,123.87006927;
1;2,11.56019052,72.33499364;
include,aug-cc-pwCVQZ-dk.basis
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
