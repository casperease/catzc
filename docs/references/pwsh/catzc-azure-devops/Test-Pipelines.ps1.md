# pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks the pipelines/ tree against the naming-and-placement contract.

### description

Classifies every YAML under pipelines/ with Get-AdoYamlFiles (offline — structure heuristics, no ADO call), applies the deterministic
[ADR-PIPE-NAME](../../../adr/pipelines/pipeline-naming-and-placement.md) rules, collects every violation, and ends with
Write-QualityGateReport ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the report
lands in out/test-pipelines/, and the gate throws once listing every violation (or returns the result with -PassThru).

Rules enforced (each violation names its rule code, as '`[<rule>]` `pipelines/<file>`: `<message>`'):

```text
[ADR-PIPE-NAME-EXECUTABLEYAMLEXTENSION](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-executableyamlextension)  Executable YAML is
`.yaml`; there is no `.yml` under pipelines/ (config is `.yml`, but
                it lives outside pipelines/).
[ADR-PIPE-NAME-FLATPIPELINESFOLDER](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-flatpipelinesfolder)  Pipelines live FLAT
in pipelines/. Every `.yaml` is either at the root or directly in a
                per-kind template folder — never deeper, never in another subfolder. A file whose
                STRUCTURE is a pipeline (trigger/pr/…) must be at the root, not inside a template folder.
[ADR-PIPE-NAME-TEMPLATEKINDFOLDER](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-templatekindfolder)  Template folders are
the closed set steps/ jobs/ stages/ variables/ extends/, and a
                fragment's structural kind matches its folder (a steps template lives in steps/, …).
[ADR-PIPE-NAME-TYPEPREFIX](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-typeprefix)  A root pipeline's
filename starts with its type — cron | ci | cd | cde | deploy | input.
[ADR-PIPE-NAME-ABSOLUTETEMPLATEPATH](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-absolutetemplatepath)  Templates are
referenced by absolute path (`/pipelines/<kind>/<name>.yaml`), never a
                relative path.
```

Invoke-AdoScript.ps1 is a `.ps1`, not YAML, so it never enters the scan
([ADR-PIPE-NAME-RUNNERLOCATION](../../../adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-runnerlocation)). A file that
fails to parse is reported as a violation so a broken pipeline cannot slip through silently.

### parameter `Path`

The pipelines/ directory to check. Defaults to `<repo>/pipelines`.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-pipelines).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on violations.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

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
[ADR-PIPE-NAME-EXECUTABLEYAMLEXTENSION](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-executableyamlextension) — executable YAML
under pipelines/ is `.yaml`, never `.yml`.
```

## comment:2

Above `$prefix = ($name -split '-', 2)[0]`, written with `#`.

```text
--- Root of pipelines/ : this is a pipeline entry point. ---
[ADR-PIPE-NAME-TYPEPREFIX](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-typeprefix) — filename
starts with a valid type token.
```

## comment:3

Above `if ($topFolder -notin $templateFolders) {`, written with `#`.

```text
--- Inside a subfolder : must be a per-kind template folder, one level deep. ---
[ADR-PIPE-NAME-TEMPLATEKINDFOLDER](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-templatekindfolder) — the folder
is in the closed set, and no deeper nesting.
```

## comment:4

Above `if ($record.Classification -eq 'Pipeline') {`, written with `#`.

```text
[ADR-PIPE-NAME-FLATPIPELINESFOLDER](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-flatpipelinesfolder) — a
structural pipeline has no business inside a template folder.
```

## comment:5

Above `elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and...`, written with `#`.

```text
[ADR-PIPE-NAME-TEMPLATEKINDFOLDER](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-templatekindfolder) — a
fragment's structural kind matches its folder (extends/ exempt).
```

## comment:6

Above `foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {`, written with `#`.

```text
[ADR-PIPE-NAME-ABSOLUTETEMPLATEPATH](/docs/adr/pipelines/pipeline-naming-and-placement.md#rule-adr-pipe-name-absolutetemplatepath) — template
references are absolute (/pipelines/<kind>/<name>.yaml).
```
