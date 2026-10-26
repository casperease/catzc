# .ado/pipelines/steps/cache-types.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `steps:`, written with `#`.

```text
The combined C# types build is a per-machine cache keyed by the type sources and the project they compile with
(ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD), so a job restores it instead of compiling it. The shadow root comes from its one resolver, Get-TypesShadowRoot.
```
