# pwsh/Catzc.Base.Globs/tests/Get-GlobSetMember.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlobSetMember' -Tag 'L0', 'logic' {`, written with `#`.

```text
The single 'what is IN the package' source
([FDR-CD-GLOBS-TRACKEDFILESONLY](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)): `git ls-files` ∩
GlobSet.Matches, ordinal-sorted.
Tested through the module (private). The '_' args in the scriptblock take the set and mocked tree.
```
