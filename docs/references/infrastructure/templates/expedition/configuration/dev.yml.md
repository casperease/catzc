---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/configuration/dev.yml.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9744f69b3d1f"
---

# infrastructure/templates/expedition/configuration/dev.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
expedition, shared dev (configuration root, shared_nonprod subscription): in the nonprod hub's shared-services
subnet, registered in the same hub's private DNS zones. Nonprod class: a serverless database that pauses when
idle.
```
