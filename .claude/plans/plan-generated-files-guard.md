---
plan:
  status: active
  value: high
  reviewed: 2026-10-23
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1, pwsh/Catzc.Base.QualityGates/private/Get-GeneratedStampDrift.ps1]
---

# Generated files guard: a change to a generated file fails unless its generator renders it

A generated file changes only through its generator (the user, 2026-10-23). A diff to one is legal in git when it is in tune with its
generator: rendering the file from the tree at hand gives exactly the bytes on disk. Any other change, a hand edit or a generator input
changed without the file re-rendered, is a fail, every time, never a warning. The check runs always: in every full run and, when it is fast
enough, at every import.

The tree holds most of the mechanism. `Test-GeneratedFiles` dry-runs every writer `generated-files.yml` registers and every root-config
generator, and `Get-GeneratedStampDrift` compares each generated tracked file's `with_body_sha` against the hash of its body. Gaps today: a
generated file with no head is counted, not failed (`Unstamped`); no fast path checks only the files git sees changed; nothing runs at
import; and no rule says "in tune with its generator" is the one legal change.

## Decided (the user, 2026-10-23)

- At import a stale generated file prints its line and the session starts; the hard fail is the full run's, since a session that cannot
  import cannot regenerate.
- A generated file with no head is guarded by its writer's dry run; the stamp is the fast path only where a head exists (0 unstamped on
  2026-10-23, so no head work is planned).
- The rule is ADR-REPO-FILEMETA-INTUNEWITHGENERATOR, and it names the import's behaviour itself. ADR-AUTO-IMPORTER does not cite it: the
  automation domain may not depend on repository (Test-DrsRegistry), decided by the orchestrator as delegated, 2026-10-23.
- No git pre-commit hook for now: the import and the full run cover it.

## Measured (catzc-46, 2026-10-23, a peer's gate beside it)

`Test-GeneratedFiles` over the tree 5.62 s / 5.06 s, too slow for an import; the stamp check over all 15 stamped files 0.14 s, over only the
git-changed ones 0.03 s to 0.07 s. `Test-Automation` runs Pester files only, and `Test-GeneratedFiles.Tests.ps1` mocks every writer, so
nothing runs the gate over the real tree today. Later (catzc-6b): Build-RootConfig's dry run alone 1.3 s to 1.7 s, so it keeps no lists
and runs on every change; `Test-GeneratedFiles -Changed` with the tree's changes 4.8 s; the import roof is 10 s, twice that (decided by the
orchestrator as delegated).

## Open steps

1. [ ] Import: a post-prompt janitor runs `Test-GeneratedFiles -Changed` under a roof in `pwsh/Catzc.Base.Timeouts/configs/timeouts.yml` (a
       new entry, its default declared once on the config type, set from the measured changed-set time); a stale file prints one line naming
       the file and its regenerate command and the session starts; a bundle (no git work tree) skips it like the other git janitors.
       Import-path file: a burst under `Enter-CatzcBurst.ps1`. Check: `Invoke-TestFile` on the janitor's test file, then one fresh full
       import.
