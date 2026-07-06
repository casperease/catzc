# A pipeline template-kind folder

This folder holds Azure DevOps template fragments of exactly one kind — the folder name is the include-kind contract: `steps/` templates
plug in under `steps:`, `jobs/` under `jobs:`, `stages/` under `stages:`, `variables/` under `variables:`, and `extends/` holds
whole-pipeline templates a thin root pipeline extends. A reader (and a reviewer) knows from the path alone what a template is and where it
plugs in; templates are referenced by absolute path (`/pipelines/<kind>/<name>.yaml`).

An empty kind folder is deliberate, not missing content. Templates are the **exception, not the default**: the default is a self-contained
pipeline of inline YAML, and a fragment is extracted only when it is genuinely, generally reusable — proven by the rule of three — never
speculatively. The folders exist so that when a template earns extraction it has exactly one place to go; they are populated reactively.
Until then the `.gitkeep` keeps the folder tracked.

Templates that do exist here carry **pipeline concerns only** — task selection, service-connection wiring, gates, pool selection, checkout,
token mapping, artifacts. Automation logic, configuration values, and business rules live in the automation layer and are invoked through
the runner; template parameters are ADO controls or meta selection criteria, never config the automation can derive.

The governing decisions are [pipeline-naming-and-placement](../../adr/pipelines/pipeline-naming-and-placement.md) (the per-kind folder
layout and the flat `<type>-<name>.yaml` pipelines above them) and
[custom-template-discipline](../../adr/pipelines/custom-template-discipline.md) (when a template earns its existence, and what it may
carry).
