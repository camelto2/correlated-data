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
Cr
Cr  0.0 0.0 0.0
}

basis={
include,bases/aug-cc-pwCVTZ-DK.basis
}


set,dkroll=1,dkho=10,dkhp=4

include,states.proc

do i=1,13
    if (i.eq.1) then
        Is2d4
    else if (i.eq.2) then
        Is1d5
    else if (i.eq.3) then
        Id6
    else if (i.eq.4) then
        IIs1d4
    else if (i.eq.5) then
        IId5
    else if (i.eq.7) then
        IIId4
    else if (i.eq.8) then
        IVd3
    else if (i.eq.9) then
        Vd2
    else if (i.eq.10) then
        VId1
    else if (i.eq.11) then
        VI
    else if (i.eq.12) then
        XII
    else if (i.eq.13) then
        Is2d5
    else if (i.eq.14) then
        As2d4
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
