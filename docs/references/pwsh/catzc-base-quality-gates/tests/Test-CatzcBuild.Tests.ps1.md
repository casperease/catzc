# pwsh/Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1

The L0 test of `Test-CatzcBuild`. `Build-Modules` of `Catzc.Base.Exporter` is the boundary and is mocked, so the test proves the wiring
without a real build.
