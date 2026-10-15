---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoYamlInventory.ps1.md
    kind: comment-page
    body_sha: cf5bfcb0f1fa
---

# automation/Catzc.Azure.DevOps/Get-AdoYamlInventory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$pathPrefix = ''`.

```text
ADO YamlPaths are relative to the repo root, but RelativePaths are
relative to the scan root. When scanning a subdirectory (e.g.,
-Path ..\infra\azure-pipelines), there is a prefix mismatch.
Detect it from the data: find a local file whose RelativePath is a
suffix of an ADO YamlPath and extract the prefix.
```
