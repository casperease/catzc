---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: meta
  targets:
    [
      docs/adr/thesis/one-source-of-truth.md,
      docs/adr/thesis/truth-stores.md,
      pwsh/Catzc.Base.Docs/configs/glossary.yml,
      docs/explanation/thesis/product-thesis/record.slide.md,
    ]
---

# The listen mode: the repository is the source of truth for delivery state, and SaaS platforms are adjacent stores

The editor's notes 0002 and 0003 (session `out/listen/20261021-005743`, reference pinned at `ed41b3e`, tier `rule`) both change
ADR-THES-ONETRUTH-REPOSITORYISCONFIGURATIONRECORD in `docs/adr/thesis/one-source-of-truth.md:18-21`:

- 0002 sharpens it: delivery state may live outside the repository, in the fact sources ADR-THES-STORES names, but nothing about it **has
  its source of truth (for BVT)** outside it. The sentences that forbid delivery state from living outside follow it.
- 0003 widens it: the adjacent store's examples gain **Azure DevOps Services SaaS and GitHub SaaS** beside a GitOps or configuration
  repository. The places that list the examples follow it.

## Why its value is high

Both are rule-tier corrections to the thesis every domain cites; until the ADR's own context and consequences, the glossary and the record
slide follow, the thesis contradicts itself (`one-source-of-truth.md:100`, `:151`) and the glossary disagrees with the rule that defines the
term.

## Decided

- The editor's edits are fact (ADR-REPO-AI-EDITORISFACT): the notes are corrections, never questions.
- The ADO half of 0003 is plan-truth-stores' (decided 2026-10-21: ADO configuration is an adjacent store, its runtime a fact source); its
  steps 1 and 2 reword ADR-THES-STORES-FACTSOURCEREADONLY, the `adjacent store` glossary entries and `one-source-of-truth.md:105`. This plan
  holds the rest and waits on them for the same lines.

## Open steps

- [ ] `docs/adr/thesis/one-source-of-truth.md:19-20`: "have source of truth" becomes "has its source of truth", and "Azure Devops" becomes
      "Azure DevOps", the editor's meaning kept (the user, 2026-10-21) (check: `Test-Glossary`, `Test-Links` on the page).
- [ ] `docs/adr/thesis/one-source-of-truth.md:100`: "no configuration or operational state has its source of truth outside it", in step with
      line 19 (check: `Test-AdrRegistry`, `Test-Links` on the page).
- [ ] `docs/adr/thesis/one-source-of-truth.md:151`: "Delivery state whose source of truth is outside the repository is a defect, unless …",
      the two exceptions kept (check: `Test-AdrRegistry`, `Test-Links` on the page).
- [ ] `docs/explanation/thesis/product-thesis/record.slide.md:31-32`: "Nothing about delivery state has its source of truth (for BVT)
      outside the repository." (check: `Test-Links` on the slide).
- [ ] `pwsh/Catzc.Base.Docs/configs/glossary.yml:317`, the `adjacent store` short lists "a GitOps or configuration repository, or Azure
      DevOps Services or GitHub SaaS", then `Build-Glossary` (check: `Test-Glossary`).
- [ ] `docs/adr/thesis/truth-stores.md` Fact sources section (`:98-102`) names GitHub SaaS beside Azure DevOps: its configuration an
      adjacent store, its runtime state a fact source (check: `Test-AdrRegistry`, `Test-Links` on the page).
- [ ] `docs/explanation/thesis/product-thesis/record.slide.md:38`: the adjacent store's examples match the rule's (check: `Test-Links` on
      the slide).

## Refs

- Fact-check of 0002: "does not hold" against the reference: `truth-stores.md:98-102` names delivery state held in fact sources, so the
  reference's bare "lives outside" contradicts the thesis; the editor's "source of truth" form resolves it, and the steps above are where
  the contradiction remains. Counter: where the BVT verdict is recorded is not named in the tree (`commit-lifecycle.md:66-68`), and
  "delivery state" is not a glossary term.
- Fact-check of 0003: "partly": the glossary (`glossary.yml:317`) lists only a GitOps repository; `truth-stores.md:33-35` and `:100-104`
  name ADO state as a fact source, which plan-truth-stores' ADO split settles. Counter: a SaaS platform is where the trunk's pipelines run
  and its UI edits state beside the trunk; the ADO split answers it for configuration versus runtime.
- The other `lives outside` matches in docs (`adr/azure/caf/platform-automation-and-devops.md:1453`,
  `adr/azure/waf/operational-excellence.md:175`, `explanation/flow/a-merge-runs-cd-to-prod.md:35`) agree with the fact-source reading and
  stay.
