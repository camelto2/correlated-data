***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
V
V  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCV5Z-dk.basis
}

set,dkroll=1,dkho=10,dkhp=4

!   GANI list of states 
!   0  V(0)3d34s2(a4F)
!   1  V(0)3d4(5D)4s(a6D)
!   2  V(0)3d5(a6S)
!   3  V(1)3d4(a5D)
!   4  V(1)3d3(4F)4s(a5F)
!   5  V(2)3d3(a4F)
!   6  V(0)3d3(4F)4s4p(3P)(z6G)
!   7  V(0)3d4(5D)4s(a4D)
!   8  V(0)3d34s2(a4P)
!   9  V(0)3d34s2(a2G)
!   10 V(1)3d3(4F)4s(a3F)
!   11 V(1)3d4(a3P2)
!   12 V(1)3d4(a3H)
!   13 V(2)3d3(a4P)
!   14 V(2)3d3(a2G)
!   15 V(3)3p63d2(3F)
!   16 V(4)3p63d(2D)
!   17 V(5)3s23p6(1S)
!   18 V(11)3s2(1S)

!!! cannot run 7
!!! running 8, but looks degenerate with 0
!!! cannot run 10

!gani 0  1  2  3  4  5  6  8  9 12 13 14 15 16 17 18
! i   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
ne =[23,23,23,22,22,21,23,23,23,22,21,21,20,19,18,12]
sym=[ 6, 4, 1, 4, 6, 6, 5, 7, 1, 6, 4, 1, 6, 1, 1, 1]
ss =[ 3, 5, 5, 4, 4, 3, 5, 3, 1, 2, 3, 1, 2, 1, 0, 0]

Ag =[ 6, 6, 5, 5, 6, 5, 6, 6, 6, 5, 4, 4, 4, 4, 3, 3] ! quadratic
B3u=[ 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1] ! x
B2u=[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1] ! y
B1g=[ 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ! xy
B1u=[ 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1] ! z
B2g=[ 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0] ! xz
B3g=[ 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0] ! yz
Au =[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ! xyz

!                                               gani  i
sing_occ=[5.1,6.1,1.6,0,0,0,0,0, \!V(0)3d34s2(a4F) 0  1
4.1,5.1,6.1,1.6,1.7,0,0,0, \!V(0)	3d4(5D)4s(a6D) 1  2 
4.1,5.1,1.4,1.6,1.7,0,0,0, \!V(0) 3d5(a6S)  **     2  3
4.1,5.1,1.6,1.7,0,0,0,0,   \!V(1) 3d4(a5D)  **     3  4
4.1,5.1,6.1,1.6,0,0,0,0,   \!V(1) 3d34s(a5F)       4  5
4.1,5.1,1.6,0,0,0,0,0,     \!V(2) 3d3(a4F)         5  6
4.1,5.1,6.1,3.2,1.6,0,0,0, \!V(0) 3d3(4F)4s4p(z6G) 6  7
5.1,6.1,1.7,0,0,0,0,0,     \!V(0) 3d34s2(a4P)      8  8
6.1,0,0,0,0,0,0,0,         \!V(0) 3d34s2(a2G)      9  9
5.1,1.6,0,0,0,0,0,0,       \!V(1) 3d4(a3H)  **    12 10
4.1,1.6,1.7,0,0,0,0,0,     \!V(2) 3d3(a4P)        13 11
4.1,0,0,0,0,0,0,0,         \!V(2) 3d3(a2G)        14 12
4.1,1.6,0,0,0,0,0,0,       \!V(3) 3s2(3F)         15 13
4.1,0,0,0,0,0,0,0,         \!V(4) 3d(2D)    **    16 14
0,0,0,0,0,0,0,0,           \!V(5) (1S)            17 15
0,0,0,0,0,0,0,0]           \!V(11) (1S)           18 16


i=1
{rhf;
 start,atden
 print,orbitals
 save,4202.2
 wf,ne(i),sym(i),ss(i);
 occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
 open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
}
scf(i) = energy
pop
{rccsd(t),nocheck;maxit,100;core}
ccsd(i)=energy


do i=2,#sym
    if ((i.eq.3).or.(i.eq.4)) then
        {rhf,nitord=1;
         start,4202.2
         rotate,4.1,6.1
         print,orbitals
         wf,ne(i),sym(i),ss(i);
         occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
         open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
        }
    else if ((i.eq.10)) then
        {rhf,nitord=1;
         start,4202.2
         rotate,4.1,5.1
         rotate,5.1,6.1
         print,orbitals
         wf,ne(i),sym(i),ss(i);
         occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
         open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
        }
    else if (i.eq.14) then
        {rhf,nitord=1;
         start,4202.2
         rotate,4.1,5.1
         print,orbitals
         wf,ne(i),sym(i),ss(i);
         occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
         open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
        }
    else
        {rhf
         start,atden
         print,orbitals
         wf,ne(i),sym(i),ss(i);
         occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
         open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
        }
    end if
    scf(i)=energy
!    _CC_NORM_MAX=2.0
!    {rccsd(t);maxit,100;shift,1,1;diis,1,1,8;core}
    {rccsd(t),nocheck;maxit,100;core}
    ccsd(i)=energy
!    {rccsd(t);maxit,100;shift,1,1;diis,1,1,8;core,1,0,0,0,0,0,0,0}
!    fc_ccsd(i)=energy
!    fc_ccsd_ev(i)=energy*TOEV
enddo

table,scf,ccsd
