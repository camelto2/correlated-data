***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Mn
Mn  0.0 0.0 0.0
}

basis={
ecp,Mn,10,2,0
4
1,2.19193743333594e+01, 15.000
3,2.13552712793287e+01, 328.79061500039097
2,2.12716265399047e+01,-1.62051728053531e+02
2,7.93913962228987e+00,-1.82694272662286e+00
2
2,1.89204496586198e+01, 2.44668704927046e+02
2,8.32764757132573e+00, 3.35416271719809e+01
2
2,2.01734702034533e+01, 1.62350336855005e+02
2,7.80047874086443e+00, 2.41795669512888e+01
include,aug-cc-pwCVQZ-dk.basis
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
