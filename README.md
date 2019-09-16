# natural_spline
Finds the natural cubic spline of a set of input points. Can also output the values at regular intervals along the curve, and can find the value on the curve at a given point.

# Run
```
cd natural_spline
dub build
./natural_spline -x=1,1.2,1.3 -y=10,20,30
```

Output:
```
1,10
1.01,10.0013
1.02,10.01
1.03,10.0337
1.04,10.08
1.05,10.1562
1.06,10.27
1.07,10.4288
1.08,10.64
1.09,10.9113
1.1,11.25
1.11,11.6638
1.12,12.16
1.13,12.7463
1.14,13.43
1.15,14.2188
1.16,15.12
1.17,16.1413
1.18,17.29
1.19,18.5738
1.2,20
1.21,21.63
1.22,23.44
1.23,25.31
1.24,27.12
1.25,28.75
1.26,30.08
1.27,30.99
1.28,31.36
1.29,31.07
```

You can also run:

`./natural_spline -x=1,2,3,4,5 -y=10,20,30,40,50 -n=4.5`

Output:
```
510
```