***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Mn
Mn  0.0 0.0 0.0
}

basis={
ECP,Mn,10,3,0          
6;     !Vf
  1 ,  18.43432244 ,      15.00000000 ;
  2 ,  12.74175213 ,   31301.56494509 ;
  2 ,  11.67410914 ,   -4576.35463180 ;
  2 ,  12.90376156 ,  -26766.73507377 ;
  2 ,   4.97171871 ,      -4.09339906 ;
  3 ,   8.79264819 ,     276.51483655 ;
6;     !Vs-Vf
  2 ,  13.56187871 ,    2771.78238977 ;
  2 ,   9.44812535 ,   12553.69429672 ;
  2 ,  10.76503846 ,    1886.79316638 ;
  2 ,  11.65345594 ,   -9260.55332402 ;
  2 ,   8.48073002 ,   -8943.95003535 ;
  2 ,   6.96707028 ,    1041.73211249 ;
6;     !Vp-Vf
  2 ,  12.71342918 ,  -23181.32761179 ;
  2 ,  18.03174513 ,  111577.22220216 ;
  2 ,  16.68279060 ,  -42399.84416473 ;
  2 ,  13.18867124 ,   16025.79106608 ;
  2 ,  18.42861128 ,  -76264.60573764 ;
  2 ,  12.90928974 ,   14270.47832347 ;
6;     !Vd-Vf
  2 ,   8.13384228 ,    -382.83904013 ;
  2 ,  14.28699222 ,    5676.99013005 ;
  2 ,  11.14406629 ,   35338.03440844 ;
  2 ,  11.37674978 ,  -38881.44458388 ;
  2 ,  18.25818233 ,    3550.66026420 ;
  2 ,  17.73146307 ,   -5317.47975296 ;
include,aug-cc-pwCVTZ-dk.basis
}


include,states.proc

do i=1,13
   if (i.eq.1) then
      Is2d5
   else if (i.eq.2) then
      Is1d6
   else if (i.eq.3) then
      Id7
   else if (i.eq.4) then
      IIs1d5
   else if (i.eq.5) then
      IId6
   else if (i.eq.6) then
      IIId5
   else if (i.eq.7) then
      IVd4
   else if (i.eq.8) then
      Vd3
   else if (i.eq.9) then
      VId2
   else if (i.eq.10) then
      VIId1
   else if (i.eq.11) then
      VIII
   else if (i.eq.12) then
      XIV
   else if (i.eq.13) then
      As2d6
   endif
   scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
