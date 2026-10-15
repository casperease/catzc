---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
    kind: comment-page
    body_sha: e228d4fdad28
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PIPE-NAME#1
      - ADR-PIPE-NAME#2
      - ADR-PIPE-NAME#3
      - ADR-PIPE-NAME#4
      - ADR-PIPE-NAME#6
      - ADR-PIPE-NAME#7
---

# automation/Catzc.Azure.DevOps/Test-Pipelines.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Classifies every YAML under pipelines/ with Get-AdoYamlFiles (offline — structure heuristics, no ADO
call), applies the deterministic [ADR-PIPE-NAME](/docs/adr/pipelines/pipeline-naming-and-placement.md) rules,
collects every violation, and ends with Write-QualityGateReport
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): the report lands in
out/test-pipelines/, and the gate throws once listing every violation (or returns the result with -PassThru).

Rules enforced (each violation names its rule code, as '[<rule>] pipelines/<file>: <message>'):

  [ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6)  Executable YAML is
  `.yaml`; there is no `.yml` under pipelines/ (config is `.yml`, but
                  it lives outside pipelines/).
  [ADR-PIPE-NAME#2](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name2)  Pipelines live FLAT
  in pipelines/. Every `.yaml` is either at the root or directly in a
                  per-kind template folder — never deeper, never in another subfolder. A file whose
                  STRUCTURE is a pipeline (trigger/pr/…) must be at the root, not inside a template folder.
  [ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3)  Template folders are
  the closed set steps/ jobs/ stages/ variables/ extends/, and a
                  fragment's structural kind matches its folder (a steps template lives in steps/, …).
  [ADR-PIPE-NAME#1](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name1)  A root pipeline's
  filename starts with its type — cron | ci | cd | cde | deploy | input.
  [ADR-PIPE-NAME#4](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name4)  Templates are
  referenced by absolute path (`/pipelines/<kind>/<name>.yaml`), never a
                  relative path.

Invoke-AdoScript.ps1 is a `.ps1`, not YAML, so it never enters the scan
([ADR-PIPE-NAME#7](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name7)). A file that
fails to parse is reported as a violation so a broken pipeline cannot slip through silently.
```

## comment:2

Above `if ($extension -eq '.yml') {`.

```text
[ADR-PIPE-NAME#6](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name6) — executable YAML
under pipelines/ is `.yaml`, never `.yml`.
```

## comment:3

Above `$prefix = ($name -split '-', 2)[0]`.

```text
--- Root of pipelines/ : this is a pipeline entry point. ---
[ADR-PIPE-NAME#1](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name1) — filename
starts with a valid type token.
```

## comment:4

Above `if ($topFolder -notin $templateFolders) {`.

```text
--- Inside a subfolder : must be a per-kind template folder, one level deep. ---
[ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3) — the folder
is in the closed set, and no deeper nesting.
```

## comment:5

Above `if ($record.Classification -eq 'Pipeline') {`.

```text
[ADR-PIPE-NAME#2](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name2) — a
structural pipeline has no business inside a template folder.
```

## comment:6

Above `elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and...`.

```text
[ADR-PIPE-NAME#3](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name3) — a
fragment's structural kind matches its folder (extends/ exempt).
```

## comment:7

Above `foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {`.

```text
[ADR-PIPE-NAME#4](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name4) — template
references are absolute (/pipelines/<kind>/<name>.yaml).
```
