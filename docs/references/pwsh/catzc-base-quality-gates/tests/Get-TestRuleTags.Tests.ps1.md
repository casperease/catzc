# pwsh/Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1

The L0 logic test of `Get-TestRuleTags`. Its fixture helper `New-FakeTest` builds a fake Pester test with its own `It` tags, an inner block,
and an optional outer block, the same shape that `Get-TestBlockTag.Tests.ps1` uses. The test's `.Block` is the inner block.
