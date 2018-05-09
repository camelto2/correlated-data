***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
geometry={
1
Zn
Zn  0.0 0.0 0.0
}

basis={
ecp,Zn,10,2,0
4;
1,35.87771523255935, 20.0
3,34.10784236962095, 717.5543046511870000
2,28.71745204229478, -203.49912625487161
2,8.39550882138344 ,-0.04450116575923
2;
2,14.49782889165584, 95.23904948960599
2,35.15976095427823, 430.48072034938946
2;
2,14.71198185633088, 73.77695397849085
2,41.62867068311363, 312.12270271509306
include,aug-cc-pwCVTZ-dk.basis
}

include,states.proc

do i=1,15
    if (i.eq.1) then
        Is2dten
    else if (i.eq.2) then
        IIs1dten
    else if (i.eq.3) then
        IIs2d9
    else if (i.eq.4) then
        IIIdten
    else if (i.eq.5) then
        IVd9
    else if (i.eq.6) then
        Vd8
    else if (i.eq.7) then
        VId7
    else if (i.eq.8) then
        VIId6
    else if (i.eq.9) then
        VIIId5
    else if (i.eq.10) then
        IXd4
    else if (i.eq.11) then
        Xd3
    else if (i.eq.12) then
        XId2
    else if (i.eq.13) then
        XIId1
    else if (i.eq.14) then
        XIII
    else if (i.eq.15) then
        XIX
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
