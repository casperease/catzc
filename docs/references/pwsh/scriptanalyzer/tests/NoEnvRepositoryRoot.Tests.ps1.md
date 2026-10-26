# pwsh/.scriptanalyzer/tests/NoEnvRepositoryRoot.Tests.ps1

The tests of `Measure-NoEnvRepositoryRoot`.

The per-case assertions run the rule function directly on a parsed AST (L0), since the rule is pure logic over a `ScriptBlockAst`. The
rule's reach is decided by the file path, so each case writes a fixture file into `$TestDrive` under a fake modules-folder layout and
parses it from there. The engine-wiring proof lives once, for all custom rules, in `CustomRuleWiring.Tests.ps1`.
