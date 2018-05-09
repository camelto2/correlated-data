***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12
gthresh,throvl=1.0E-09

basis={
ecp,Cr,10,2,0
4
1,18.9608692280690, 14.000
3,19.2685641575461, 265.452169192966
2,18.0153841906815,-128.167843509983
2,4.57001325266092,-0.77003811753664
2
2,16.4903485513045, 219.816211065414
2,7.56674851901174, 28.1074714467726
2
2,16.3628680561010, 143.817084156661
2,7.80179453134130, 20.5764813628932
s, CR , 6177194.0000000, 924929.5000000, 210486.5000000, 59620.0500000, 19450.7600000, 7022.0560000, 2738.7630000, 1135.8140000, 495.0923000, 224.7487000, 105.3836000, 50.1935900, 22.2495700, 10.9826500, 5.3836650, 2.3436850, 1.1052020, 0.4878480, 0.0895990, 0.0334230, 4.8281000, 1.1499000, 0.0124700
p, CR , 14454.2000000, 3421.6760000, 1111.3870000, 425.1918000, 180.2623000, 82.0611700, 39.2972600, 19.4195900, 9.8288990, 5.0168100, 2.4870910, 1.1987800, 0.5586950, 0.2093660, 0.0847220, 0.0332780, 5.2718000, 1.2083000, 0.0130700
d, CR , 89.4745000, 26.3368000, 9.5342900, 3.8211800, 1.5716900, 0.6264220, 0.2330550, 0.0763030, 3.4093000, 1.5874000, 0.0249800
f, CR , 4.3629000, 1.5864000, 0.5231000, 0.1724900
g, CR , 4.0406000, 1.4199000, 0.4989600
ECP,H,0,1,0
3;
2,   21.77696655044365 ,     -10.85192405303825 ; 
 1,   21.24359508259891 ,       1.00000000000000;
 3,   21.24359508259891 ,      21.24359508259891;
1; 2,                   1.,                      0.;
s, H , 33.8700000, 5.0950000, 1.1590000, 0.3258000, 0.1027000, 0.0252600
p, H , 1.4070000, 0.3880000, 0.1020000
d, H , 1.0570000, 0.2470000
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
