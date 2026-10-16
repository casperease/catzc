---
catzc:
  immutable:
    with_body_sha: "6571b4f09ece"
    path: docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
    folder: docs/references/automation/catzc-base-globs/tests
    name: get-changed-file-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-FLOW-CD-GLOBS#4
---

# automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1

<!-- cspell:ignore nsrc -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ChangedFile' -Tag 'L0', 'logic' {`, written with `#`.

```text
The diff universe ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): changed paths
from `git diff --name-only --no-renames`, repo-relative,
quotepath off, renames split so both the old and new path count.
```
