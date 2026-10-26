# pwsh/Base.QualityGates/tests/Test-Terminology.Tests.ps1

The L0 test of `Test-Terminology`. Its default happy path mocks `Get-Config` so that the config loads, the dictionary is current, and every
term is referenced. Both mocks return the production shapes: the typed registry record, and the per-category rows of
`Build-TerminologyDictionary`.
