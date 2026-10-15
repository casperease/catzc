# docs/references/automation/catzc-azure-devops/Get-AdoYamlInventory.ps1.md

`automation/Catzc.Azure.DevOps/Get-AdoYamlInventory.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs Get-AdoYamlFiles to classify files by heuristics, then
Get-AdoPipelineDefinitions to fetch registered pipelines from ADO.
Cross-references the two datasets to:

- Mark each file as registered or not.
- Resolve Unknown classifications: if a file is registered as a
  pipeline in ADO, it is reclassified as Pipeline.
- Attach the ADO pipeline name and ID to registered files.
```

## comment:2

Section `.PARAMETER Exclude` of the comment-based help.

```text
Directory names to skip during scanning. Matched as exact names anywhere in the path.
Defaults to @('.git', 'node_modules', '.terraform').
```

## comment:3

Above `$pathPrefix = ''`.

```text
ADO YamlPaths are relative to the repo root, but RelativePaths are
relative to the scan root. When scanning a subdirectory (e.g.,
-Path ..\infra\azure-pipelines), there is a prefix mismatch.
Detect it from the data: find a local file whose RelativePath is a
suffix of an ADO YamlPath and extract the prefix.
```
