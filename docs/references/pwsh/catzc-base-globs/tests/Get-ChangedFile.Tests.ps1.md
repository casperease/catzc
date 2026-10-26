# pwsh/Base.Globs/tests/Get-ChangedFile.Tests.ps1

<!-- cspell:ignore nsrc -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ChangedFile'`, written with `#`.

```text
The diff universe ([FDR-CD-GLOBS-TRACKEDFILESONLY](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)): changed paths
from `git diff --name-only --no-renames`, repo-relative,
quotepath off, renames split so both the old and new path count.
```
