---
catzc:
  immutable:
    with_body_sha: b84f310f3209
    path: docs/references/infrastructure/templates/expedition/configuration/apex/dev-blu.yml.md
    folder: docs/references/infrastructure/templates/expedition/configuration/apex
    name: dev-blu-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/expedition/configuration/apex/dev-blu.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
expedition, apex dev, the special slot blu (customer apex, apex_nonprod subscription): a second deployment
of the workload beside the base slot of dev, in its own resource group and the same apex nonprod spoke.
```
