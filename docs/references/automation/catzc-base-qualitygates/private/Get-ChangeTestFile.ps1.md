---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ChangeTestFile.ps1.md
    kind: comment-page
    body_sha: e2519847b678
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The tests half of Test-Change's plan, by convention alone (one function per file,
[ADR-PWSH-ONEFUNC](/docs/adr/pwsh/one-function-per-file.md)): a changed test file is itself; a changed function file
automation/<Module>/[private/]<Name>.ps1 is covered by automation/<Module>/tests/<Name>.Tests.ps1; a changed C# type
automation/<Module>/types/<Type>.cs by automation/<Module>/tests/types/<Type>.Tests.ps1. Only test files that exist
are returned, as repo-relative, '/'-separated paths, sorted ordinally, each once; a change no convention covers
contributes nothing. With -Module, a change anywhere under automation/<Module>/ (dot folders excepted) brings in
every test file under that module's tests/ instead.
```
