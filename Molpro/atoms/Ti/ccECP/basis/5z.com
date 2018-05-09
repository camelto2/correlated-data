***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Ti
Ti  0.0 0.0 0.0
}

basis={
ecp,Ti,10,2,0
4;
1,18.4136620219015, 12.000;
3,15.9229241431747, 220.963944262818;
2,13.6500062313789,-94.2902582468396;
2,5.09555210570440, 0.09791142482269;
2;
2,12.7058061392361, 173.946572359300;
2,6.11178551988263, 18.8376833381235;
2;
2,12.6409192965191, 111.456728820122;
2,5.35437415684267, 11.1770268268982;
include,aug-cc-pwCV5Z-dk.basis
}


include,states.proc

do i=11,11
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
   else if (i.eq.11) then
      VIp5
   end if
   scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
