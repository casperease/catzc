---
catzc:
  immutable:
    with_body_sha: "415ecb69f278"
    path: docs/references/automation/catzc-base-execution/Wait-Mutex.ps1.md
    folder: docs/references/automation/catzc-base-execution
    name: wait-mutex-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Execution/Wait-Mutex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$waitSeconds = if ($announced) {`, written with `#`.

```text
Wait in observation-sized slices: up to the announce threshold first, then one dot interval
per slice — a failed slice is exactly one console event (the announcement, or a dot).
```
