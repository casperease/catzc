# pwsh/Base.QualityGates/tests/types/LinkDirectionEngine.Tests.ps1

The test of the `LinkDirectionEngine` type. The engine judges each relation by the first matching row, denies what no row allows, skips an
exempt file, and reports an edge whose end has no endpoint.
