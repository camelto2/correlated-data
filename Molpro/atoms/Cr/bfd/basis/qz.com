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
ecp,Cr,10,2,0;
3;1,2.94337662,14.00000000;3,3.40750349,41.20727267;2,3.33587110,-55.51413840;
1;2,9.14231779,103.26274052;
1;2,7.21220771,45.80124572;

include,bases/aug-cc-pwCVQZ-DK.basis
}

include,ppstates.proc

do i=1,12
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
    else if (i.eq.6) then
        IIId4
    else if (i.eq.7) then
        IVd3
    else if (i.eq.8) then
        Vd2
    else if (i.eq.9) then
        VId1
    else if (i.eq.10) then
        VI
    else if (i.eq.11) then
        XII
    else if (i.eq.12) then
        Is2d5
    else if (i.eq.13) then
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
