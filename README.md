# natural_spline
Finds the natural cubic spline of three points. Can also output the values at regular intervals along the curve, and can find the value on the curve at a given point.

Eventually, this should be expanded to allow for any number of input data points, but using only the cli, I want to stick with just 3.

# Run
```
cd natural_spline
dub build
./natural_spline -x0 1 -x1 5 -y0 2 -y1 3
```

Output:
```
1,2
1.33333,5.6142
1.66667,9.08025
2,12.25
2.33333,14.9753
2.66667,17.108
3,18.5
3.33333,19.0031
3.66667,18.4691
4,16.75
4.33333,13.6975
4.66667,9.16358
5,3
```

You can also run:

`./natural_spline -x0 1 -x1 5 -y0 2 -y1 3`

Output:
```
a -> 2
b -> 10.9167
d -> -0.666667
```