# pwsh/.scriptanalyzer/tests/ParameterDesign.Tests.ps1

The tests of the parameter-surface checks in `ParameterDesign.psm1`.

The per-case assertions run the rule functions directly on a parsed AST (L0). Their reach is decided by the file path, so each case writes
a fixture file into `$TestDrive` under a fake modules-folder layout. The engine-wiring proof lives once, for all custom rules, in
`CustomRuleWiring.Tests.ps1`.
