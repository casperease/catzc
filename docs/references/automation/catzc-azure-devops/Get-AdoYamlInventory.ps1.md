---
catzc:
  immutable:
    with_body_sha: dafdffdecc9e
    path: docs/references/automation/catzc-azure-devops/Get-AdoYamlInventory.ps1.md
    folder: docs/references/automation/catzc-azure-devops
    name: get-ado-yaml-inventory-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps/Get-AdoYamlInventory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pathPrefix = ''`, written with `#`.

```text
ADO YamlPaths are relative to the repo root, but RelativePaths are
relative to the scan root. When scanning a subdirectory (e.g.,
-Path ..\infra\azure-pipelines), there is a prefix mismatch.
Detect it from the data: find a local file whose RelativePath is a
suffix of an ADO YamlPath and extract the prefix.
```
