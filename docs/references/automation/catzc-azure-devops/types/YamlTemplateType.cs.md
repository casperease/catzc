---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/types/YamlTemplateType.cs.md
    kind: comment-page
    body_sha: a0391bf123da
---

# automation/Catzc.Azure.DevOps/types/YamlTemplateType.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Azure.DevOps;`.

```text
The sub-kind of a Template YAML file, determined by which body key it exposes. Carried as a
Nullable<YamlTemplateType> by callers — null means "not a Template" (the file is a Pipeline/Unknown).
```
