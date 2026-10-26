# pwsh/Base.FileLimits/tests/Test-FileShape.Tests.ps1

The tests of `Test-FileShape`, which checks files against their resolved limits.

## What it proves

Each breach yields one finding with its path and line, the limit and where the limit came from, so a reader goes straight to the line.
