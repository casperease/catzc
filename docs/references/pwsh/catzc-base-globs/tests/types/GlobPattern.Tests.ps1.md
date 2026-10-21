# pwsh/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlobPattern' -Tag 'L0', 'logic' {`, written with `#`.

```text
The dialect's truth table ([FDR-CD-GLOBS-REPOSITORYRELATIVEPATTERNS](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-repositoryrelativepatterns)) and the
constructor guard
([FDR-CD-GLOBS-MALFORMEDPATTERNREJECTED](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-malformedpatternrejected)): per-segment PowerShell
wildcards, '**' as the only cross-segment operator (zero or more whole segments), case-sensitive; a
malformed pattern never produces an instance.
```
