# pwsh/Base.QualityGates/tests/Test-LinkDirections.Tests.ps1

The test of `Test-LinkDirections`, which judges every relation the link walk reads against the rows. It runs in a `TestDrive` tree with its
endpoints and rows mocked. An allowed relation passes, a denied one names its row and rule, one that no row allows is denied, and an exempt
file is skipped.
