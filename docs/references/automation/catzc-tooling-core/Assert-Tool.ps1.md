---
catzc:
  immutable:
    with_body_sha: ac40c5649ac6
    path: docs/references/automation/catzc-tooling-core/Assert-Tool.ps1.md
    folder: docs/references/automation/catzc-tooling-core
    name: assert-tool-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Core/Assert-Tool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($config.HasProbes()) {`, written with `#`.

```text
A tool with declared candidate paths is located by the probe, never by its bare name on PATH (for bash on
Windows that name can be the WSL launcher).
```
