***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
V
V  0.0 0.0 0.0
}

basis={
ecp,V,10,2,0;
3;1,2.16361754,13.00000000;3,4.07901780,28.12702797;2,3.21436396,-48.27656329;
1;2,8.44326050,96.23226580;
1;2,6.53136059,41.58043539;
include,aug-cc-pwCVTZ-dk.basis
}


include,states.proc

do i=1,11
    if (i.eq.1) then
        Is2d3
    else if (i.eq.2) then
        Is1d4
    else if (i.eq.3) then
        Id5
    else if (i.eq.4) then
        IIs1d3
    else if (i.eq.5) then
        IId4
    else if (i.eq.6) then
        VI
    else if (i.eq.7) then
        XII
    else if (i.eq.8) then
        As2d4
    else if (i.eq.9) then
        IIId3
    else if (i.eq.10) then
        IVd2
    else if (i.eq.11) then
        Vd1
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
