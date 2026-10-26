# pwsh/Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1

The L0 logic test of `Select-RuleTaggedFiles`. Its fixture helper `New-FakeTest` builds fake discovery tests keyed by file, each with a
block chain that the resolver walks. They are plain data, built in Pester scope and passed into module scope.
