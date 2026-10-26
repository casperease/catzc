# pwsh/Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1

The L0 logic test of `Get-TestExcludeTag`, a private function: the tier and category to `ExcludeTag` logic that `Test-Automation` and
`Test-InIsolation` share. The test reaches it through `InModuleScope`.
