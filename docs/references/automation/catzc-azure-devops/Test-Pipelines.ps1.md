---
catzc:
  immutable:
    with_body_sha: ac2c3a26550c
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops/Test-Pipelines.ps1.md
    folder: docs/references/automation/catzc-azure-devops
    name: test-pipelines-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PIPE-NAME#{1-4,6}
---

# automation/Catzc.Azure.DevOps/Test-Pipelines.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks the pipelines/ tree against the naming-and-placement contract.

### description

Classifies every YAML under pipelines/ with Get-AdoYamlFiles (offline — structure heuristics, no ADO
call), applies the deterministic [ADR-PIPE-NAME](../../../adr/pipelines/pipeline-naming-and-placement.md) rules,
collects every violation, and ends with Write-QualityGateReport
([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35)): the report lands in
out/test-pipelines/, and the gate throws once listing every violation (or returns the result with -PassThru).

Rules enforced (each violation names its rule code, as '`[<rule>]` `pipelines/<file>`: `<message>`'):

```text
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
```

Invoke-AdoScript.ps1 is a `.ps1`, not YAML, so it never enters the scan
([ADR-PIPE-NAME#7](../../../adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name7)). A file that
fails to parse is reported as a violation so a broken pipeline cannot slip through silently.

### parameter Path

The pipelines/ directory to check. Defaults to `<repo>/pipelines`.

### parameter OutputFolder

The report base folder. Defaults to Write-QualityGateReport's (out/test-pipelines).

### parameter PassThru

Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on violations.

### outputs

`[pscustomobject]` With -PassThru only.

### example 1

```powershell
Test-Pipelines
```

### example 2

```powershell
(Test-Pipelines -PassThru).Issues
```

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
