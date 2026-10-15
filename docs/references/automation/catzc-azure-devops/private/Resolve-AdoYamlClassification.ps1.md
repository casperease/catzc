# docs/references/automation/catzc-azure-devops/private/Resolve-AdoYamlClassification.ps1.md

`automation/Catzc.Azure.DevOps/private/Resolve-AdoYamlClassification.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Inspects the top-level keys of a parsed YAML dictionary and applies
heuristics to determine whether the file is an Azure DevOps pipeline,
a template (stages/jobs/steps/variables), or unknown.

Returns a PSCustomObject with Classification and TemplateType properties.
TemplateType is set for templates (Stages, Jobs, Steps, Variables) and
$null for non-templates.
```

## comment:2

Section `.PARAMETER Yaml` of the comment-based help.

```text
The parsed YAML object from ConvertFrom-Yaml. Accepts $null for files
that failed to parse — returns Unknown classification.
```
