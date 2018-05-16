***,Calculation for Be atom, singlet and triplet
memory,512,m


! s  0 x^2,y^2,z^2
! p  1 x
! p -1 y
! d -2 xy
! p  0 z
! d  1 xz
! d -1 yz
! f -2 xyz

print,orbitals=2

gparam,NOBUFF
gthresh,twoint=1.e-12
geometry={
1
Sc
Sc  0.0 0.0 0.0
}

basis={
ecp,Sc,10,2,0;
3;1,1.64916555,11.00000000;3,3.06833288,18.14082106;2,2.41985389,-35.19310566;
1;2,7.60319353,97.62913482;
1;2,5.31121835,33.97033635;

include,bases/aug-cc-pwCVQZ-DK.basis
}

include,ppstates.proc

do i=1,9
    if (i.eq.1) then
        Is2d1
    else if (i.eq.2) then
        Is1d2
    else if (i.eq.3) then
        Id3
    else if (i.eq.4) then
        IIs1d1
    else if (i.eq.5) then
        IId2
    else if (i.eq.6) then
        IIId1
    else if (i.eq.7) then
        VI
    else if (i.eq.8) then
        XII
    else if (i.eq.9) then
        Is2d2
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
