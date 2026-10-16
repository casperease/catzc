---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/tests/Get-GitTrackedPath.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: dd9fa66789b2
---

# automation/Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Set-GitIndexFile {`, written with `#`.

```text
A minimal version-2 index of stage-0 regular files — the reader's own shapes are pinned in
Catzc.Base.Git/tests/types/GitIndex.Tests.ps1; here only the seam, the pathspec, and the content-keyed cache matter.
```

## comment:2

Above `Describe 'Get-GitTrackedPath (real git)' -Tag 'L2', 'integrity', 'source-only' {`, written with `#`.

```text
The reader against the real thing: on this repository's own index, the in-process answer is byte-for-byte
what `git ls-files` prints (unmerged paths, which git repeats per stage, counted once).
```
