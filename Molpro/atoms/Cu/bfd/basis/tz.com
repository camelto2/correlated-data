***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Cu
Cu  0.0 0.0 0.0
}

basis={
ecp,Cu,10,2,0;
3;1,6.25149628,19.00000000;3,6.72725326,118.77842940;2,6.61024592,-105.89982403;
1;2,12.36568715,127.35069424;
1;2,11.16072939,71.22984900;
include,aug-cc-pwCVTZ-dk.basis
}

include,states.proc

do i=1,16
    if (i.eq.1) then
        Is2d9
    else if (i.eq.2) then
        Is1dten
    else if (i.eq.3) then
        IIs1d9
    else if (i.eq.4) then
        IIdten
    else if (i.eq.5) then
        IIId9
    else if (i.eq.6) then
        IVd8
    else if (i.eq.7) then
        Vd7
    else if (i.eq.8) then
        VId6
    else if (i.eq.9) then
        VIId5
    else if (i.eq.10) then
        VIIId4
    else if (i.eq.11) then
        IXd3
    else if (i.eq.12) then
        Xd2
    else if (i.eq.13) then
        XId1
    else if (i.eq.14) then
        XII
    else if (i.eq.15) then
        XVIII
    else if (i.eq.16) then
        As2dten
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
