***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Ti
Ti  0.0 0.0 0.0
}

basis={
ECP,Ti,10,3,0;
1; 2,1.000000,0.000000; 
2; 2,13.010000,158.241593; 2,5.862000,17.511824; 
2; 2,12.460000,95.235127; 2,5.217000,10.047856; 
2; 2,15.350000,-17.568861; 2,4.980000,-0.587256; 
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
