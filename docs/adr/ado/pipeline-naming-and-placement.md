# ADR: Ado pipeline naming and placement

## Rules: ADR-ADO-NAME

### Rule ADR-ADO-NAME-FLATPIPELINESFOLDER

Pipelines live flat in `.ado/pipelines/` — never nested into subfolders; the type prefix is the grouping. The per-kind folders hold
templates only, never registrable ado pipelines.

- [Pipelines live flat in `.ado/pipelines/`, named `<type>-<name>.yaml`](#1-flat-pipelines)

### Rule ADR-ADO-NAME-TEMPLATEKINDFOLDER

A template lives in the folder for its kind (`steps/`, `jobs/`, `stages/`, `variables/`, `extends/`); the folder name is the contract — do
not invent other template folders.

- [Template fragments live in per-kind folders](#2-per-kind-template-folders)

### Rule ADR-ADO-NAME-ABSOLUTETEMPLATEPATH

Templates are referenced by absolute path (`/.ado/pipelines/<kind>/<name>.yaml`) — fragments via `template:`, whole-pipeline templates via
`extends:`.

- [Template fragments live in per-kind folders](#2-per-kind-template-folders)

### Rule ADR-ADO-NAME-EXTENDSISNOTPIPELINE

An `extends` template is not a pipeline — it defines structure, not an entry point. What gets registered is the thin root
`<type>-<name>.yaml` pipeline that extends it.

- [Template fragments live in per-kind folders](#2-per-kind-template-folders)

### Rule ADR-ADO-NAME-RUNNERLOCATION

The runner `Invoke-AdoScript.ps1` stays at the `.ado/pipelines/` root — a `.ps1`, not a pipeline or fragment, so it takes no type prefix and
is exempt from the `.yaml` rule.

- [Resulting layout](#resulting-layout)

## Context

The `.ado/pipelines/` tree holds two structurally different things: **ado pipelines** (the entry-point YAML you register and queue in ADO)
and **template fragments** (the reusable `steps` / `jobs` / `stages` / `variables` that ado pipelines include). Without a fixed layout these
mix in one folder, the include-kind of a fragment is invisible until you open it, and ado pipelines are not distinguishable from fragments
or grouped by type.

A pipeline's type (cron / ci / cd / cde / deploy / input — see [pipeline-types](../flow/pipeline-types.md)) is not a folder; it is encoded
as the **first part of the filename** (`ci-pwsh.yaml`), so a flat listing of `.ado/pipelines/` already groups and reveals ado pipelines by
type. Fragments, by contrast, are grouped by folder. The filename and the folder are the contract.

This is the same argument as [conventional-folders](../repository/conventional-folders.md): a fixed, semantic layout where the folder name
and the filename are the contract. Tooling and readers program against the names; there is nothing to configure and nothing to guess.

There is also an extension ambiguity: `.yml` vs `.yaml`. We assign each a distinct role so the extension alone tells you whether a file is
an executable ADO artifact or data our code reads.

## Decision

### 1. Flat pipelines

```text
1. Pipelines live flat in `.ado/pipelines/`, named `<type>-<name>.yaml`
```

A pipeline (the file ADO registers and runs) sits directly in `.ado/pipelines/`, not in a subfolder. Its name **starts with its type** — one
of `cron`, `ci`, `cd`, `cde`, `deploy`, `input` — followed by a descriptive name:

```text
.ado/pipelines/ci-pwsh.yaml
.ado/pipelines/cd-shared.yaml
.ado/pipelines/cde-frontend.yaml
.ado/pipelines/cron-cert-rotation.yaml
.ado/pipelines/deploy-release-certification.yaml
.ado/pipelines/input-environment-request.yaml
```

The type prefix makes a directory listing of `.ado/pipelines/` an index of every pipeline grouped by type.

The prefix is the **authoring convention** — what a human reads and what `.ado/pipelines/` groups by. It is not how the inventory tooling
decides what a file is. `Get-AdoYamlFiles` / `Get-AdoYamlInventory` classify each YAML file as Pipeline / Template (with subtype) from its
**top-level YAML keys** (strong signals such as `trigger`, `pr`, `schedules`, `extends`; template signals such as `parameters` + a
`stages`/`jobs`/ `steps`/`variables` body), then `Get-AdoYamlInventory` cross-references **ADO registration data** to resolve anything still
Unknown and to attach the registered pipeline name/id. The filename prefix carries the _intended_ type for readers; the tooling reads
structure and ADO, not the prefix.

### 2. Per-kind template folders

`2. Template fragments live in per-kind folders`

ADO templates come in five kinds, each consumed at a distinct site. Four are _fragments_ included into a pipeline (`steps:`, `jobs:`,
`stages:`, `variables:`); the fifth is a _whole-pipeline_ template a thin pipeline **extends**. Each kind gets its own folder, named for its
consumption site:

| Folder                      | Template kind            | Consumed under |
| --------------------------- | ------------------------ | -------------- |
| `.ado/pipelines/steps/`     | step templates           | `steps:`       |
| `.ado/pipelines/jobs/`      | job templates            | `jobs:`        |
| `.ado/pipelines/stages/`    | stage templates          | `stages:`      |
| `.ado/pipelines/variables/` | variable templates       | `variables:`   |
| `.ado/pipelines/extends/`   | whole-pipeline templates | `extends:`     |

A reader (and a reviewer) knows from the path alone what a template is and where it plugs in. Templates are referenced by **absolute path**
from the repo root (`/.ado/pipelines/<kind>/<name>.yaml`), per [custom-template-discipline](custom-template-discipline.md).

These folders define _where_ a template goes, not that templates _should_ be created. The default is a self-contained pipeline of inline
YAML; a template is the exception, extracted only when proven generally reusable — these folders are populated reactively, not filled
proactively. See [custom-template-discipline](custom-template-discipline.md).

**`extends/` is the whole-pipeline case.** An `extends` template defines an entire (usually multi-stage) pipeline; a thin pipeline at the
root supplies only parameters: `extends: { template: /.ado/pipelines/extends/<name>.yaml, parameters: { ... } }`. This is the sanctioned
mechanism when many ado pipelines must share one governed structure — e.g. **customer CD**, where every customer's pipeline extends a single
`extends/cd-customer.yaml` and passes only meta selection criteria (the customer key, the environment). It still answers to
[custom-template-discipline](custom-template-discipline.md): it earns its existence through genuine, proven many-pipeline reuse, and its
parameters are meta keys only — never config the catzc commands can derive.

### 3. `.yaml` vs `.yml`

```text
3. `.yaml` = executable artifact, `.yml` = config data
```

- **`.yaml`** — ado pipelines and template fragments. Anything ADO executes.
- **`.yml`** — configuration/data files our own code reads (`azure.yml`, `options.yml`, `tools.yml`, `ado.yml`, a template's
  `configuration/<env>.yml`, …).

The extension is a one-character classifier: `.yaml` is run by ADO; `.yml` is parsed by us. This is consistent with the rest of the repo,
where every config file is already `.yml`.

### Resulting layout

```text
.ado/pipelines/
  Invoke-AdoScript.ps1          # the runner (see pipeline-runner-pattern) — not a pipeline
  ci-pwsh.yaml                  # pipeline  (<type>-<name>.yaml)
  cd-shared.yaml                # pipeline
  cde-frontend.yaml             # pipeline (auto-rolls the locked build to prod — Continuous Deployment)
  cron-cert-rotation.yaml       # pipeline
  deploy-release-certification.yaml # pipeline (governed deploy of a pinned commit)
  input-environment-request.yaml# pipeline
  cd-contoso.yaml               # thin pipeline that `extends:` a whole-pipeline template
  steps/      *.yaml            # step templates
  jobs/       *.yaml            # job templates
  stages/     *.yaml            # stage templates
  variables/  *.yaml            # variable templates
  extends/    *.yaml            # whole-pipeline (extends) templates
```

### Exceptions

- **GitHub Actions** keep their own ecosystem convention under `.github/workflows/` (e.g. a `.yml` workflow). This ADR governs
  `.ado/pipelines/` (Azure DevOps), not `.github/`.

## How this is enforced

- **Code review** against this ADR, at the PR gate, is the primary enforcement — the uniform layout makes a misplaced fragment or a
  mis-typed pipeline name visible at a glance.
- **`Get-AdoYamlFiles` / `Get-AdoYamlInventory`** scan and classify YAML by top-level-key heuristics (plus ADO registration data, in the
  inventory), distinguishing ado pipelines from fragments by _structure_ rather than by filename prefix. A pipeline that is not at the root,
  or a fragment outside its kind folder, stands out against the convention.
- **The filename prefix is the authoring contract, not the classifier.** A pipeline's type is its filename prefix for readers and for the
  directory index; the tooling above derives Pipeline-vs-Template from YAML keys and ADO data. A pipeline whose prefix disagrees with its
  structure or its ADO registration is visible as a convention break at review.
- **`Test-Pipelines`** — an offline quality gate
  ([ADR-AUTO-TEST-QUALITYGATE](../automation/test-automation.md#rule-adr-auto-test-qualitygate)) that checks the `.ado/pipelines/` tree
  against this ADR: the type prefix (ADR-FLOW-CD-PIPELINE-TYPEPREFIX), flat placement and the closed set of per-kind template folders with
  matching fragment kinds (ADR-ADO-NAME-FLATPIPELINESFOLDER, ADR-ADO-NAME-TEMPLATEKINDFOLDER), the `.yaml` extension
  (ADR-FLOW-CD-PIPELINE-EXECUTABLEYAMLEXTENSION), and absolute `/.ado/pipelines/...` template references
  (ADR-ADO-NAME-ABSOLUTETEMPLATEPATH). It collects one issue per violation, each naming its rule code, and throws once listing them all; its
  L1 integrity test requires zero issues over the real tree, so a mis-named or misplaced pipeline fails CI, not just review.

## Consequences

- A listing of `.ado/pipelines/` is a typed index of every pipeline; the per-kind folders are a typed index of every fragment. No file needs
  opening to learn what it is.
- The include-kind of a fragment is unambiguous from its path, so an author cannot include a job template where a step template belongs
  without it being obvious.
- Extension alone classifies a file as executable (`.yaml`) or data (`.yml`), which keeps tooling and `grep` honest.
- The layout is rigid by design (the cost of [conventional-folders](../repository/conventional-folders.md)): ado pipelines cannot be
  foldered by team or domain, and fragment folders are a closed set. The predictability is worth more than the flexibility.
