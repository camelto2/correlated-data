***,Calculation for Be atom, singlet and triplet
memory,512,m
geometry={
1
Cu
Cu  0.0 0.0 0.0
}

basis={
ecp,Cu,10,2,0
4;
1, 36.51687697306037,  19.0;
3, 54.82201391345763,  693.8206624881470300;
2, 32.48169588867644,  -155.75952043829815;
2, 17.01471786235481,  1.10887001964248;
2;
2, 14.86702511371494,  94.86836555301690;
2, 29.41780443655124,  376.04038353769562;
2;
2, 11.75708986756213,  64.21861970005369;
2, 50.11914425181166,  255.82988430082119;
include,aug-cc-pwCVTZ-dk.basis
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
