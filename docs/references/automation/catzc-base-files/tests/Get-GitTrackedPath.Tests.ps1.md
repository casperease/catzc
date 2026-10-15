---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/tests/Get-GitTrackedPath.Tests.ps1.md
    kind: test-asset
    body_sha: ab5930c7bebd
---

# automation/Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function Set-GitIndexFile {`.

```text
A minimal version-2 index of stage-0 regular files — the reader's own shapes are pinned in
Catzc.Base.Git/tests/types/GitIndex.Tests.ps1; here only the seam, the pathspec, and the content-keyed cache matter.
```

## comment:2

Above `Describe 'Get-GitTrackedPath (real git)' -Tag 'L2', 'integrity', 'source-only' {`.

```text
The reader against the real thing: on this repository's own index, the in-process answer is byte-for-byte
what `git ls-files` prints (unmerged paths, which git repeats per stage, counted once).
```
