***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Fe
Fe  0.0 0.0 0.0
}

basis={
ecp,Fe,10,2,0;
3;1,3.72075632,16.00000000;3,3.92321272,59.53210107;2,3.89595440,-68.75847841;
1;2,10.42343546,112.92561163;
1;2,8.41664076,52.55882759;
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
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
