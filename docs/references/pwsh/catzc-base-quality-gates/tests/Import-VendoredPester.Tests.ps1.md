# pwsh/Base.QualityGates/tests/Import-VendoredPester.Tests.ps1

The L0 logic test of `Import-VendoredPester`. It builds a fake code root with one vendored version, and mocks every module operation, so the
Pester that runs this test is never touched.
