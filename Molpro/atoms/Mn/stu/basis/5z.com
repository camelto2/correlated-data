***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Mn
Mn  0.0 0.0 0.0
}

basis={
ECP,Mn,10,3,0;
1; 2,1.000000,0.000000; 
2; 2,18.520000,226.430902; 2,8.373000,30.359072; 
2; 2,18.920000,142.154705; 2,8.017000,21.536509; 
2; 2,22.720000,-22.568119; 2,7.640000,-1.205810; 
include,aug-cc-pwCV5Z-dk.basis
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
    {rccsd(t),maxit=400;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
