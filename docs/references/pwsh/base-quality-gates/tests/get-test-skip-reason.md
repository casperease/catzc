# pwsh/Base.QualityGates/tests/Get-TestSkipReason.Tests.ps1

The L0 logic test of `Get-TestSkipReason`. Its fixture helper `New-FakeSkip` builds a Pester test-result object, which carries
`.ErrorRecord`, a collection of records that each expose `.Exception.Message`. A discovery `It -Skip` records nothing, so the helper takes
`-NoRecord` for that shape.
