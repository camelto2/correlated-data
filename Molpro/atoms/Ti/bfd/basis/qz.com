***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Ti
Ti  0.0 0.0 0.0
}

basis={
ecp,Ti,10,2,0;
3;1,1.85755224,12.00000000;3,3.30638246,22.29062683;2,2.70879079,-41.26280518;
1;2,8.03040157,96.94231089;
1;2,5.93291405,38.01641313;
include,aug-cc-pwCVQZ-dk.basis
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
