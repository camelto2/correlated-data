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
ECP,Cr,10,3,0          
6;     !Vf
  1 ,  13.07675203 ,      14.00000000 ;
  2 ,  15.15807582 ,    1258.15550380 ;
  2 ,   4.62785686 ,     -98.60998187 ;
  2 ,  15.41136599 ,   -6552.46055066 ;
  2 ,  15.38690637 ,    5353.09061557 ;
  3 ,   5.24897308 ,     183.07452839 ;
6;     !Vs-Vf
  2 ,   9.77680844 ,  -91901.20809480 ;
  2 ,   9.95980111 ,   96320.14803227 ;
  2 ,   8.62275214 ,    3928.31359170 ;
  2 ,  12.29288144 ,  -10977.62459544 ;
  2 ,  18.41316592 ,   -1741.60409682 ;
  2 ,  16.38541961 ,    4413.26493033 ;
6;     !Vp-Vf
  2 ,  12.00099996 ,  -22156.17142851 ;
  2 ,  11.46524435 ,   21551.07876111 ;
  2 ,  16.23852226 ,    3703.78784703 ;
  2 ,  18.43861108 ,   -1424.18632323 ;
  2 ,   8.88877941 ,   -1964.93568469 ;
  2 ,   7.52644784 ,     317.50498882 ;
6;     !Vd-Vf
  2 ,  11.10668370 ,   -5435.29666496 ;
  2 ,   8.49801115 ,    7350.69608766 ;
  2 ,  12.28065533 ,    2443.80334995 ;
  2 ,   8.18853540 ,   -5401.76770998 ;
  2 ,  14.34306836 ,    3881.23075486 ;
  2 ,  15.24784181 ,   -2855.87137953 ;

include,bases/aug-cc-pwCV5Z-DK.basis
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
