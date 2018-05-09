***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Cu
Cu  0.0 0.0 0.0
}

basis={
ECP,Cu,10,3,0          
6;     !Vf
  1 ,  19.87662576 ,      19.00000000 ;
  2 ,  18.71397328 ,   13322.83154110 ;
  2 ,   8.24597653 ,    -143.81933419 ;
  2 ,  17.99726398 ,   -6835.89401414 ;
  2 ,  19.50653533 ,   -6413.73731394 ;
  3 ,   9.35936389 ,     377.65588950 ;
6;     !Vs-Vf
  2 ,  12.04327682 ,  217421.85846016 ;
  2 ,  11.98352277 , -215987.47192743 ;
  2 ,   9.67744501 ,    1647.53099822 ;
  2 ,  17.58068730 ,   -5124.79596488 ;
  2 ,  17.50925880 ,    -963.56912390 ;
  2 ,  19.80724162 ,    3071.81011765 ;
6;     !Vp-Vf
  2 ,  15.48559732 ,  189560.54470794 ;
  2 ,  15.42430413 , -181115.65838446 ;
  2 ,  17.81980355 ,   -1937.67548293 ;
  2 ,  17.69074392 ,   -2335.92086442 ;
  2 ,  17.98867265 ,   -8634.52846732 ;
  2 ,  19.82460345 ,    4504.58524733 ;
6;     !Vd-Vf
  2 ,  10.91448054 ,   -5224.34215851 ;
  2 ,  14.69969344 ,   -3653.65459704 ;
  2 ,  11.52370333 ,    8159.25189768 ;
  2 ,  19.81153965 ,   -2763.94279097 ;
  2 ,  18.01979820 ,    6020.80732635 ;
  2 ,  14.46480052 ,   -2560.14492979 ;
include,aug-cc-pwCVQZ-dk.basis
}

include,states.proc

do i=1,16
    if (i.eq.1) then
        Is2d9
    else if (i.eq.2) then
        Is1dten
    else if (i.eq.3) then
        IIs1d9
    else if (i.eq.4) then
        IIdten
    else if (i.eq.5) then
        IIId9
    else if (i.eq.6) then
        IVd8
    else if (i.eq.7) then
        Vd7
    else if (i.eq.8) then
        VId6
    else if (i.eq.9) then
        VIId5
    else if (i.eq.10) then
        VIIId4
    else if (i.eq.11) then
        IXd3
    else if (i.eq.12) then
        Xd2
    else if (i.eq.13) then
        XId1
    else if (i.eq.14) then
        XII
    else if (i.eq.15) then
        XVIII
    else if (i.eq.16) then
        As2dten
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
