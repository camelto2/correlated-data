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
ECP,Sc,10,3,0           
6;     !Vf
  1 ,   8.68432435 ,      11.00000000 ;
  2 ,  12.96081047 ,    1293.12711495 ;
  2 ,   3.42726018 ,     -59.34807006 ;
  2 ,  13.92649869 ,   -6626.33658022 ;
  2 ,  14.11355210 ,    5365.41708240 ;
  3 ,   3.87834215 ,      95.52756785 ;
6;     !Vs-Vf
  2 ,  14.11432286 ,   -1492.86349923 ;
  2 ,   4.42835597 ,    1499.37242000 ;
  2 ,   7.46045566 ,    1088.20049735 ;
  2 ,  10.23533878 ,   -1981.91696501 ;
  2 ,   4.52489587 ,   -1710.45115474 ;
  2 ,  13.07885945 ,    2625.43810581 ;
6;     !Vp-Vf
  2 ,   9.83997641 ,   -2070.12504374 ;
  2 ,   7.25072068 ,    5801.02991534 ;
  2 ,  11.81974746 ,    1554.97375552 ;
  2 ,  14.07433272 ,    -853.69420879 ;
  2 ,   7.08460322 ,   -4878.01776292 ;
  2 ,  14.07166426 ,     462.12967346 ;
6;     !Vd-Vf
  2 ,  11.29849449 ,    -570.27953430 ;
  2 ,   5.72119848 ,    -549.43824610 ;
  2 ,   6.53234086 ,    1672.92599442 ;
  2 ,   8.11431019 ,   -2704.80905453 ;
  2 ,   9.95728280 ,    4666.19773963 ;
  2 ,  10.24029445 ,   -2524.96335631 ;

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
