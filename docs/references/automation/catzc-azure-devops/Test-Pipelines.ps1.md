---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ac2c3a26550c
    adrs:
      - ADR-PIPE-NAME#{1-4,6}
---

# automation/Catzc.Azure.DevOps/Test-Pipelines.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($extension -eq '.yml') {`, written with `#`.

```text
[ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6) — executable YAML
under pipelines/ is `.yaml`, never `.yml`.
```

## comment:2

Above `$prefix = ($name -split '-', 2)[0]`, written with `#`.

```text
--- Root of pipelines/ : this is a pipeline entry point. ---
[ADR-PIPE-NAME#1](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name1) — filename
starts with a valid type token.
```

## comment:3

Above `if ($topFolder -notin $templateFolders) {`, written with `#`.

```text
--- Inside a subfolder : must be a per-kind template folder, one level deep. ---
[ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3) — the folder
is in the closed set, and no deeper nesting.
```

## comment:4

Above `if ($record.Classification -eq 'Pipeline') {`, written with `#`.

```text
[ADR-PIPE-NAME#2](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name2) — a
structural pipeline has no business inside a template folder.
```

## comment:5

Above `elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and...`, written with `#`.

```text
[ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3) — a
fragment's structural kind matches its folder (extends/ exempt).
```

## comment:6

Above `foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {`, written with `#`.

```text
[ADR-PIPE-NAME#4](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name4) — template
references are absolute (/pipelines/<kind>/<name>.yaml).
```
