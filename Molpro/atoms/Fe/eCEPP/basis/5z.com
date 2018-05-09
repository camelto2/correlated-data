***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Fe
Fe  0.0 0.0 0.0
}

basis={
ECP,Fe,10,3,0          
6;     !Vf
  1 ,  16.90683491 ,      16.00000000 ;
  2 ,  18.40258134 ,   26847.81569895 ;
  2 ,   6.30300831 ,    -133.54888707 ;
  2 ,  18.42848726 ,  -26765.40492320 ;
  2 ,  18.43432023 ,       1.00742417 ;
  3 ,   7.01300654 ,     270.50935856 ;
6;     !Vs-Vf
  2 ,   9.62463353 ,   20308.89993480 ;
  2 ,   9.12709550 ,  -17595.21707731 ;
  2 ,   7.54163840 ,    1884.69012383 ;
  2 ,  12.70900949 ,   -4483.50209856 ;
  2 ,   8.14863339 ,   -1094.38597968 ;
  2 ,  16.27611739 ,    1032.95376659 ;
6;     !Vp-Vf
  2 ,  11.36514719 ,    -905.00711112 ;
  2 ,  14.56762424 ,   34640.93582590 ;
  2 ,  15.05861359 ,  -42299.94223895 ;
  2 ,  17.41337089 ,   10633.68808757 ;
  2 ,  18.37467520 ,   -5844.19723669 ;
  2 ,  17.04734437 ,    3803.80414779 ;
6;     !Vd-Vf
  2 ,  10.13935738 ,  -11031.18647055 ;
  2 ,  13.45796076 ,   16711.37502047 ;
  2 ,  10.97387824 ,   37989.95033676 ;
  2 ,  11.92919033 ,  -41782.92514683 ;
  2 ,  17.71230120 ,    3812.58339812 ;
  2 ,  17.32108913 ,   -5718.00854971 ;
include,aug-cc-pwCV5Z-dk.basis
}

include,states.proc

do i=1,14
if (i.eq.1) then
    Is2d6
else if (i.eq.2) then
    Is1d7
else if (i.eq.3) then
    Id8
else if (i.eq.4) then
    IIs1d6
else if (i.eq.5) then
    IId7
else if (i.eq.6) then
    IX
else if (i.eq.7) then
    XV
else if (i.eq.8) then
    As2d7
else if (i.eq.9) then
    IIId6
else if (i.eq.10) then
    IVd5
else if (i.eq.11) then
    Vd4
else if (i.eq.12) then
    VId3
else if (i.eq.13) then
    VIId2
else if (i.eq.14) then
    VIIId1
endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
