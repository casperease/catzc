# pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlobSet' -Tag 'L0', 'logic' {`, written with `#`.

```text
The globset record: membership is decided by the scan program — an ordered +/- rule list, last-match-wins
([FDR-CD-GLOBS-TRACKEDFILESONLY](/docs/adr/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)), flattened through compose with
own-rules-last
([FDR-CD-GLOBS-COMPOSESETS](/docs/adr/flow/durable-sha-globs.md#rule-fdr-cd-globs-composesets)); and the constructor guards the
shape (kebab-case name, required description, a layer declared, include or compose present, no duplicate
patterns).
```
