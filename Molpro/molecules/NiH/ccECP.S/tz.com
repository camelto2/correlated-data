***,Calculation for Be atom, singlet and triplet
memory,512,m
gthresh,twoint=1.0E-12

basis={
ecp,Ni,10,2,0
4;
1, 21.81804460523468,  18.0;
3, 35.21101277458325,  392.7248028942242400;
2, 23.69925747358732,  -150.77747349256663;
2, 9.09797792907140 ,  0.87797909917553;
2;
2, 14.12410039485919,  83.50736809611425;
2, 25.81106861796072,  353.95993490451440;
2;
2, 10.08238908347844,  44.99270171320545;
2, 37.60499130871270,  268.79379401505179;
s, NI , 5045991.0000000, 755614.2000000, 171956.8000000, 48704.7900000, 15888.4100000, 5735.1230000, 2236.1370000, 926.6468000, 403.1743000, 182.3476000, 84.5488500, 38.3963400, 18.4585900, 8.8635480, 3.9162270, 1.8388700, 0.8043620, 0.1697970, 0.0793060, 0.0346770, 5.8330000, 1.5231000, 0.0151600
p, NI , 21027.9200000, 4977.5600000, 1616.7400000, 618.6718000, 262.5183000, 119.6907000, 57.4658500, 28.5282900, 14.5214800, 7.4538500, 3.7235530, 1.8098130, 0.8513360, 0.3234058, 0.1190210, 0.0421620, 8.7409000, 2.0073000, 0.0149400
d, NI , 142.5904000, 42.1021900, 15.4633700, 6.2838100, 2.6141700, 1.0480200, 0.3886520, 0.1246640, 5.7767000, 2.6956000, 0.0399900
f, NI , 7.9164000, 3.0235000, 1.0680000, 0.3772500
g, NI , 7.3017000, 2.9284000, 1.1744600
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

ne    =19
symm  =4
ss    =1

do i=1,1
    z(i) = 1.1 + 0.05*(i-1)
    geometry={
        2
        Oxygen
        Ni  0.0 0.0 0.0
        H  0.0 0.0 z(i)
    }
    {rhf
     wf,ne,symm,ss
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
   Ni 0.0 0.0 0.0
}
{rhf;
 start,atden
 wf,18,6,2;
 occ,4,1,1,1,1,1,1,0;
 open,1.4,1.7
 sym,1,1,1,3,2
}
Ni_scf=energy
_CC_NORM_MAX=2.0
{rccsd(t);maxit,100;core}
Ni_ccsd=energy

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
