---
catzc:
  immutable:
    with_body_sha: bff1eea7aa5d
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLockHolder.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-test-run-lock-holder-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunLockHolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$toInstant = {`, written with `#`.

```text
ConvertFrom-Json turns ISO timestamps into [datetime] (kind kept from the 'Z'/offset suffix); a string
cast would drop sub-second precision and the zone, so both shapes are read as instants here.
```
