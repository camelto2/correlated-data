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
ECP, sc, 10, 2 ;
4;
1,16.0239438834255, 11.000;
3,14.0864740368760, 176.263382717680;
2,11.9398512180529,-83.6814959989029;
2,3.69440111537148, 0.43282764732009;
2;
2,11.4946654139250, 153.965301756312;
2,5.01031394189373, 14.9367565765582;
2;
2,11.4512673043638, 97.2172569045336;
2,4.76798446255521, 10.8170401843697;

include,bases/aug-cc-pwCV5Z-DK.basis
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
