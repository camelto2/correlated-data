***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Cu
Cu  0.0 0.0 0.0
}

basis={
ECP,Cu,10,4,0;
1; 2,1.000000,0.000000; 
2; 2,30.110543,355.750512; 2,13.076310,70.930906; 
4; 2,32.692614,77.969931; 2,32.770339,155.927448; 2,13.751067,18.021132; 2,13.322166,36.094372; 
4; 2,38.996511,-12.343410; 2,39.539788,-18.273362; 2,12.287511,-0.984705; 2,11.459300,-1.318747; 
2; 2,6.190102,-0.227264; 2,8.118780,-0.468773; 
include,aug-cc-pwCV5Z-dk.basis
}

include,states.proc

do i=1,16
    if (i.eq.1) then
        Is2d9
    else if (i.eq.2) then
        Is1dten
    else if (i.eq.3) then
        IIs1d9
    else if (i.eq.4) then
        IIdten
    else if (i.eq.5) then
        IIId9
    else if (i.eq.6) then
        IVd8
    else if (i.eq.7) then
        Vd7
    else if (i.eq.8) then
        VId6
    else if (i.eq.9) then
        VIId5
    else if (i.eq.10) then
        VIIId4
    else if (i.eq.11) then
        IXd3
    else if (i.eq.12) then
        Xd2
    else if (i.eq.13) then
        XId1
    else if (i.eq.14) then
        XII
    else if (i.eq.15) then
        XVIII
    else if (i.eq.16) then
        As2dten
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
