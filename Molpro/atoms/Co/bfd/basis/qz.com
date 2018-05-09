***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Co
Co  0.0 0.0 0.0
}

basis={
ecp,Co,10,2,0;
3;1,4.18819322,17.00000000;3,4.42968808,71.19928469;2,4.39800669,-77.65278252;
1;2,10.86075441,113.90484511;
1;2,9.05202771,56.10698766;
include,aug-cc-pwCVQZ-dk.basis
}

include,states.proc

do i=1,15
    if (i.eq.1) then
        Is2d7
    else if (i.eq.2) then
        Is1d8
    else if (i.eq.3) then
        Id9
    else if (i.eq.4) then
        IIs1d7
    else if (i.eq.5) then
        IId8
    else if (i.eq.6) then
        IIId7
    else if (i.eq.7) then
        IVd6
    else if (i.eq.8) then
        Vd5
    else if (i.eq.9) then
        VId4
    else if (i.eq.10) then
        VIId3
    else if (i.eq.11) then
        VIIId2
    else if (i.eq.12) then
        IXd1
    else if (i.eq.13) then
        X
    else if (i.eq.14) then
        XVI
    else if (i.eq.15) then
        As2d8
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
