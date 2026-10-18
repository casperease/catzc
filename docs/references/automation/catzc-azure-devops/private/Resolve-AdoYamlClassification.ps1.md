# automation/Catzc.Azure.DevOps/private/Resolve-AdoYamlClassification.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Classifies a parsed YAML document as Pipeline, Template, or Unknown.

### description

Inspects the top-level keys of a parsed YAML dictionary and applies heuristics to determine whether the file is an Azure DevOps pipeline, a
template (stages/jobs/steps/variables), or unknown.

Returns a PSCustomObject with Classification and TemplateType properties. TemplateType is set for templates (Stages, Jobs, Steps, Variables)
and $null for non-templates.

### parameter Yaml

The parsed YAML object from ConvertFrom-Yaml. Accepts $null for files that failed to parse — returns Unknown classification.

### example 1

```powershell
$yaml = Get-Content 'ci.yml' -Raw | ConvertFrom-Yaml -Ordered
$result = Resolve-AdoYamlClassification -Yaml $yaml
$result.Classification  # 'Pipeline'
$result.TemplateType    # $null
```
