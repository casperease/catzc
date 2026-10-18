# pwsh/.scriptanalyzer/tests/NoBareCacheEntryRead.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-NoBareCacheEntryRead' -Tag 'L0', 'logic', 'ADR-PWSH-CACHE-STRICTSAFEPROBE' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0). The engine-wiring proof lives once,
for all custom rules, in CustomRuleWiring.Tests.ps1.
```
