***,Calculation for Be atom, singlet and triplet
memory,512,m
 GTHRESH,THROVL=1.d-10
gthresh,twoint=1.e-12
geometry={
1
Mn
Mn  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCV5Z-dk.basis
}

set,dkroll=1,dkho=10,dkhp=4

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
    {rccsd(t),maxit=100;core,2,1,1,0,1,0,0,0}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
