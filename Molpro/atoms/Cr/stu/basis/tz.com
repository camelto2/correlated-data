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
ECP,Cr,10,3,0;
1; 2,1.000000,0.000000; 
2; 2,16.390000,201.578887; 2,7.402000,24.205741; 
2; 2,16.450000,125.022774; 2,6.962000,16.479066; 
2; 2,19.930000,-20.827421; 2,6.598000,-0.834368; 

include,bases/aug-cc-pwCVTZ-DK.basis
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
