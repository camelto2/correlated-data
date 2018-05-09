***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
V
V  0.0 0.0 0.0
}

basis={
ECP,V,10,3,0            
6;     !Vf
  1 ,   8.85341849 ,      13.00000000 ;
  2 ,  14.12393489 ,    1867.96836466 ;
  2 ,  10.01469125 ,    -417.21852960 ;
  2 ,  16.87739786 ,   -6735.41034163 ;
  2 ,  17.42661229 ,    5248.95199150 ;
  3 ,   8.14766139 ,     115.09444037 ;
6;     !Vs-Vf
  2 ,  10.17161428 ,    8429.89768085 ;
  2 ,   6.62108601 ,   -4738.08694540 ;
  2 ,   6.44072060 ,    3874.69004628 ;
  2 ,  11.26222343 ,   -9817.80452096 ;
  2 ,  19.82459033 ,    -286.16022228 ;
  2 ,  14.35299938 ,    2571.80634504 ;
6;     !Vp-Vf
  2 ,  10.25117807 ,   40641.17869487 ;
  2 ,  10.49106006 ,  -41559.00487832 ;
  2 ,  13.78691880 ,    3357.33248976 ;
  2 ,  16.29479305 ,    -896.47755921 ;
  2 ,   7.79003518 ,   -1904.45864373 ;
  2 ,   6.62830213 ,     382.37577830 ;
6;     !Vd-Vf
  2 ,   8.60147700 ,    4615.05527413 ;
  2 ,  10.66674565 ,   -3671.60281242 ;
  2 ,  15.19026557 ,    4480.50015686 ;
  2 ,   8.06189603 ,   -2591.12632756 ;
  2 ,  19.82232597 ,    2587.18683714 ;
  2 ,  18.22318105 ,   -5431.92186158 ;
include,aug-cc-pwCV5Z-dk.basis
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
