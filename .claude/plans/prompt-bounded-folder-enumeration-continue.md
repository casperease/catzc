# Continuation prompt: bounded folder enumeration (paste into a new session)

You are continuing in `C:\projects\catzc`. Read `.claude/CLAUDE.md` and `docs/adr/index.md` first, then in full only the ADRs that govern
the files you touch. The user handles every commit and runs the full `Test-Automation`: never run a mutating git command, and ask before a
whole-suite run. Peer sessions edit the repository at the same time: re-read a file before editing it and leave their work in progress
alone.

## State

The bounded folder enumeration feature is built and migrated (plan: `.claude/plans/plan-bounded-folder-enumeration.md`, memory note
`bounded-folder-enumeration`): module `Catzc.Base.Folders` (`FolderWalker`, `FolderWalkConfig`, `folder-walk.yml`, `Get-ChildPath`),
`ADR-PWSH-ENUM`, every non-test and test call site migrated, analyzer rule `Measure-NoUnboundedEnumeration`.

On 2026-10-16 `test-automation -Output Minimal -Level 2` stopped in `Assert-TestTagGate`. Cause: three tests tagged with an ADR code lacking
`#<n>` (the gate wants `ADR-<CODE>#<n>`; rule must exist in the registry). Fixed on disk:

- `Get-ChildPath.Tests.ps1:69` and `FolderWalker.Tests.ps1:85` -> `ADR-AUTO-FAILFAST#1`
- `FolderWalkConfig.Tests.ps1:75` -> `ADR-CONF-ADDRESSING#1` (the code was also wrong)

## Next

1. Ask the user whether to run the level-2 gate again, or run it in the background: `timeout 330 pwsh -NoProfile -File out/<script>.ps1`
   (script starts with `Set-Location (Split-Path $PSScriptRoot -Parent)`, then `. ./importer.ps1`, then
   `Test-Automation -Output Minimal -Level 2`). Read the output and report faithfully, failures included.
2. If the tag gate passes, later gates may surface other findings. Fix only ones in `Catzc.Base.Folders` or this feature; report the rest
   (known peer issues: `Get-HelpHeadFinding.Tests.ps1:68`, dangling comment links from a deleted comment page).
3. Open, low priority: `folder-walk.yml` head versus `Test-Comments` (repo-wide yml carrier gap in the file-meta rollout; use
   `Format-FileMeta`, never `Format-Code`, on a yml). The `.compiled` DLL re-key is the person's commit.

## Rules learned

- Every new test: tier tag, category tag, and each ADR citation in `ADR-<CODE>#<n>` form naming a real rule (`ADR-PWSH-ERROR#3` style).
- Bash: foreground `timeout: 3000`; long work in the background behind a GNU `timeout <s> <one command>`; no `cd`, pipes or `;` there.
- One file at a time, verify each. Neutral fixture names (`widget`, `gadget`) in L0 tests.
