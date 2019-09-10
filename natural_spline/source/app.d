/*

S(n) = a + b(n - x0) + c(n - x0)^2 + d(n - x0)^3
S(x0) = y0 = a

S(x1) = y1 = y0 + b(x1 - x0) + c(x1 - x0)^2 + d(x1 - x0)^3
y1 - y0 = b(x1 - x0) + c(x1 - x0)^2 + d(x1 - x0)^3
b(x1 - x0) = y1 - y0 - c(x1 - x0)^2 - d(x1 - x0)^3
b = (y1 - y0 - c(x1 - x0)^2 - d(x1 - x0)^3) / (x1 - x0)

S'(n) = b + 2c(n - x0) + 3d(n - x0)^2
S'(x1) = b + 2c(x1 - x0) + 3d(x1 - x0)^2

S''(n) = 2c + 6d(n - x0)
S''(x0) = 2c = 0
S''(x1) = 0 = 6d(x1 - x0)

c = 0
d = (x0 - x1) / 6
b = (y1 - y0 - d(x1 - x0)^3) / (x1 - x0)

S(n) = y0 + b(n - x0) + d(n - x0)^3

*/

import std.stdio;
import std.algorithm;
import std.math;
import std.conv;





void main(string[] args)
{
    foreach (arg; ["-x0", "-x1", "-y0", "-y1"])
    {
        if (!args.canFind(arg))
        {
            writeln("missing required argument ", arg);
            return;
        }
    }

    double x0;
    try {
        x0 = to!double(args[countUntil(args, "-x0") + 1]);
    }
    catch (std.conv.ConvException)
    {
        writeln("x0 has an incorrect format. try again.");
        return;
    }

    double x1;    
    try {
        x1 = to!double(args[countUntil(args, "-x1") + 1]);
    }
    catch (std.conv.ConvException)
    {
        writeln("x1 has an incorrect format. try again.");
        return;
    }

    double y0;
    try {
        y0 = to!double(args[countUntil(args, "-y0") + 1]);
    }
    catch (std.conv.ConvException)
    {
        writeln("y0 has an incorrect format. try again.");
        return;
    }

    double y1;
    try {
        y1 = to!double(args[countUntil(args, "-y1") + 1]);
    }
    catch (std.conv.ConvException)
    {
        writeln("y1 has an incorrect format. try again.");
        return;
    }

    if (x0 == x1)
    {
        writeln("x0 and x1 cannot be the same value for a cubic spline");
        return;
    }

    assert(x0 != x1);

    double a = y0;
    double d = (x0 - x1) / 6.0;
    double b = (y1 - y0 - d * pow(x1 - x0, 3)) / (x1 - x0);

    double sections;

    // if the user wants us to split out values based on the input
    if (args.canFind("-n"))
    {
        try
        {
            sections = to!double(args[countUntil(args, "-n") + 1]);
        }
        catch (std.conv.ConvException)
        {
            writeln("n has an incorrect format. try again.");
            return;
        }

        double interval = (x1 - x0) / sections;
        for (double n = x0; n <= x1; n += interval)
        {
            // y0 + b(n - x0) + d(n - x0)^3
            writeln(n, ",", y0 + b * (n - x0) + d * pow((n - x0), 3));
        }
    }

    else
    {
        writeln("a -> ", a);
        writeln("b -> ", b);
        writeln("d -> ", d);        
    }
}
