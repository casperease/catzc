---
catzc:
  immutable:
    with_body_sha: "3bc8ff8c6a25"
    path: docs/references/automation/catzc-azure-devops/types/YamlTemplateType.cs.md
    folder: docs/references/automation/catzc-azure-devops/types
    name: yaml-template-type-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps/types/YamlTemplateType.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Azure.DevOps;`, written with `//`.

```text
The sub-kind of a Template YAML file, determined by which body key it exposes. Carried as a
Nullable<YamlTemplateType> by callers — null means "not a Template" (the file is a Pipeline/Unknown).
```
