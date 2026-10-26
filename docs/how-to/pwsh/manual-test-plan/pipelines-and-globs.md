# Manual test plan — Pipelines and globs

The Azure DevOps configs, the ado pipelines tree, and the globset projections that drive pipeline triggers. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                            |
| --- | ---- | ---------------------------------------------------------------- |
| 1   | L0   | [scanning real repo YAML][c1]                                    |
| 2   | L0   | [passes for the shipped ado.yml][c2]                             |
| 3   | L0   | [excludes .git directory by default][c3]                         |
| 4   | L0   | [Shipped build-validation config integrity][c4]                  |
| 5   | L1   | [Test-Pipelines — real .ado/pipelines/ tree][c5]                 |
| 6   | L2   | [ADO pipeline trigger globs match the globset projection][c6]    |
| 7   | L2   | [GlobSet independence][c7]                                       |
| 8   | L2   | [Native-trigger projection coverage][c8]                         |
| 9   | L2   | [GitHub workflow trigger globs match the globset projection][c9] |
| 10  | L0   | [integrity (shipped config)][c10]                                |
| 11  | L0   | [integrity (shipped config)][c11]                                |
| 12  | L2   | [Repository unit aspects (every laid-out unit)][c12]             |
| 13  | L1   | [Get-RepositoryFilter — the real repository][c13]                |
| 14  | L1   | [Build-TrackGlobSets — the real tree][c14]                       |

[c1]: #1-scanning-real-repo-yaml
[c2]: #2-passes-for-the-shipped-adoyml
[c3]: #3-excludes-git-directory-by-default
[c4]: #4-shipped-build-validation-config-integrity
[c5]: #5-test-pipelines--real-adopipelines-tree
[c6]: #6-ado-pipeline-trigger-globs-match-the-globset-projection
[c7]: #7-globset-independence
[c8]: #8-native-trigger-projection-coverage
[c9]: #9-github-workflow-trigger-globs-match-the-globset-projection
[c10]: #10-integrity-shipped-config
[c11]: #11-integrity-shipped-config
[c12]: #12-repository-unit-aspects-every-laid-out-unit
[c13]: #13-get-repositoryfilter--the-real-repository
[c14]: #14-build-trackglobsets--the-real-tree

## Checks

### 1. scanning real repo YAML

**Test file:** `pwsh/Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1` (L0), block `scanning real repo YAML`.

**Guards:** the repo's Azure Pipelines YAML is discoverable and parseable.

**Checks:**

- `Get-AdoYamlFiles` returns results with the expected properties; `RelativePath` uses forward slashes.
- Pipeline/template files classify correctly; no file produces a parse error.

### 2. passes for the shipped ado.yml

**Test file:** `pwsh/Azure.DevOps/tests/types/AdoConfig.Tests.ps1` (L0), block `passes for the shipped ado.yml`.

**Guards:** the shipped `ado.yml` is valid.

**Checks:**

- The shipped `ado.yml` loads through `Get-Config` as an `AdoConfig` (organization, project, tenant).

### 3. excludes .git directory by default

**Test file:** `pwsh/Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1` (L0), block `excludes .git directory by default`.

**Guards:** the `.git` directory is excluded from YAML discovery.

**Checks:**

- `Get-AdoYamlFiles -Path <repo>` returns no file under `.git/`.

### 4. Shipped build-validation config integrity

**Test file:** `pwsh/Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1` (L0), block
`Shipped build-validation config integrity`.

**Guards:** The shipped build-validation.yml loads through `BuildValidationConfig` (a guarded branch plus well-formed validation entries),
and every entry ties to a declared globset that resolves a pipeline.

### 5. Test-Pipelines — real .ado/pipelines/ tree

**Test file:** `pwsh/Azure.DevOps/tests/Test-Pipelines.Tests.ps1` (L1), block `Test-Pipelines — real .ado/pipelines/ tree`.

**Guards:** The shipped .ado/pipelines/ tree satisfies the naming-and-placement contract (ADR-ADO-NAME): valid type prefixes, flat
placement, per-kind template folders, the .yaml extension, and absolute template references.

### 6. ADO pipeline trigger globs match the globset projection

**Test file:** `pwsh/Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1` (L2), block
`ADO pipeline trigger globs match the globset projection`.

**Guards:** `Test-AdoPipelineTriggerGlob` reports 0 issues: every pipeline-bound globset's ADO pipeline exists and declares exactly the
trigger path filters its projection computes — a `paths:` filter hand-edited out of sync with globs.yml fails.

### 7. GlobSet independence

**Test file:** `pwsh/Base.Globs/tests/GlobSet-Independence.Tests.ps1` (L2), block `GlobSet independence`.

**Guards:** `Test-GlobSetIndependence` reports 0 issues: within each layer, no two globsets select a common file on their own contribution
(FDR-CD-GLOBS-NOOVERLAPWITHINLAYER); the loose-fileset layer is exempt.

### 8. Native-trigger projection coverage

**Test file:** `pwsh/Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1` (L2), block `Native-trigger projection coverage`.

**Guards:** `Test-GlobSetTriggerCoverage` reports 0 issues: over the real tree, every member of a pipeline-bound globset matches at least
one ADO include pattern — an include-only trigger is a safe superset that can never under-trigger (miss a deploy).

### 9. GitHub workflow trigger globs match the globset projection

**Test file:** `pwsh/Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1` (L2), block
`GitHub workflow trigger globs match the globset projection`.

**Guards:** `Test-GitHubWorkflowTriggerGlob` reports 0 issues: the GitHub CI workflow (`.github/workflows/ci-pwsh.yml`) triggers on exactly
the pwsh globset's native projection — a drifted `paths:` filter fails.

### 10. integrity (shipped config)

**Test file:** `pwsh/Azure.DevOps/tests/types/PipelineEnvConfig.Tests.ps1` (L0), block `integrity (shipped config)`.

**Guards:** The shipped `pipeline-env.yml` loads through `PipelineEnvConfig`: a unique list of environment variable names for the pipeline
diagnostic.

### 11. integrity (shipped config)

**Test file:** `pwsh/Azure.DevOps/tests/types/EnvironmentApprovalsConfig.Tests.ps1` (L0), block `integrity (shipped config)`.

**Guards:** The shipped `environment-approvals.yml` loads through `EnvironmentApprovalsConfig`: the approver group, the timeout and the
prod-tier environments that `Sync-AdoEnvironmentApprovals` applies.

### 12. Repository unit aspects (every laid-out unit)

**Test file:** `pwsh/Base.Globs/tests/Get-ModuleGlobSet.Repository.Tests.ps1` (L2), block `Repository unit aspects (every laid-out unit)`.

**Guards:** Every laid-out unit derives a tests set that claims at least one tracked file, and `tests_optional` names only units that have
one.

### 13. Get-RepositoryFilter — the real repository

**Test file:** `pwsh/Base.Globs/tests/Get-RepositoryFilter.Tests.ps1` (L1), block `Get-RepositoryFilter — the real repository`.

**Guards:** The shipped repository filters resolve over the real tree, each to the include and exclude sets it claims by.

### 14. Build-TrackGlobSets — the real tree

**Test file:** `pwsh/Base.Globs/tests/Build-TrackGlobSets.Tests.ps1` (L1), block `Build-TrackGlobSets — the real tree`.

**Guards:** The committed `track-sets.yml` is what `Build-TrackGlobSets` derives from the track members (FDR-CD-GLOBS-TRACKSETDERIVED): the
infrastructure set leaves out its generated READMEs, and the pwsh set keeps the vendored modules nested under it, which have no pipeline of
their own.

### 15. Build-TrackGlobSets — its assets

**Test file:** `pwsh/Base.Globs/tests/Build-TrackGlobSets.Tests.ps1` (L1), block `Build-TrackGlobSets — its assets`.

**Guards:** `Build-TrackGlobSets` reads its declared part and writes its derived part where the module ships them, in the repository and in
a bundle (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).
