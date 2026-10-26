# pwsh/Base.QualityGates/tests/Get-LogicTestIdentityFinding.Tests.ps1

The tests of `Get-LogicTestIdentityFinding`. The live-identity map is synthetic: `contoso` stands in for a live customer. It is deliberately
not a real shipped identity, so this test file, which must contain the token to exercise the finder, is not itself flagged by
`Test-LogicTestIdentity`. The finder's logic is the same for any token set.
