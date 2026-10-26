# pwsh/Base.QualityGates/tests/Get-DrsUsage.Tests.ps1

The tests of `Get-DrsUsage`. The real-file case passes an absolute path, because a relative one resolves against the process location, which
a test worker does not hold at the repository root.
