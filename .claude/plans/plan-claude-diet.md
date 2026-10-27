---
plan:
  status: active
  value: medium
  reviewed: 2026-10-27
  class: meta
  targets:
    [
      .claude/skills/catzc-run/SKILL.md,
      .claude/skills/catzc-module/SKILL.md,
      .claude/skills/catzc-verify/SKILL.md,
      .claude/skills/catzc-core/SKILL.md,
      .claude/skills/plan-orchestrate/SKILL.md,
    ]
---

# Claude diet: each rediscovered trap moved to the one skill line a session reads

The hindsight log of 2026-10-27 judged every learning in `.claude/learnings/` against the tree. The half verdicts below are facts the tree
holds only in code, a reference page or a record, where a session does not look from its start, and that sessions paid for again and again.
Each moves to the one skill a session already loads for that job, never to `.claude/CLAUDE.md`.

## Why its value is medium

The weight per session start is about 139 KB (`.claude/CLAUDE.md` 9.7 KB plus the plans the master points at, about 120 KB; nothing reads
the learnings or hindsight logs at start), and per drone spawn about 11 KB (a drone file 2.2 KB, `catzc-core` 2.2 KB, `catzc-run` 4.1 KB,
the job skill about 2.5 KB); tokens are bytes / 4, an estimate. The five heaviest files are `plan-debt-azure-gaps.md` (18.9 KB),
`value-of-plan.md` (13.3 KB), `plan-adr-term.md` (13.2 KB), `plan-catzc-cats-usage.md` (10.6 KB) and `.claude/CLAUDE.md` (9.7 KB). The steps
add about 1.5 KB of skill text in all and each saves a rediscovery that cost a failed burst or a wasted run, recorded at least once in the
learnings.

## Open questions

- `.claude/CLAUDE.md`'s "Run PowerShell yourself" paragraph (about 1.3 KB per session start) restates `catzc-run` and
  ADR-REPO-AI-SMALLTESTSDIRECTLY; recommend cutting it to one line that points at `catzc-run`, since CLAUDE.md is the user's file.
- `.claude/CLAUDE.md`'s Sub-agents section never says a capability name is `<domain>-<job>`, which CapabilityEntry refuses otherwise;
  recommend one clause there, the user's file.

## Open steps

- [ ] Susan from HR: "If only the test counter had read the row type" and five siblings (the test path by name, the type-hash memo, the
      refused burst, the gate between two bursts, the timeout lookup): each cost a failed run or a stuck import in the learnings. Edit
      `.claude/skills/catzc-run/SKILL.md` step 4 with one clause each: `Invoke-TestFile -PassThru` returns Rows counted by Result; a test
      file is passed by name, never under a dot-folder path; a stale `stamp-*.json` under the per-user types folder is deleted as the safe
      unblock; a staged burst refused for a busy run lock changed nothing and is retried as is; a red verdict read between two bursts is
      re-run after the last; a private step takes its limit by `-Executable` (check: a Grep of the skill finds `Rows`, `dot-folder`,
      `stamp-`, `retried as is` and `-Executable`, and `Test-AgentDefinitions` reports 0 issues).
- [ ] Susan from HR: "If only the rename author had grepped every reader and spelling before the first burst" with the contract-type, help,
      verb, fixture-prefix, config-folder and config-default halves: each rename or type change cost one failed burst per missed reader.
      Edit `.claude/skills/catzc-module/SKILL.md` with one step line: before the first burst of a rename or a type change, grep every reader
      and spelling (code, types, test fixture builders); help synopses live on the comment page; a code transform is `ConvertTo-`, never
      `Format-`; `Catzc.` and `CATZC_` stay in fixtures where the code under test filters on them; a config may be a folder of parts that
      `Get-Config` merges; a config's defaults are read on its C# type (check: a Grep of the skill finds `every reader`, `ConvertTo-` and
      `folder of parts`, and `Test-AgentDefinitions` reports 0 issues).
- [ ] Susan from HR: "If only the C# splitter had been told one public class per types file" with the accosted-scope, staged-format,
      tracked-only and trailing-star halves: each one cost a red final check. Edit `.claude/skills/catzc-verify/SKILL.md` with one clause
      each: a `types/<Name>.cs` declares one public class `<Name>`, no partial class; a new file naming the accosted word gets its scope
      line in `pwsh/Base.QualityGates/configs/terminology/reserved.yml`; a staged `.cs` is formatted in place as the burst's first step; a
      gate that reads tracked files only reads an uncommitted file red, reported as owed; plan text names a rule family without a trailing
      star (check: a Grep of the skill finds `no partial`, `reserved.yml` and `trailing star`, and `Test-AgentDefinitions` reports 0
      issues).
- [ ] Susan from HR: "If only the DRS briefer had sized the slice": two drones stopped at their turn roof on a whole domain. Edit
      `.claude/skills/catzc-core/SKILL.md` step 3 so a decision-record review brief holds under ten records (check: a Grep of the skill
      finds `under ten records`, and `Test-AgentDefinitions` reports 0 issues).
- [ ] Susan from HR: "If only the messenger had known prompting mode holds messages" and "If only the waiter had known the harness's idle
      subscription": a re-ping and a reassigned burst each. Edit `.claude/skills/plan-orchestrate/SKILL.md` step 6 so a repeated idle
      timestamp reads as a message waiting on the user's approval, and an idle subscription is made once (check: a Grep of the skill finds
      `prompting mode`, and `Test-AgentDefinitions` reports 0 issues).

## Refs

- The hindsight log `.claude/hindsight/`, Jack's lines of 2026-10-27; ADR-REPO-PLANS; the debt-reduce skill.
