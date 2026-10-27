# pwsh/Azure.DevOps/private/Get-PipelineTemplateReference.ps1

The private function that extracts the `template:` references from a pipeline YAML file, the paths the naming-and-placement check tests for
absoluteness.

## help

### synopsis

Extracts the template references (`template:` values) from a pipeline YAML file — the paths a naming/placement quality gate checks for
absoluteness.

### description

Reads the file and returns each `template:` mapping value, whether written as a `steps`/`jobs`/… include
(`- template: /pipelines/steps/x.yaml`) or inside an `extends:` block (`template: /pipelines/extends/…`). It is a line scan, not a YAML
parse, so it is robust to the template expressions ADO YAML carries.

Only genuine file references are returned: a value that is a template EXPRESSION (`${{ … }}`) or carries a runtime variable (`$( … )`) is
skipped (its target is not statically known), and a value that does not end in `.yaml` is ignored (it is not a template path). Comment lines
(`#`) never match.

It rests on
[ADR-ADO-TEMPLATE-ABSOLUTEPATHS](../../../../drs/ado/custom-template-discipline.md#rule-adr-ado-template-absolutepaths).

### parameter `Path`

The pipeline YAML file to scan.

### outputs

`[string[]]` The referenced template paths, verbatim (quotes stripped). Empty when the file has none.
