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
4;
1,27.41132561274041, 17.0;
3,26.76075806161875, 465.9925354165869700;
2,20.48032022247462, -134.54809603014158;
2,7.21322693163409 , 0.88774464607555;
2;
2,10.65613958088872, 54.09267691380918;
2,23.84293737028188, 306.74716360116275;
2;
2,10.19977264347746, 39.08918711290565;
2,26.42655542083392, 208.27588660556384;
include,aug-cc-pwCV5Z-dk.basis
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
