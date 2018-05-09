***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
geometry={
1
Fe
Fe  0.0 0.0 0.0
}

basis={
ecp,Fe,10,2,0
4;
1,14.4907932225793,  16.0;
3,14.7508039327877,  231.8526915612702;
2,13.5133204150806, -125.7103636456496 ;
2,8.13499951855963,  1.26697878288400;
2;
2,24.6419613851123,  286.3499351469308 ;
2,8.40886788022111,  45.10829177941056;
2;
2,8.27485631235689,  28.52519211262868;
2,23.8323272423734,  181.1354201934640 ;
include,aug-cc-pwCVTZ-dk.basis
}

include,states.proc

do i=1,14
if (i.eq.1) then
    Is2d6
else if (i.eq.2) then
    Is1d7
else if (i.eq.3) then
    Id8
else if (i.eq.4) then
    IIs1d6
else if (i.eq.5) then
    IId7
else if (i.eq.6) then
    IX
else if (i.eq.7) then
    XV
else if (i.eq.8) then
    As2d7
else if (i.eq.9) then
    IIId6
else if (i.eq.10) then
    IVd5
else if (i.eq.11) then
    Vd4
else if (i.eq.12) then
    VId3
else if (i.eq.13) then
    VIId2
else if (i.eq.14) then
    VIIId1
endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=400;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
