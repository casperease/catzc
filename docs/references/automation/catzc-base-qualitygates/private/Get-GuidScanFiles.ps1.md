---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "676e97f3373f"
---

# automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Assert-SourceTree`, written with `#`.

```text
The universe and its exclusions (automation/.vendor, automation/.compiled, the registry) are the catzc
source repository's layout, so the scan is meaningful only over the source tree.
```
