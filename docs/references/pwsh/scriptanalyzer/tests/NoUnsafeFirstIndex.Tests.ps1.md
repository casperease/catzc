# pwsh/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1

The tests of `Measure-NoUnsafeFirstIndex`.

The per-case assertions run the rule function directly on a parsed AST (L0). The engine-wiring proof lives once, for all custom rules, in
`CustomRuleWiring.Tests.ps1`.
