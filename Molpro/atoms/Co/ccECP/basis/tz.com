***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
geometry={
1
Co
Co  0.0 0.0 0.0
}

basis={
ecp,Co,10,2,0
4
1,25.00124115981202, 17.0
3,22.83490096546710, 425.0210997168043400
2,23.47468155934268, -195.48211282934741
2,10.33794825313753, -2.81572866482791
2
2,23.41427030715358, 271.77708486766420
2,10.76931694175074, 54.26461121615731
2
2,25.47446316631093, 201.53430745305457
2,10.68404901015315, 38.99231927238777
include,aug-cc-pwCVTZ-dk.basis
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
