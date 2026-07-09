# ADR: Pipeline naming and placement

## Rules: ADR-PIPE-NAME

### Rule ADR-PIPE-NAME:1

A pipeline's filename starts with its type — the first hyphen-delimited token is `cron`, `ci`, `cd`, `cde`, `deploy`, or `input`. No other
prefixes.

- [Pipelines live flat in `pipelines/`, named `<type>-<name>.yaml`](#1-pipelines-live-flat-in-pipelines-named-type-nameyaml)

### Rule ADR-PIPE-NAME:2

Pipelines live flat in `pipelines/` — never nested into subfolders; the type prefix is the grouping. The per-kind folders hold templates
only, never registrable pipelines.

- [Pipelines live flat in `pipelines/`, named `<type>-<name>.yaml`](#1-pipelines-live-flat-in-pipelines-named-type-nameyaml)

### Rule ADR-PIPE-NAME:3

A template lives in the folder for its kind (`steps/`, `jobs/`, `stages/`, `variables/`, `extends/`); the folder name is the contract — do
not invent other template folders.

- [Template fragments live in per-kind folders](#2-template-fragments-live-in-per-kind-folders)

### Rule ADR-PIPE-NAME:4

Templates are referenced by absolute path (`/pipelines/<kind>/<name>.yaml`) — fragments via `template:`, whole-pipeline templates via
`extends:`.

- [Template fragments live in per-kind folders](#2-template-fragments-live-in-per-kind-folders)

### Rule ADR-PIPE-NAME:5

An `extends` template is not a pipeline — it defines structure, not an entry point. What gets registered is the thin root
`<type>-<name>.yaml` pipeline that extends it.

- [Template fragments live in per-kind folders](#2-template-fragments-live-in-per-kind-folders)

### Rule ADR-PIPE-NAME:6

Executable YAML is `.yaml`; config/data our code parses is `.yml`. Never mix the two.

- [`.yaml` = executable artifact, `.yml` = config data](#3-yaml--executable-artifact-yml--config-data)

### Rule ADR-PIPE-NAME:7

The runner `Invoke-AdoScript.ps1` stays at the `pipelines/` root — a `.ps1`, not a pipeline or fragment, so it takes no type prefix and is
exempt from the `.yaml` rule.

- [Resulting layout](#resulting-layout)

## Context

The `pipelines/` tree holds two structurally different things: **pipelines** (the entry-point YAML you register and queue in ADO) and
**template fragments** (the reusable `steps` / `jobs` / `stages` / `variables` that pipelines include). Without a fixed layout these mix in
one folder, the include-kind of a fragment is invisible until you open it, and pipelines are not distinguishable from fragments or grouped
by type.

A pipeline's type (cron / ci / cd / cde / deploy / input — see [pipeline-types](pipeline-types.md)) is not a folder; it is encoded as the
**first part of the filename** (`ci-automation.yaml`), so a flat listing of `pipelines/` already groups and reveals pipelines by type.
Fragments, by contrast, are grouped by folder. The filename and the folder are the contract.

This is the same argument as [conventional-folders](../repository/conventional-folders.md): a fixed, semantic layout where the folder name
and the filename are the contract. Tooling and readers program against the names; there is nothing to configure and nothing to guess.

There is also an extension ambiguity: `.yml` vs `.yaml`. We assign each a distinct role so the extension alone tells you whether a file is
an executable ADO artifact or data our code reads.

## Decision

### 1. Pipelines live flat in `pipelines/`, named `<type>-<name>.yaml`

A pipeline (the file ADO registers and runs) sits directly in `pipelines/`, not in a subfolder. Its name **starts with its type** — one of
`cron`, `ci`, `cd`, `cde`, `deploy`, `input` — followed by a descriptive name:

```text
pipelines/ci-automation.yaml
pipelines/cd-shared.yaml
pipelines/cde-frontend.yaml
pipelines/cron-cert-rotation.yaml
pipelines/deploy-release-certification.yaml
pipelines/input-environment-request.yaml
```

The type prefix makes a directory listing of `pipelines/` an index of every pipeline grouped by type.

The prefix is the **authoring convention** — what a human reads and what `pipelines/` groups by. It is not how the inventory tooling decides
what a file is. `Get-AdoYamlFiles` / `Get-AdoYamlInventory` classify each YAML file as Pipeline / Template (with subtype) from its
**top-level YAML keys** (strong signals such as `trigger`, `pr`, `schedules`, `extends`; template signals such as `parameters` + a
`stages`/`jobs`/ `steps`/`variables` body), then `Get-AdoYamlInventory` cross-references **ADO registration data** to resolve anything still
Unknown and to attach the registered pipeline name/id. The filename prefix carries the _intended_ type for readers; the tooling reads
structure and ADO, not the prefix.

### 2. Template fragments live in per-kind folders

ADO templates come in five kinds, each consumed at a distinct site. Four are _fragments_ included into a pipeline (`steps:`, `jobs:`,
`stages:`, `variables:`); the fifth is a _whole-pipeline_ template a thin pipeline **extends**. Each kind gets its own folder, named for its
consumption site:

| Folder                 | Template kind            | Consumed under |
| ---------------------- | ------------------------ | -------------- |
| `pipelines/steps/`     | step templates           | `steps:`       |
| `pipelines/jobs/`      | job templates            | `jobs:`        |
| `pipelines/stages/`    | stage templates          | `stages:`      |
| `pipelines/variables/` | variable templates       | `variables:`   |
| `pipelines/extends/`   | whole-pipeline templates | `extends:`     |

A reader (and a reviewer) knows from the path alone what a template is and where it plugs in. Templates are referenced by **absolute path**
from the repo root (`/pipelines/<kind>/<name>.yaml`), per [custom-template-discipline](custom-template-discipline.md).

These folders define _where_ a template goes, not that templates _should_ be created. The default is a self-contained pipeline of inline
YAML; a template is the exception, extracted only when proven generally reusable — these folders are populated reactively, not filled
proactively. See [custom-template-discipline](custom-template-discipline.md).

**`extends/` is the whole-pipeline case.** An `extends` template defines an entire (usually multi-stage) pipeline; a thin pipeline at the
root supplies only parameters: `extends: { template: /pipelines/extends/<name>.yaml, parameters: { ... } }`. This is the sanctioned
mechanism when many pipelines must share one governed structure — e.g. **customer CD**, where every customer's pipeline extends a single
`extends/cd-customer.yaml` and passes only meta selection criteria (the customer key, the environment). It still answers to
[custom-template-discipline](custom-template-discipline.md): it earns its existence through genuine, proven many-pipeline reuse, and its
parameters are meta keys only — never config the automation layer can derive.

### 3. `.yaml` = executable artifact, `.yml` = config data

- **`.yaml`** — pipelines and template fragments. Anything ADO executes.
- **`.yml`** — configuration/data files our own code reads (`azure.yml`, `options.yml`, `tools.yml`, `ado.yml`, a template's
  `configuration/<env>.yml`, …).

The extension is a one-character classifier: `.yaml` is run by ADO; `.yml` is parsed by us. This is consistent with the rest of the repo,
where every config file is already `.yml`.

### Resulting layout

```text
pipelines/
  Invoke-AdoScript.ps1          # the runner (see pipeline-runner-pattern) — not a pipeline
  ci-automation.yaml            # pipeline  (<type>-<name>.yaml)
  cd-shared.yaml                # pipeline
  cde-frontend.yaml             # pipeline (auto-rolls the locked build to prod — Continuous Deployment)
  cron-cert-rotation.yaml       # pipeline
  deploy-release-certification.yaml # pipeline (governed deploy of a pinned commit)
  input-environment-request.yaml# pipeline
  cd-apex.yaml                  # thin pipeline that `extends:` a whole-pipeline template
  steps/      *.yaml            # step templates
  jobs/       *.yaml            # job templates
  stages/     *.yaml            # stage templates
  variables/  *.yaml            # variable templates
  extends/    *.yaml            # whole-pipeline (extends) templates
```

### Exceptions

- **GitHub Actions** keep their own ecosystem convention under `.github/workflows/` (e.g. a `.yml` workflow). This ADR governs `pipelines/`
  (Azure DevOps), not `.github/`.

## How this is enforced

- **Code review** against this ADR is the primary gate — the uniform layout makes a misplaced fragment or a mis-typed pipeline name visible
  at a glance.
- **`Get-AdoYamlFiles` / `Get-AdoYamlInventory`** scan and classify YAML by top-level-key heuristics (plus ADO registration data, in the
  inventory), distinguishing pipelines from fragments by _structure_ rather than by filename prefix. A pipeline that is not at the root, or
  a fragment outside its kind folder, stands out against the convention.
- **The filename prefix is the authoring contract, not the classifier.** A pipeline's type is its filename prefix for readers and for the
  directory index; the tooling above derives Pipeline-vs-Template from YAML keys and ADO data. A pipeline whose prefix disagrees with its
  structure or its ADO registration is visible as a convention break at review.
- **`Assert-Pipelines` / `Test-Pipelines`** — an automated, offline gate (wired into the Test-Automation L2 suite) that checks the
  `pipelines/` tree against this ADR: the type prefix (:1), flat placement and the closed set of per-kind template folders with matching
  fragment kinds (:2/:3), the `.yaml` extension (:6), and absolute `/pipelines/...` template references (:4). `Test-Pipelines` returns one
  record per violation (with its rule code); `Assert-Pipelines` throws the collected list, so a mis-named or misplaced pipeline fails CI,
  not just review.

## Status

The layout exists; some folders are reserved but unpopulated, by the reactive-creation rule above. `pipelines/steps/` holds the one
extracted step template (`invoke-automation.yaml`) and `pipelines/extends/` holds `cd-customer.yaml`; `pipelines/jobs/`,
`pipelines/stages/`, and `pipelines/variables/` are empty (`.gitkeep` only) — no job, stage, or variable template has earned extraction.

## Consequences

- A listing of `pipelines/` is a typed index of every pipeline; the per-kind folders are a typed index of every fragment. No file needs
  opening to learn what it is.
- The include-kind of a fragment is unambiguous from its path, so an author cannot include a job template where a step template belongs
  without it being obvious.
- Extension alone classifies a file as executable (`.yaml`) or data (`.yml`), which keeps tooling and `grep` honest.
- The layout is rigid by design (the cost of [conventional-folders](../repository/conventional-folders.md)): pipelines cannot be foldered by
  team or domain, and fragment folders are a closed set. The predictability is worth more than the flexibility.

## Dora explains

DORA's research links code organization and consistency to faster review cycles and lower defect introduction rates. This ADR's semantic
layout convention — type-prefixed pipelines in one flat directory and per-kind template folders — eliminates guesswork about structure,
enables tooling and audits to be predictable, and keeps the `pipelines/` directory self-indexing and greppable without opening files.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — conventional layout keeps pipelines organized and instantly
  classifiable by type.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — the directory structure documents what each file is
  without opening it.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — consistent placement enables automated validation and
  tooling built on known patterns.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
