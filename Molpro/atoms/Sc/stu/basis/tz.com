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
ECP,Sc,10,3,0;
1; 2,1.000000,0.000000; 
2; 2,11.500000,138.538152; 2,5.184000,14.834042; 
2; 2,10.930000,82.458614; 2,4.581000,8.565206; 
2; 2,13.470000,-16.129862; 2,4.375000,-0.534690; 

include,bases/aug-cc-pwCVTZ-DK.basis
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
