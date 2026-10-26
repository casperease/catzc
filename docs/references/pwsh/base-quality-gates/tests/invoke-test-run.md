# pwsh/Base.QualityGates/tests/Invoke-TestRun.Tests.ps1

The L0 logic test of `Invoke-TestRun`. Its fixture is a `tests/` folder with two files: `widget` mixes a source-only test with a runnable
one, and `gadget` is source-only throughout. Discovery is faked over them, in the Pester test shape that `Get-TestBlockTag` walks.
