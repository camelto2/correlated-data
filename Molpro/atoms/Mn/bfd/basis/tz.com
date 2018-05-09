***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Mn
Mn  0.0 0.0 0.0
}

basis={
ecp,Mn,10,2,0;
3;1,3.29524605,15.00000000;3,3.61599152,49.42869068;2,3.57405761,-61.66925169;
1;2,9.99154195,112.85037953;
1;2,7.80925218,49.18832867;
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
