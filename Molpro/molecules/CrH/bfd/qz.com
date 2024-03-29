***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-09

basis={
ecp,Cr,10,2,0;
3;1,2.94337662,14.00000000;3,3.40750349,41.20727267;2,3.33587110,-55.51413840;
1;2,9.14231779,103.26274052;
1;2,7.21220771,45.80124572;
s, CR , 11016640, 1649423, 375358.9, 106323.6, 34689.76, 12524.83, 4885.752, 2026.918, 884.3645, 402.317, 189.5271, 91.86095, 45.12476, 20.62512, 10.31973, 5.157723, 2.312628, 1.103079, 0.498042, 0.118247, 0.057356, 0.02576, 4.7991, 1.4287, 0.0115700
p, CR , 31539.89, 7460.234, 2422.622, 927.7547, 394.8041, 180.8027, 87.42393, 44.03427, 22.77704, 12.01547, 6.411751, 3.381136, 1.747054, 0.885004, 0.433028, 0.173962, 0.072823, 0.029952, 1.6531, 0.0123200
d, CR , 281.312, 83.1885, 31.8396, 13.6026, 6.18298, 2.92270, 1.38216, 0.639460, 0.284898, 0.120045, 0.046229, 4.0848, 2.1405, 0.0178000
f, CR , 5.6633, 2.3365, 0.9639, 0.3142, 0.1024200
g, CR , 4.6690, 1.9538, 0.6848, 0.2400200
h, CR , 4.4133, 1.6472, 0.6147900
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ; 
 1,   21.24359508259891 ,       1.00000000000000;
 3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
s, H , 82.64, 12.41, 2.824, 0.7977, 0.2581, 0.08989, 0.0236300
p, H , 2.292, 0.838, 0.292, 0.0848000
d, H , 2.062, 0.662, 0.1900000
f, H , 1.397, 0.3600000
}

ne    =15
symm  =1
ss    =5

A1=5
B1=2
B2=2
A2=1

do i=1,21
    z(i) = 1.0 + 0.05*(i-1)
    geometry={
        2
        Oxygen
        Cr  0.0 0.0 0.0
        H  0.0 0.0 z(i)
    }
    {rhf
     wf,ne,symm,ss
     occ,A1,B1,B2,A2
     open,4.1,5.1,2.2,2.3,1.4
     print,orbitals=3
    }
    scf(i)=energy
    _CC_NORM_MAX=2.0
    {rccsd(t);maxit,100;core}
    ccsd(i)=energy
enddo

geometry={
   1
   Vanadium
   Cr 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,14,1,6;
 occ,4,1,1,1,1,1,1,0;
 open,2.1,3.1,4.1,1.4,1.6,1.7;
 sym,1,1,1,3,2
}
Cr_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Cr_ccsd=energy

geometry={
   1
   Oxygen
   H 0.0 0.0 0.0
}
{rhf;
 wf,1,1,1;
 occ,1,0,0,0,0,0,0,0;
 open,1.1;
}
H_scf=energy

table,z,scf,ccsd
save
type,csv
