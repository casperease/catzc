# automation/Catzc.Base.Git/tests/types/GitIndex.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GitIndex' -Tag 'L0', 'logic' {`, written with `#`.

```text
The index reader against hand-built index bytes in git's on-disk layout (DIRC v2-v4) — every shape a real
repository writes, without launching git. The equivalence with real `git ls-files` is the L2 test in
Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1.
```

## comment:2

Above `function New-GitIndexBytes {`, written with `#`.

```text
Builds index bytes. An entry is a path string or @{ Path; Stage; Mode; Extended }; -Extension is
appended raw after the entries; the trailer is the SHA-1 of the rest (all zeros with -ZeroChecksum,
as git writes under index.skipHash).
```
