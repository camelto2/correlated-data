***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12

set,dkroll=1,dkho=10,dkhp=4
basis={
include,aug-cc-pwCVTZ-dk.basis
}

ne    =25
symm  =1
ss    =5

A1=8
B1=3
B2=3
A2=1

!do i=1,21
!    z(i) = 1.0 + 0.05*(i-1)
!    geometry={
!        2
!        Oxygen
!        Cr  0.0 0.0 0.0
!        H  0.0 0.0 z(i)
!    }
!    {rhf
!     wf,ne,symm,ss
!     occ,A1,B1,B2,A2
!     open,7.1,8.1,3.2,3.3,1.4
!     print,orbitals=3
!    }
!    scf(i)=energy
!    _CC_NORM_MAX=2.0
!    {rccsd(t);maxit,100;core,3,1,1,0}
!    ccsd(i)=energy
!enddo

geometry={
   1
   Vanadium
   Cr 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,24,1,6;
 occ,6,2,2,1,2,1,1,0;
 open,4.1,5.1,6.1,1.4,1.6,1.7;
 sym,1,1,1,1,1,3,2
}
Cr_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core,2,1,1,0,1,0,0,0}
Cr_ccsd=energy

!geometry={
!   1
!   Oxygen
!   H 0.0 0.0 0.0
!}
!{rhf;
! wf,1,1,1;
! occ,1,0,0,0,0,0,0,0;
! open,1.1;
!}
!H_scf=energy

table,z,scf,ccsd
save
type,csv
