# pwsh/Base.FileLimits/tests/Measure-FileShape.Tests.ps1

The tests of `Measure-FileShape`, which measures a file's line count and widest line.

## What it proves

One streaming pass reports the line count and the widest line with its number, the same lines the gate and the linters see.
