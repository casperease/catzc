---
catzc:
  immutable:
    with_body_sha: cdef01b3a330
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/configs/capabilities.yml.md
    folder: docs/references/automation/catzc-base-docs/configs
    name: capabilities-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Docs/configs/capabilities.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `capabilities:`, written with `#`.

```text
One entry per capability .claude/skills/<name>/SKILL.md: the rules behind it and the checks it runs or guards. The model
floor is not here; it lives once in the file's metadata.catzc.model_floor, and Test-AgentDefinitions enforces it.
```
