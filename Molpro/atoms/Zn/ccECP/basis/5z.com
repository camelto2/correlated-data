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
4
1,35.80797616175546, 20.0
3,34.53646083704226, 716.1595232351092000
2,28.62830178269908, -204.68393323548855
2,7.96239682559958 ,0.76026614461740
2
2,14.63498691533719, 95.87640437388212
2,35.02141356672601, 431.70804302700361
2
2,14.57429304153574, 74.01270048941292
2,42.22979234994646, 313.57770563939351
include,aug-cc-pwCV5Z-dk.basis
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
