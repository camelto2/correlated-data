***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.e-12
geometry={
1
V
V  0.0 0.0 0.0
}

basis={
ecp,V,10,2,0;
4;
1,20.2553013762707, 13.000 ;
3,19.5088778400405, 263.318917891519;
2,17.3088758203163,-114.916486604966 ;
2,5.04502199681890,-0.68289799957596;
2;
2,15.4637410000600, 195.609510670332  ;
2,6.10337317130682, 23.2299358975926  ;
2;
2,15.5891849786496, 126.699271677201;
2,5.87628647826524, 15.8646131466216;
include,aug-cc-pwCV5Z-dk.basis
}


include,states.proc

do i=1,11
    if (i.eq.1) then
        Is2d3
    else if (i.eq.2) then
        Is1d4
    else if (i.eq.3) then
        Id5
    else if (i.eq.4) then
        IIs1d3
    else if (i.eq.5) then
        IId4
    else if (i.eq.6) then
        VI
    else if (i.eq.7) then
        XII
    else if (i.eq.8) then
        As2d4
    else if (i.eq.9) then
        IIId3
    else if (i.eq.10) then
        IVd2
    else if (i.eq.11) then
        Vd1
    endif
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t),maxit=100;core}
    ccsd(i)=energy
enddo

table,scf,ccsd
save
type,csv
