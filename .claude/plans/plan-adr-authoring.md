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
    ]
---

# ADR authoring: one declaration per fact, one how-to, and checks that need no remembering

Lessons from adding ADR-THES-NORMALFORM (catzc-4f, 2026-10-21). Adding one ADR touched seven places (the page, `adrs.yml`, the index build,
glossary entries, the build of the glossary, the domain's `dora-explains.md`, formatting), needed three throwaway `out/*.ps1` scripts to run
the checks, and failed `Test-Glossary` once on a contrast written on one side only. The throwaway scripts are plan-agent-shortcuts' gate
runner, and the plan-edit hook is plan-agent-friction's step 4; this plan follows them and never restates them. Recommended order: step 1
first (it removes a duplicated fact), then 4 (free), then 2 and 3. Every new ADR or defined term pays these costs again, so each moves from
an agent's memory or a failing gate into the tree.

## Decided (the user, 2026-10-21, decision round)

- **An untracked link target stays a failing finding**, as the tree has it (`LinkFindingType.Untracked`): a pipeline's clean checkout
  reports the same link as Dangling and fails, so a devbox-only `pending` kind would break ADR-AUTO-PARITY-CHECKEDEQUALLY. The fix for a new
  file stays its commit.
- **The ADR-edit reminder is an entry in the plan-edit hook's path-pattern map** (plan-agent-friction's step 4): an edit of `adrs.yml` or
  any `*/configs/glossary.yml` prints `Build-AdrIndex` / `Build-Glossary` and the checks to run; one mechanism, config entries
  (ADR-PRIN-CONFIG).

## Open steps

1. [ ] `pwsh/Catzc.Base.Docs/Build-Glossary.ps1` and `docs/adr/repository/controlled-vocabulary.md`: a contrast is declared once, on either
       term, and the build renders it on both terms' entries; ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED says a contrast is one declaration
       (ADR-PRIN-ONELIVE). Then `private/Get-GlossarySourceViolations.ps1` turns G1 around: a contrast declared on both sides is the
       finding, and a contrast naming a term that does not exist stays one. Then delete the second declaration of each pair from the
       glossary sources, one source file per step, starting with the `eac normal form` / `repository normal form` pair. Check:
       `Invoke-TestFile` on `Build-Glossary.Tests.ps1` and `Get-GlossarySourceViolations.Tests.ps1`, then `Test-Glossary` after each source
       file.
2. [ ] `docs/how-to/getting-started/automation/add-an-adr.md` (new, beside `add-a-doc-chapter.md`; the gate runner it names,
       `pwsh/.internal/assets/Invoke-CatzcCommand.ps1`, has landed): from a decision to a landed ADR (the page in its domain folder, the
       `adrs.yml` ruleset entry, the index and glossary builds, the domain's `dora-explains.md` entry, the formatting, the checks through
       the gate runner). It links the authoring conventions in `docs/adr/index.md` and ADR-REPO-ADRCODE, and never restates their rules.
       Check: `Test-Links -Path` on it and `Format-Code -Language markdown` on it.
3. [ ] After plan-agent-friction's step 4: the ADR-edit entry in the hook's path-to-reminder map. Check: the hook's test file under
       `Invoke-TestFile`, and an edit of `adrs.yml` in a fresh session prints the reminder.
4. [ ] Delete the memory `adr-citations-follow-domain-deps.md` and its `MEMORY.md` line: `Test-AdrRegistry` already fails a citation outside
       a domain's `depends_on` (its `CitationGraph` fact), so the gate is the one place the rule lives. Check: a file read of `MEMORY.md`.
