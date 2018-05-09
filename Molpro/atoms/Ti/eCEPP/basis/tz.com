***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Ti
Ti  0.0 0.0 0.0
}

basis={
ECP,Ti,10,3,0           
6;     !Vf
  1 ,   8.52499277 ,      12.00000000 ;
  2 ,  15.24334130 ,    2048.39512837 ;
  2 ,   9.82605516 ,    -812.71625987 ;
  2 ,  13.73638629 ,   -6663.62886396 ;
  2 ,  12.65450510 ,    5396.93874773 ;
  3 ,   7.54790686 ,     102.29991323 ;
6;     !Vs-Vf
  2 ,   6.07854372 ,   -5355.67455847 ;
  2 ,   6.60870356 ,    4802.76911085 ;
  2 ,   5.40803832 ,    1304.66429039 ;
  2 ,  10.43037595 ,   -1133.61681175 ;
  2 ,  18.40796253 ,    -258.77562194 ;
  2 ,  15.38428800 ,     672.53886697 ;
6;     !Vp-Vf
  2 ,   9.60319864 ,   56981.17339652 ;
  2 ,   9.66270511 ,  -57002.97844363 ;
  2 ,  15.06515908 ,    1335.72576887 ;
  2 ,  16.36599976 ,    -813.49634683 ;
  2 ,   7.86420177 ,    -720.45341501 ;
  2 ,  10.25452653 ,     239.69852194 ;
6;     !Vd-Vf
  2 ,  10.56650824 ,   -4262.72074057 ;
  2 ,   2.71368379 ,      -1.34753473 ;
  2 ,   9.33780917 ,    1569.82864567 ;
  2 ,  31.60560687 ,      -0.45387550 ;
  2 ,  12.28030141 ,    5034.44351544 ;
  2 ,  13.36770170 ,   -2350.67846378 ;
include,aug-cc-pwCVTZ-dk.basis
}


include,states.proc

do i=1,10
   if (i.eq.1) then
      Is2d2
   else if (i.eq.2) then
      Is1d3
   else if (i.eq.3) then
      Id4
   else if (i.eq.4) then
      IIs1d2
   else if (i.eq.5) then
      IId3
   else if (i.eq.6) then
      IIId2
   else if (i.eq.7) then
      IVd1
   else if (i.eq.8) then
      V
   else if (i.eq.9) then
      XI
   else if (i.eq.10) then
      As2d3
   end if
   scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
