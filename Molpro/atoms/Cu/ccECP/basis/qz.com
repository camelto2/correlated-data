***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Cu
Cu  0.0 0.0 0.0
}

basis={
ecp,Cu,10,2,0
4
1,31.53811263039421, 19.0
3,31.06925531472077, 599.2241399774899900
2,30.59035868058012, -244.68915484091849
2,14.05141063856731, -1.29349525840180
2
2,12.77235919685435, 66.27560813413336
2,29.35562242596171, 370.71371824960090
2
2,12.52471484867519, 49.76265057089474
2,33.51694543757776, 271.66281028326318
include,aug-cc-pwCVQZ-dk.basis
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
