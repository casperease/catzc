---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
    kind: comment-page
    body_sha: "49c18264397f"
    adrs:
      - ADR-PIPE-NAME#1
      - ADR-PIPE-NAME#2
      - ADR-PIPE-NAME#3
      - ADR-PIPE-NAME#4
      - ADR-PIPE-NAME#6
---

# automation/Catzc.Azure.DevOps/Test-Pipelines.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:8

Above `if ($extension -eq '.yml') {`.

```text
[ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6) — executable YAML
under pipelines/ is `.yaml`, never `.yml`.
```

## comment:9

Above `$prefix = ($name -split '-', 2)[0]`.

```text
--- Root of pipelines/ : this is a pipeline entry point. ---
[ADR-PIPE-NAME#1](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name1) — filename
starts with a valid type token.
```

## comment:10

Above `if ($topFolder -notin $templateFolders) {`.

```text
--- Inside a subfolder : must be a per-kind template folder, one level deep. ---
[ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3) — the folder
is in the closed set, and no deeper nesting.
```

## comment:11

Above `if ($record.Classification -eq 'Pipeline') {`.

```text
[ADR-PIPE-NAME#2](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name2) — a
structural pipeline has no business inside a template folder.
```

## comment:12

Above `elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and...`.

```text
[ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3) — a
fragment's structural kind matches its folder (extends/ exempt).
```

## comment:13

Above `foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {`.

```text
[ADR-PIPE-NAME#4](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name4) — template
references are absolute (/pipelines/<kind>/<name>.yaml).
```
