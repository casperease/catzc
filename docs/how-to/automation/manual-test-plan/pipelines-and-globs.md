# docs/how-to/automation/manual-test-plan/pipelines-and-globs.md

`Manual test plan — Pipelines and globs`

The Azure DevOps configs, the pipelines tree, and the globset projections that drive pipeline triggers. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                                  | FullNameFilter                                             | Guards                                                                                                                                                                                                          |
| --- | ---- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1                             | scanning real repo YAML                                    | The repo's ADO YAML is discoverable, parseable, and classifiable.                                                                                                                                               |
| 2   | L0   | automation/Catzc.Azure.DevOps/tests/Assert-AdoConfig.Tests.ps1                             | passes for the shipped ado.yml                             | The shipped `ado.yml` passes validation.                                                                                                                                                                        |
| 3   | L0   | automation/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1                             | excludes .git directory by default                         | The `.git` directory is excluded from YAML discovery.                                                                                                                                                           |
| 4   | L0   | automation/Catzc.Azure.DevOps.BuildValidation/tests/Assert-BuildValidationConfig.Tests.ps1 | Shipped build-validation config integrity                  | The shipped build-validation.yml loads through Get-Config and its validator (a guarded branch plus well-formed validation entries).                                                                             |
| 5   | L1   | automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1                               | Test-Pipelines — real pipelines/ tree                      | The shipped pipelines/ tree satisfies the naming-and-placement contract (ADR-PIPE-NAME): valid type prefixes, flat placement, per-kind template folders, the .yaml extension, and absolute template references. |
| 6   | L2   | automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1                      | ADO pipeline trigger globs match the globset projection    | Every pipeline-bound globset's ADO pipeline declares exactly the trigger path filters its projection computes — a `paths:` filter hand-edited out of sync with globs.yml fails.                                 |
| 7   | L2   | automation/Catzc.Base.QualityGates/tests/Format-Pipelines.Tests.ps1                        | Repository pipeline formatting integrity                   | The real repository pipeline YAML (**/\*.yaml) is already Prettier-formatted — Format-Pipelines -Check reports no drift.                                                                                        |
| 8   | L2   | automation/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1                           | GlobSet independence                                       | Within every non-loose layer, no two globsets select a common file on their own contribution (ADR-FLOW-CD-GLOBS#10); the loose-fileset layer is exempt.                                                         |
| 9   | L2   | automation/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1                        | Native-trigger projection coverage                         | Over the real tree, every member of a pipeline-bound globset matches at least one ADO include pattern — an include-only trigger is a safe superset that can never under-trigger (miss a deploy).                |
| 10  | L2   | automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1                      | GitHub workflow trigger globs match the globset projection | The GitHub CI workflow (`.github/workflows/ci.yml`) triggers on exactly the automation globset's native projection — a drifted `paths:` filter fails.                                                           |

## Checks

### 1. scanning real repo YAML

**Guards:** the repo's Azure Pipelines YAML is discoverable and parseable.

**Checks:**

- `Get-AdoYamlFiles` returns results with the expected properties; `RelativePath` uses forward slashes.
- Pipeline/template files classify correctly; no file produces a parse error.

### 2. passes for the shipped ado.yml

**Guards:** the shipped `ado.yml` is valid.

**Checks:**

- `Assert-AdoConfig` accepts the shipped `ado.yml` (organization, project, tenant).

### 3. excludes .git directory by default

**Guards:** the `.git` directory is excluded from YAML discovery.

**Checks:**

- `Get-AdoYamlFiles -Path <repo>` returns no file under `.git/`.
