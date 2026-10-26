# pwsh/Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1

The L0 logic test of `Get-TestBlockTag`. Its fixture helper `New-FakeTest` builds a fake Pester test with its own `It` tags, an inner block,
and an optional outer block. The test's `.Block` is the inner block, and the helper takes explicit `[string[]]` parameters so that arrays are
not flattened into an array of arrays.
