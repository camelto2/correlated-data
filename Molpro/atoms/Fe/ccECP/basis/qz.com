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
4
1,2.32209171361153e+01, 16.000
3,2.35471467972070e+01, 371.5346741778448
2,2.34725634460779e+01,-1.81226034452083e+02
2,9.85238815041471e+00,-2.37305236140397e+00
2
2,2.22106269743296e+01, 2.77500325474967e+02
2,9.51515800919325e+00, 4.62049558527338e+01
2
2,2.45700087184633e+01, 1.94998750566171e+02
2,8.86648776669055e+00, 3.16794513291187e+01
include,aug-cc-pwCVQZ-dk.basis
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
