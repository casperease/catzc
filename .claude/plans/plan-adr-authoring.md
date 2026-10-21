---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.Docs/Build-Glossary.ps1,
      pwsh/Catzc.Base.Docs/private/Get-GlossarySourceViolations.ps1,
      docs/adr/repository/controlled-vocabulary.md,
      docs/how-to/getting-started/automation,
      pwsh/Catzc.Base.QualityGates/private/Invoke-LinkEngine.ps1,
      docs/adr/repository/markdown-links.md,
    ]
---

# ADR authoring: one declaration per fact, one how-to, and checks that need no remembering

Lessons from adding ADR-THES-NORMALFORM (catzc-4f, 2026-10-21). Adding one ADR touched seven places (the page, `adrs.yml`, the index build,
glossary entries, the build of the glossary, the domain's `dora-explains.md`, formatting), needed three throwaway `out/*.ps1` scripts to run
the checks, and failed `Test-Glossary` once on a contrast written on one side only. The throwaway scripts are plan-agent-shortcuts' gate
runner, and the plan-edit hook is plan-agent-friction's step 4; this plan follows them and never restates them. Recommended order: step 1
first (it removes a duplicated fact), then 4 (free), then 2, 3 and 5. Every new ADR or defined term pays these costs again, so each moves
from an agent's memory or a failing gate into the tree.

## Open questions

- Q1: How an untracked link target is reported. Recommendation: a finding of its own kind, `pending`, listed but not failing, by the same
  rule on every runner (ADR-AUTO-PARITY): a pipeline checks out a clean commit, so it never meets one, and a devbox stops reporting a new
  file as broken before its commit. Alternatives: keep it an error (the present noise), or a `-AllowUntracked` switch an agent must
  remember.
- Q2: Where the ADR-edit reminder lives. Recommendation: a second entry in the path-to-reminder map of plan-agent-friction's plan-edit hook
  (an edit of `adrs.yml` or a `glossary.yml` prints `Build-AdrIndex` / `Build-Glossary` and the checks to run), as config with one
  mechanism, not a second hook (ADR-PRIN-CONFIG). Alternative: a line in the how-to only.

## Open steps

1. [ ] `pwsh/Catzc.Base.Docs/Build-Glossary.ps1` and `docs/adr/repository/controlled-vocabulary.md`: a contrast is declared once, on either
       term, and the build renders it on both terms' entries; ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED says a contrast is one declaration
       (ADR-PRIN-ONELIVE). Then `private/Get-GlossarySourceViolations.ps1` turns G1 around: a contrast declared on both sides is the
       finding, and a contrast naming a term that does not exist stays one. Then delete the second declaration of each pair from the
       glossary sources, one source file per step, starting with the `eac normal form` / `repository normal form` pair. Check:
       `Invoke-TestFile` on `Build-Glossary.Tests.ps1` and `Get-GlossarySourceViolations.Tests.ps1`, then `Test-Glossary` after each source
       file.
2. [ ] After plan-agent-shortcuts' gate runner: `docs/how-to/getting-started/automation/add-an-adr.md` (new, beside `add-a-doc-chapter.md`):
       from a decision to a landed ADR (the page in its domain folder, the `adrs.yml` ruleset entry, the index and glossary builds, the
       domain's `dora-explains.md` entry, the formatting, the checks through the gate runner). It links the authoring conventions in
       `docs/adr/index.md` and ADR-REPO-ADRCODE, and never restates their rules. Check: `Test-Links -Path` on it and
       `Format-Code -Language markdown` on it.
3. [ ] After Q2 and plan-agent-friction's step 4: the ADR-edit entry in the hook's path-to-reminder map. Check: the hook's test file under
       `Invoke-TestFile`, and an edit of `adrs.yml` in a fresh session prints the reminder.
4. [ ] Delete the memory `adr-citations-follow-domain-deps.md` and its `MEMORY.md` line: `Test-AdrRegistry` already fails a citation outside
       a domain's `depends_on` (its `CitationGraph` fact), so the gate is the one place the rule lives. Check: a file read of `MEMORY.md`.
5. [ ] After Q1: the link engine reports an untracked target as `pending`, and ADR-REPO-LINK states it. Check: `Invoke-TestFile` on the
       `Test-Links` test file with an untracked-target case, then `Test-Links -Path docs/adr/repository/markdown-links.md`.
