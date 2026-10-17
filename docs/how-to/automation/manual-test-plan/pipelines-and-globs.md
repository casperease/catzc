---
catzc:
  immutable:
    repo_status: clean
    path: docs/how-to/automation/manual-test-plan/pipelines-and-globs.md
    folder: docs/how-to/automation/manual-test-plan
    name: pipelines-and-globs
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-FLOW-CD-GLOBS#10
    links:
      - docs/how-to/automation/manual-test-plan.md
---

# Manual test plan — Pipelines and globs

The Azure DevOps configs, the pipelines tree, and the globset projections that drive pipeline triggers. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                                 | FullNameFilter                                             | Guards                                                                                                                                                                                                                                           |
| --- | ---- | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | L0   | automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1                            | scanning real repo YAML                                    | The repo's ADO YAML is discoverable, parseable, and classifiable.                                                                                                                                                                                |
| 2   | L0   | automation/Catzc.Azure.DevOps/tests/types/AdoConfig.Tests.ps1                             | passes for the shipped ado.yml                             | The shipped `ado.yml` loads through `AdoConfig`.                                                                                                                                                                                                 |
| 3   | L0   | automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1                            | excludes .git directory by default                         | The `.git` directory is excluded from YAML discovery.                                                                                                                                                                                            |
| 4   | L0   | automation/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1 | Shipped build-validation config integrity                  | The shipped build-validation.yml loads through `BuildValidationConfig` (a guarded branch plus well-formed validation entries), and every entry ties to a declared globset that resolves a pipeline.                                              |
| 5   | L1   | automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1                              | Test-Pipelines — real pipelines/ tree                      | The shipped pipelines/ tree satisfies the naming-and-placement contract (ADR-PIPE-NAME): valid type prefixes, flat placement, per-kind template folders, the .yaml extension, and absolute template references.                                  |
| 6   | L2   | automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1                     | ADO pipeline trigger globs match the globset projection    | `Test-AdoPipelineTriggerGlob` reports 0 issues: every pipeline-bound globset's ADO pipeline exists and declares exactly the trigger path filters its projection computes — a `paths:` filter hand-edited out of sync with globs.yml fails.       |
| 7   | L2   | automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1                          | GlobSet independence                                       | `Test-GlobSetIndependence` reports 0 issues: within each layer, no two globsets select a common file on their own contribution (ADR-FLOW-CD-GLOBS#10); the loose-fileset layer is exempt.                                                        |
| 8   | L2   | automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1                       | Native-trigger projection coverage                         | `Test-GlobSetTriggerCoverage` reports 0 issues: over the real tree, every member of a pipeline-bound globset matches at least one ADO include pattern — an include-only trigger is a safe superset that can never under-trigger (miss a deploy). |
| 9   | L2   | automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1                     | GitHub workflow trigger globs match the globset projection | `Test-GitHubWorkflowTriggerGlob` reports 0 issues: the GitHub CI workflow (`.github/workflows/ci-automation.yml`) triggers on exactly the automation globset's native projection — a drifted `paths:` filter fails.                              |
| 10  | L0   | automation/Catzc.Azure.DevOps/tests/types/PipelineEnvConfig.Tests.ps1                     | integrity (shipped config)                                 | The shipped `pipeline-env.yml` loads through `PipelineEnvConfig`: a unique list of environment variable names for the pipeline diagnostic.                                                                                                       |

## Checks

### 1. scanning real repo YAML

**Guards:** the repo's Azure Pipelines YAML is discoverable and parseable.

**Checks:**

- `Get-AdoYamlFiles` returns results with the expected properties; `RelativePath` uses forward slashes.
- Pipeline/template files classify correctly; no file produces a parse error.

### 2. passes for the shipped ado.yml

**Guards:** the shipped `ado.yml` is valid.

**Checks:**

- The shipped `ado.yml` loads through `Get-Config` as an `AdoConfig` (organization, project, tenant).

### 3. excludes .git directory by default

**Guards:** the `.git` directory is excluded from YAML discovery.

**Checks:**

- `Get-AdoYamlFiles -Path <repo>` returns no file under `.git/`.
