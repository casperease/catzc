---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/private/Get-PipelineTemplateReference.ps1.md
    kind: comment-page
    body_sha: f01f8627a9b7
    adrs: []
    links: []
---

# automation/Catzc.Azure.DevOps/private/Get-PipelineTemplateReference.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the file and returns each `template:` mapping value, whether written as a `steps`/`jobs`/… include
(`- template: /pipelines/steps/x.yaml`) or inside an `extends:` block (`template: /pipelines/extends/…`).
It is a line scan, not a YAML parse, so it is robust to the template expressions ADO YAML carries.

Only genuine file references are returned: a value that is a template EXPRESSION (`${{ … }}`) or carries
a runtime variable (`$( … )`) is skipped (its target is not statically known), and a value that does not
end in `.yaml` is ignored (it is not a template path). Comment lines (`#`) never match.
```
