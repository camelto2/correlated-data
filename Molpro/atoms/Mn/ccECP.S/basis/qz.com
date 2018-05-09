***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
Mn
Mn  0.0 0.0 0.0
}

basis={
ECP,Mn,10,2,0
4;
1,23.9390798968269, 15.000;
3,22.6487595203966, 359.086198452404;
2,21.8940654317432,-152.940673128244;
2,6.35910495525268,-2.00927518084064;
2;
2,18.5418030129861, 245.531112904643;
2,8.39845964747084, 33.1420229873595;
2;
2,19.3120237305302, 163.210590494950;
2,8.37007765431889, 25.0308813645583;
include,aug-cc-pwCVQZ-dk.basis
}


include,states.proc

do i=12,12
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
      XI
   else if (i.eq.13) then
      XIV
   else if (i.eq.14) then
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
