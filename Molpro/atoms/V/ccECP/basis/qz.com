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
1,20.32168914264005, 13.000;
3,19.59698040116814, 264.18195885432065;
2,17.33147348169929,-115.29293208303302;
2,5.123206579292210,-0.6628872600572900;
2;
2,15.12502150536263, 195.56713891052664;
2,6.298989144695830, 22.886428347605640;
2;
2,15.93855113266013, 126.42119500787415;
2,5.740062668659290, 16.035971276624900;
include,aug-cc-pwCVQZ-dk.basis
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
