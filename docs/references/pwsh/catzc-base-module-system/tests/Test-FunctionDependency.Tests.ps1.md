# pwsh/Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1

The tests of the `Test-FunctionDependency` gate. The integrity invariant, that the real repository's function dependency graph is satisfied,
needs exactly one scan of the real `pwsh/` tree. The gate's uniform shape
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) is pure logic, so it is proven
at L0 against fixture roots rather than by a second full-tree scan.
