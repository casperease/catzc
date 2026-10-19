---
plan:
  status: active
  value: medium
  reviewed: 2026-10-19
  targets: [docs/adr/automation, docs/adr/pwsh, docs/adr/index.md]
---

# Separate generalized automation ADRs from the pwsh ones

`docs/adr/automation/` holds the generalized automation ADRs (no PowerShell language). `docs/adr/automation/pwsh/` holds the
PowerShell-specific ones. `docs/references/pwsh/` holds the reference docs for the pwsh modules in the root `pwsh/` folder.

## Why its value is medium

The folder mixes language-agnostic rules with language ones, and the top-level `docs/adr/pwsh/` and `automation/powershell/` duplicate the
home the pwsh rules should have.

## Decided (2026-10-19, from the user)

- Layout: `automation/` general, `automation/pwsh/` PowerShell, `docs/references/pwsh/` module references.
- `bash`, `go`, `python` and `BCL` follow the same pattern: language-specific ADRs under `docs/adr/automation/<language>/`.
- By consequence, the top-level `docs/adr/pwsh/` and `automation/powershell/` fold into `automation/pwsh/`: one living version.

## Open steps

- [ ] Create `docs/adr/automation/pwsh/` and move one ADR at a time from `docs/adr/pwsh/` and `automation/powershell/`, with
      `Update-AdrCitation` re-citing the codes (check: Test-Adr and Test-Links clean after each move).
- [ ] Sort the flat files in `docs/adr/automation/` into general or language-specific, naming each file's destination before moving it
      (check: the table of destinations is in this plan, the user's answer on any doubtful file recorded).
- [ ] Move the `bash`, `go`, `python` and `BCL` ADRs that are in the wrong place the same way (check: Test-Adr clean).
- [ ] Update `docs/adr/index.md` and `pwsh/Catzc.Base.Docs/configs/adrs.yml` for the new domains and codes (check: Test-Adr clean).

## Refs

- docs/adr/index.md; memory: adr-pwsh-split (the earlier ADR-PWSH split this builds on).
