# pwsh/Azure.DevOps/Test-Pipelines.ps1

The quality gate that checks the ado pipelines tree against the naming-and-placement contract and returns its result, one violation per
broken rule.

## help

### synopsis

Checks the ado pipelines tree against the naming-and-placement contract and returns its result.

### description

Classifies every YAML under pipelines/ with Get-AdoYamlFiles (offline — structure heuristics, no ADO call), applies the deterministic
[ADR-ADO-NAME](../../../drs/ado/pipeline-naming-and-placement.md) rules, collects every violation, and ends with Write-QualityGateReport
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the report lands in
out/test-pipelines/, and the gate throws once listing every violation (or returns the result with -PassThru).

Rules enforced (each violation names its rule code, as '`[<rule>]` `pipelines/<file>`: `<message>`'):

```text
[FDR-PIPELINE-EXECUTABLEYAMLEXTENSION](/docs/drs/flow/pipeline-concept.md#rule-fdr-pipeline-executableyamlextension)  Executable YAML is
`.yaml`; there is no `.yml` under pipelines/ (config is `.yml`, but
                it lives outside pipelines/).
[ADR-ADO-NAME-FLATPIPELINESFOLDER](/docs/drs/ado/pipeline-naming-and-placement.md#rule-adr-ado-name-flatpipelinesfolder)  Pipelines live FLAT
in pipelines/. Every `.yaml` is either at the root or directly in a
                per-kind template folder — never deeper, never in another subfolder. A file whose
                STRUCTURE is a pipeline (trigger/pr/…) must be at the root, not inside a template folder.
[ADR-ADO-NAME-TEMPLATEKINDFOLDER](/docs/drs/ado/pipeline-naming-and-placement.md#rule-adr-ado-name-templatekindfolder)  Template folders are
the closed set steps/ jobs/ stages/ variables/ extends/, and a
                fragment's structural kind matches its folder (a steps template lives in steps/, …).
[FDR-PIPELINE-TYPEPREFIX](/docs/drs/flow/pipeline-concept.md#rule-fdr-pipeline-typeprefix)  A root pipeline's
filename starts with its type — cron | ci | cd | cde | deploy | input.
[ADR-ADO-TEMPLATE-ABSOLUTEPATHS](/docs/drs/ado/custom-template-discipline.md#rule-adr-ado-template-absolutepaths)  Templates are
referenced by absolute path (`/pipelines/<kind>/<name>.yaml`), never a
                relative path.
```

Invoke-AdoScript.ps1 is a `.ps1`, not YAML, so it never enters the scan
([ADR-ADO-NAME-RUNNERLOCATION](../../../drs/ado/pipeline-naming-and-placement.md#rule-adr-ado-name-runnerlocation)). A file that fails to
parse is reported as a violation so a broken pipeline cannot slip through silently.

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

## The rules it checks

- **Extension.** Executable YAML under `pipelines/` is `.yaml`, never `.yml`
  ([FDR-PIPELINE-EXECUTABLEYAMLEXTENSION](../../../drs/flow/pipeline-concept.md#rule-fdr-pipeline-executableyamlextension)).
- **Entry points.** A file at the root of `pipelines/` is a pipeline entry point, so its name starts with a valid type token
  ([FDR-PIPELINE-TYPEPREFIX](../../../drs/flow/pipeline-concept.md#rule-fdr-pipeline-typeprefix)).
- **Template folders.** A file in a subfolder sits in a per-kind template folder from the closed set, one level deep
  ([ADR-ADO-NAME-TEMPLATEKINDFOLDER](../../../drs/ado/pipeline-naming-and-placement.md#rule-adr-ado-name-templatekindfolder)).
- **No pipelines in template folders.** A structural pipeline has no business inside a template folder
  ([ADR-ADO-NAME-FLATPIPELINESFOLDER](../../../drs/ado/pipeline-naming-and-placement.md#rule-adr-ado-name-flatpipelinesfolder)).
- **Fragment kind.** A fragment's structural kind matches its folder, and `extends/` is exempt, since it holds a whole pipeline of any body
  (ADR-ADO-NAME-TEMPLATEKINDFOLDER above).
- **Template references.** Every template reference is absolute, `/pipelines/<kind>/<name>.yaml`
  ([ADR-ADO-TEMPLATE-ABSOLUTEPATHS](../../../drs/ado/custom-template-discipline.md#rule-adr-ado-template-absolutepaths)).

A file that fails to parse is itself a violation, since a pipeline ADO cannot read is not compliant.
