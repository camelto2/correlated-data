***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12

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
s, V , 10251780, 1534920, 349300.9, 98942.05, 32281.36, 11655.27, 4546.548, 1886.185, 822.9417, 374.3439, 176.3069, 85.40661, 41.90435, 19.15525, 9.571617, 4.780086, 2.16186, 1.042711, 0.480282, 0.117638, 0.056174, 0.025661, 4.4632, 1.3107, 0.0117200
p, V , 28563.32, 6757.191, 2194.652, 840.5257, 357.6666, 163.7534, 79.14466, 39.83858, 20.58536, 10.84307, 5.777969, 3.04317, 1.570239, 0.794975, 0.38898, 0.157335, 0.066583, 0.027844, 5.6501, 1.4350, 0.0117200
d, V , 244.347, 72.2926, 27.6493, 11.7778, 5.33731, 2.51760, 1.18881, 0.549967, 0.245738, 0.104504, 0.041145, 3.4437, 1.7638, 0.0162000
f, V , 4.6999, 1.9221, 0.7861, 0.2516, 0.0805300
g, V , 3.9718, 1.6355, 0.5564, 0.1892900
h, V , 3.6433, 1.2875, 0.4549900
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

ne    =14
symm  =1
ss    =4

A1=4
B1=2
B2=2
A2=1

do i=1,21
    z(i) = 1.3 + 0.05*(i-1)
    geometry={
        2
        Oxygen
        V  0.0 0.0 0.0
        H  0.0 0.0 z(i)
    }
    {rhf
     wf,ne,symm,ss
     occ,A1,B1,B2,A2
     open,4.1,2.2,2.3,1.4
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
   V 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,13,6,3;
 occ,4,1,1,0,1,1,0,0;
 open,3.1,4.1,1.6;
 sym,1,1,1,3,2
}
V_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
V_ccsd=energy

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
