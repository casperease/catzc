# Plan: named duration categories for the time safeguard

Status: decided, not built · 2026-10-14 · session catzc-02 (now catzc-9e). Decided: the four terms (gate run, service deployment,
access-point change, history rewrite) and the glossary owners. Open: questions 1 (per-environment defaults) and 2 (who adds `Category` to
`[TimeLimit]`). Origin: the user, relayed by catzc-2a and confirmed in catzc-02 ("plan it first").

## Goal

Every bounded wait in the repository falls into one **named duration category**. Each category has:

- one defined term;
- a sensible default, declared once on the config type (ADR-AUTO-DEFAULT#6) and overridable in `timeouts.yml`;
- one wording, used everywhere: code, config keys, docs, agent instructions and pipeline steps.

Every pipeline step and every command that runs a deployment states its category, so "how long may this take" is never an ad-hoc number.

## What exists today (the base this builds on)

| Limit                 | Where                                                                                              | Value (devbox / pipeline) |
| --------------------- | -------------------------------------------------------------------------------------------------- | ------------------------- |
| Agent foreground call | `limits.<env>.bash.foreground`                                                                     | 3 s / 600 s               |
| Agent background call | `limits.<env>.bash.background`                                                                     | 360 s / 3600 s            |
| pwsh code default     | `limits.<env>.pwsh`                                                                                | 3 s / 600 s               |
| Per executable        | `executables.<name>`                                                                               | per entry                 |
| Per function          | `[TimeLimit(<s>, Pipeline = <s>, Budget = …)]` + `commands.<name>` (catzc-3b, ADR-AUTO-FAILFAST#8) | per decoration            |
| Exempt budget         | `timeout-exemptions.yml` ceiling                                                                   | 600 s / 3600 s            |

Categories add the missing middle layer: a function or step names _what kind of work it is_, and the config says how long that kind of work
may take.

## Proposed categories (the user's three, plus the existing two named)

| Term (proposed)                                                  | Config key                              | Covers                                                                                                                                                                                                                                        | Default devbox / pipeline |
| ---------------------------------------------------------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| **agent probe**                                                  | `limits.<env>.bash.foreground` (exists) | a foreground shell call by Claude or an agent                                                                                                                                                                                                 | 3 s / 600 s               |
| **code default**                                                 | `limits.<env>.pwsh` (exists)            | pwsh work with no category, executable entry or decoration                                                                                                                                                                                    | 3 s / 600 s               |
| **gate run**                                                     | `categories.gate_run`                   | a BVT, a Test-Automation run, a quality gate, a generator: non-deployment verification and build                                                                                                                                              | 360 s / 3600 s            |
| **service deployment**                                           | `categories.service_deployment`         | Azure PaaS and SaaS provisioning: Deploy-Bicep, Deploy-AzureResourceGroup, template deployments                                                                                                                                               | 1800 s / 1800 s           |
| **access-point change**                                          | `categories.access_point_change`        | firewalls and other public access points, whose changes can go through an operations ticket system                                                                                                                                            | 2400 s / 2400 s           |
| **history rewrite** _(decided 2026-10-14; proposed by catzc-25)_ | `categories.history_rewrite`            | rewriting or publishing a git history: Publish-CleanHistory, Reset-GitHubRepository (git push), Remove-TokenFromHistory (git filter-repo), New-SyntheticHistory (git gc --prune=now); today each declares `[TimeLimit(600, Pipeline = 3600)]` | 600 s / 3600 s            |

All four terms were decided on 2026-10-14. "History rewrite" goes into the Tooling.Github glossary, by the same owner split as the rest.
Each is one noun phrase, so it can be bolded once in its defining rule and registered in the glossary.

## Design

1. **Config.** Add `categories:` to `timeouts.yml` / `TimeoutsConfig`:
   - shape: `<snake_case_term>: <s>`, or `{ devbox: <s>, pipeline: <s> }` when the two environments differ;
   - defaults on the type;
   - unknown category keys rejected.
2. **Declaring a category in code.** Extend catzc-3b's attribute: `[TimeLimit(Category = 'gate_run')]` as an alternative to explicit
   seconds. Rules:
   - a decoration names a category **or** seconds, never both, and the attribute constructor rejects both;
   - `Get-TimeoutSeconds -Command` resolves in this order: exemption, `commands` entry, category, decoration seconds, code default;
   - Test-Automation, Test-CatzcBuild and Invoke-TestFile move from `360 / Pipeline 3600` to `Category = 'gate_run'`.
3. **Deployments.**
   - `Deploy-Bicep` and `Deploy-AzureResourceGroup` carry `Category = 'service_deployment'` by default.
   - A template whose resources are an access point declares that in its `options.yml` (`time_category: access_point_change`), and
     `Deploy-Bicep` resolves it from the template, not from the caller (assert-guard style: auto-determined, pinnable with
     `-TimeCategoryAssertIs`).
4. **Pipeline steps.** The pipeline generator writes each step's `timeoutInMinutes` from its category, so ADO's own step timeout and the
   in-process limit agree. An integrity test fails on a deployment step without a category.
5. **ADR.** A new `docs/adr/automation/duration-categories.md` (`ADR-AUTO-DURCAT`) that fixes the language:
   - one rule per category, with its term bolded where it is defined;
   - rules for how a category is declared in code, in templates and in pipeline steps;
   - "every deployment has exactly one category";
   - FAILFAST#7 and #8 cite it; they don't restate it.
6. **Glossary.** One concept per term in the owning glossary source, with `defined_by` pointing to the ADR rule, `realized_by` naming the
   config key, `forms` for families (a **gate run** family: BVT, quality gate, generator), and `avoid` entries for drifting synonyms (for
   example "deploy timeout", "long-running").
7. **Tests.**
   - L0: the config type (defaults, overrides, unknown keys, per-environment shape); attribute validation; the resolution order.
   - L1 integrity: every `Deploy-*` function and every pipeline deployment step resolves to a category; every category term is in the
     glossary.

## Order of work

1. Write the ADR text first, because the language is the point.
2. Config + type + `Get-TimeoutSeconds` resolution + attribute `Category`, with L0 tests.
3. Move the gate-run decorations to the category; decorate the deploy functions; add the template `time_category`.
4. Pipeline `timeoutInMinutes` generation + integrity test.
5. Glossary entries, then the CLAUDE.md and agent wording where a category term replaces a number.

## Open questions

Decided: the four terms (a "BVT" is a _form_ of a gate run, not its own term), and the glossary owners, split by owner ("duration category"
→ a new `Catzc.Base.Timeouts/configs/glossary.yml`; "gate run" → `Catzc.Base.QualityGates`; "service deployment" and "access-point change" →
`Catzc.Azure.Templates`; none in the repository-wide `Catzc.Base.Docs` glossary).

1. **Per-environment defaults.** Should service deployments and access-point changes differ between devbox and pipeline? They would normally
   run only in a pipeline; on a devbox they could keep the same limits, or be refused outside a pipeline.
2. **Coordination.** catzc-3b owns `TimeLimitAttribute` and the `commands` section. Should catzc-3b extend the attribute with `Category`, or
   catzc-02 with catzc-3b's agreement?
