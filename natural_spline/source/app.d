/+

####
Initial calculations that I used to derive the borader, elementwise workflow

S0(n) = a0 + b0(n - x0) + c0(n - x0)^2 + d0(n - x0)^3
S1(n) = a1 + b1(n - x1) + c1(n - x1)^2 + d1(n - x1)^3
S2(n) = a2 + b2(n - x2) + c2(n - x2)^2 + d2(n - x2)^3
S3(n) = a3 + b3(n - x3) + c3(n - x3)^2 + d3(n - x3)^3

S0(x0) = y0 = a0
S1(x1) = y1 = a1
S2(x2) = y2 = a2
S3(x3) = y3 = a3
S3(x4) = y4 = y3 + b3(x4 - x3) + c3(x4 - x3)^2 + d3(x4 - x3)^3

Boundary conditions:
S0'(x0) = b0 = 0
S0'(x1) = S1'(x1)
S1'(x2) = S2'(x2)
S2'(x3) = S3'(x3)
S3'(x4) = 0

S0''(x0) = 0                -> c0 = 0
S0''(x1) = S1''(x1) -> 3 * d0(x1 - x0) = 2c1
S1''(x2) = S2''(x2)
S3''(x2) = S3''(x3)
s3''(x4) = 0 = 2c3 + 6d3 (x4 - x3)

Let's drop the c values from our original equations and substitute back in the y values as well

S0(n) = y0 + d0(n - x0)^3
S1(n) = y1 + b1(n - x1) + c1(n - x1)^2 + d1(n - x1)^3
S2(n) = y2 + b2(n - x2) + c2(n - x2)^2 + d2(n - x2)^3
S3(n) = y3 + b3(n - x3) + c3(n - x3)^2 + d3(n - x3)^3

S0'(x0) = b0 = 0
S0'(x1) = 3 * d0(x1 - x0)^2 = b1
S1'(x2) = b1 + 2c1(x2 - x1) + 3 * d1(x2 - x1)^2 = b2
S2'(x3) = b2 + 2c1(x2 - x2) + 3 * d2(x3 - x2)^2 = b3
S3'(x4) = b3 + 2c2(x3 - x3) + 3 * d3(x4 - x3)^2 = 0

S0''(x1) = 6 * d0(x1-x0)
S1''(x1) = 2c1
c1 = 3 * d0(x1 - x0)

S1''(x2) = 2c1 + 6 * d1(x2-x1) = c2
S2''(x3) = 2c2 + 6 * d2(x3-x2) = c3
S3''(x4) = 2c3 + 6 * d3(x4-x3) = 0 -> d3 = -c3 / (3 * (x4 - x3))

########
current known values:
x0, x1, x2, x3, x4 (given)
y0, y1, y2, y3, y4 (given)
a0, a1, a2, a3 = y0, y1, y2, y3, y4
b0, c0 = 0 (by constraints)

S0(x1) = y1 = y0 + d0(x1 - x0)^3

d0 = (y1 - y0) / (x1 - x0)^3

b1 = 3 * d0(x1 - x0)^2
c1 = 3 * d0(x1 - x0) / 2
a1 + b1(n - x1) + c1(n - x1)^2 + d1(n - x1)^3
d1 = (a2 - a1 - b1(x2 - x1) - c1(x2 - x1)^2) / (x2 - x1)^3

+/

import std.stdio;
import std.algorithm;
import std.math;
import std.conv;
import std.getopt;
import std.string;


void main(string[] args)
{
    string xValsString;
    string yValsString;

    double[] x;
    double[] y;

    double findX;

    auto helpInformation = getopt(
        args,
        "x", &xValsString,
        "y", &yValsString,
        "n", &findX
    );

    assert(xValsString != "", "`x` values must be given");
    assert(yValsString != "", "`y` values must be given");

    if (helpInformation.helpWanted)
    {
        defaultGetoptPrinter("Some basic info", helpInformation.options);
    }

    foreach(xVal; xValsString.split(","))
    {
        x ~= to!double(xVal);
    }

    foreach(yVal; yValsString.split(","))
    {
        y ~= to!double(yVal);
    }

    // make sure we have enough data in the proper format
    assert(x.length == y.length, "`x` and `y` must have equal number of observations");
    assert(x.isStrictlyMonotonic, "`x` values must be sorted and monotonic");
    assert(y.isStrictlyMonotonic, "`y` values must be sorted and monotonic");
    assert(y.length > 1, "must have more than just one data point observation to create a natural spline");
    assert((findX > x[0]) && (findX < x[$ - 1]), "`n` value of `" ~ to!string(findX) ~ "` is outside of the input range [" ~ to!string(x[0]) ~ "," ~ to!string(x[$ - 1]) ~ "]");

    double[] a;
    double[] b;
    double[] c;
    double[] d;

    a ~= y[0];
    b ~= 0;
    c ~= 0;
    d ~= (y[1] - y[0]) / pow((x[1] - x[0]), 3);

    for (int counter = 1; counter < x.length - 1; ++counter)
    {
        a ~= y[counter];
        b ~= b[counter - 1] + (2 * c[counter - 1] * (x[counter] - x[counter - 1])) + (3 * d[counter - 1] * pow((x[counter] - x[counter - 1]), 2));
        c ~= (2 * c[counter - 1]) + (6 * d[counter - 1] * (x[counter] - x[counter - 1]));
        d ~= (y[counter + 1] - a[counter] - (b[counter] * (x[counter + 1] - x[counter])) - (c[counter] * pow((x[counter + 1] - x[counter]), 2))) / pow((x[counter + 1] - x[counter]), 3);
    }

    if (!findX.isNaN)
        writeln(calculateOnSpline(x, y, a, b, c, d, findX));
    else
    {
        for (double i = x[0]; i < x[$ - 1]; i += 0.01)
        {
            writeln(i, ",", calculateOnSpline(x, y, a, b, c, d, i));
        }
    }
}


double calculateOnSpline(double[] x, double[] y, double[] a, double[] b, double[] c, double[] d, double findX)
{
    int xRange = 0;
    auto prevVal = x[0];

    foreach (val; x[1 .. $])
    {
        if (findX <= val && findX >= prevVal)
            break;
        else
        {
            ++xRange;
            prevVal = val;
        }
    }

    return a[xRange] + b[xRange] * (findX - x[xRange]) + c[xRange] * pow((findX - x[xRange]), 2) + d[xRange] * pow((findX - x[xRange]), 3);
}