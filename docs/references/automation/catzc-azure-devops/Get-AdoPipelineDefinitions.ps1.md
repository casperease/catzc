---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md
    kind: comment-page
    body_sha: "72f61b92cb30"
---

# automation/Catzc.Azure.DevOps/Get-AdoPipelineDefinitions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Queries the ADO Build Definitions REST API and returns a flattened
list of pipeline definitions with their YAML paths, repository names,
and ADO folder placement.

YamlPath is normalized (leading '/' stripped) to match the RelativePath
output of Get-AdoYamlFiles for easy cross-referencing.
```

## comment:2

Above `$hasProcessDetails = $definitions | Where-Object { $_.process.yamlFilename }...`.

```text
includeAllProperties should return process.yamlFilename inline.
Older ADO Server versions may ignore this — fall back to per-definition fetches.
```

## comment:3

Above `$hasProcessDetails = $definitions | Where-Object { $_.process.yamlFilename }...`.

```text
includeAllProperties should return process.yamlFilename inline.
Older ADO Server versions may ignore this — fall back to per-definition fetches.
```
