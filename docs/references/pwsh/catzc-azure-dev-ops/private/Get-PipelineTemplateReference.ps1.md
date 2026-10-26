# pwsh/Azure.DevOps/private/Get-PipelineTemplateReference.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
[ADR-ADO-NAME-ABSOLUTETEMPLATEPATH](../../../../drs/ado/pipeline-naming-and-placement.md#rule-adr-ado-name-absolutetemplatepath).

### parameter `Path`

The pipeline YAML file to scan.

### outputs

`[string[]]` The referenced template paths, verbatim (quotes stripped). Empty when the file has none.
