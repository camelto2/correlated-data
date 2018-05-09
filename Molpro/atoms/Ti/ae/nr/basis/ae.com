***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Fe
Fe  0.0 0.0 0.0
}

basis={
include,aug-cc-pwCV5Z-dk.basis
}

!set,dkroll=1,dkho=10,dkhp=4
ne  =[26,26,26,25,25]
symm=[ 1, 6, 6, 1, 6]
ss  =[ 4, 4, 2, 5, 3]

Ag  =[ 6, 6, 5, 6, 5]  ! quadratic
B3u =[ 2, 2, 2, 2, 2]  ! x
B2u =[ 2, 2, 2, 2, 2]  ! y
B1g =[ 1, 1, 1, 1, 1]  ! xy
B1u =[ 2, 2, 2, 2, 2]  ! z
B2g =[ 1, 1, 1, 1, 1]  ! xz
B3g =[ 1, 1, 1, 1, 1]  ! yz
Au  =[ 0, 0, 0, 0, 0]  ! xyz

sing_occ=[6.1,1.4,1.6,1.7,0,0,0,0,\
          5.1,6.1,1.4,1.7,0,0,0,0,\
          1.4,1.7,0,0,0,0,0,0,\
          5.1,6.1,1.4,1.6,1.7,0,0,0\
          5.1,1.4,1.7,0,0,0,0,0]

do i=1,#symm
if (i.eq.1) then
    {rhf
     print,orbitals
     wf,ne(i),symm(i),ss(i);
     occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
     open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
     sym,1,1,1,1,1,3,2
    }
else if ((i.eq.2).or.(i.eq.4)) then
    {rhf
     print,orbitals
     wf,ne(i),symm(i),ss(i);
     occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
     open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
     sym,1,1,1,1,3,2,1
    }
else if (i.eq.3) then
    {rhf,maxit=400,nitord=20
     start,h0
     shift,-2.5,-2
     print,orbitals
     wf,ne(i),symm(i),ss(i);
     occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
     open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
     sym,1,1,1,1,3,2
    }
else if (i.eq.5) then
    {rhf
     print,orbitals
     wf,ne(i),symm(i),ss(i);
     occ,Ag(i),B3u(i),B2u(i),B1g(i),B1u(i),B2g(i),B3g(i),Au(i);
     open,sing_occ(8*i-8+1),sing_occ(8*i-8+2),sing_occ(8*i-8+3),sing_occ(8*i-8+4),sing_occ(8*i-8+5),sing_occ(8*i-8+6),sing_occ(8*i-8+7),sing_occ(8*i-8+8);
     sym,1,1,1,1,3,2
    }
endif
    scf(i)=energy
    pop
enddo

table,scf
