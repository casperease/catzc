---
task:
  id: "005"
  status: done (the agent-contracts page deletion is the user's git rm)
  plans: [plan-adr-ai]
  value: high
  blocked_on: nothing (D14 answered 2026-10-17: keep ADR-AI)
  targets:
    [
      automation/Catzc.Base.Docs/configs/adrs.yml,
      docs/adr/index.md,
      docs/adr/repository/dora-explains.md,
      docs/adr/repository/ai-agent-contract.md,
      docs/references/agent-contracts.md,
      .claude/CLAUDE.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task005.md"
    folder: plans
    name: task005
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AI#5
---

# task005: register ADR-AI

The ADR exists (docs/adr/repository/ai-agent-contract.md, 13 rules, head declares ADR-AI#{1-13}) and agents.yml names it once as
`contracts: [ADR-AI]`. It is not in adrs.yml, so Test-AdrRegistry reports it and the index does not list it. One file per step, verified
before the next; the index is generated, never edited by hand.

## Correction (2026-10-17)

Step 1's read was right about `AdrCodeForm.cs` and wrong about the registry: `AdrsConfig.cs` line 42 validates every `external:` against
`^ADR-[A-Z]{2,4}(-[A-Z]+)+$`, so step 2's entry made adrs.yml invalid and every import failed in the index janitor
(`AdrsConfig.Tests.ps1`, `Test-AdrRegistry` and the plan link check all died at import with "external 'ADR-AI' must be ADR-<DC>-<NAME>").
The entry was reverted, the user answered D14 the same hour (keep `ADR-AI`), and the task went on as (a): `AdrsConfig.ExternalRe` widened
to `^ADR-[A-Z]+(-[A-Z]+)*$`, a one-segment external skips the domain-segment match, two tests added (`AdrsConfig.Tests.ps1`, 27 pass,
`out/test-file/20261017-061016-0dfa4d`), the two comment pages (`AdrsConfig.cs.md`, `adrs.yml.md`) brought to the new form, then the
entry added again. A `types/*.cs` edit means a new `automation/.compiled/Catzc.Types.<hash>.dll`; staging it is the user's.

## Steps, as run (every gate line verbatim)

1. [x] D14 answered by the user, not by a read; recorded in plan-adr-ai (Decided), task004 (D14 line) and plan-adr-cats (same form).
2. [x] `adrs.yml`: `ai-agent-contract: { external: ADR-AI }` after `agent-definitions`; the `concern: [automation]` the step named is the
   repository domain's default and so not repeated. Check: `[Invoke-TestFile] Passed (in-place)` for AdrsConfig.Tests.ps1;
   `[Write-QualityGateReport] No adr-registry issues found.` (`out/test-adr-registry/20261017-061143`).
3. [x] `dora-explains.md`: "## The agent contract" after "Agent definitions", registry order, with small-batches, change-approval and AI-stance
   links. Check: `[Write-QualityGateReport] No links issues found.` (`out/test-links/20261017-061025`); the dora coverage check is part of
   the clean Test-AdrRegistry run above.
4. [x] `Build-AdrIndex` run; `docs/adr/index.md` line 329 lists `ADR-AI` under repository. Check: `[Write-QualityGateReport] No
   generated-files issues found.` (`out/test-generated-files/20261017-061237`). The index was peer-dirty before this task; the import-time
   janitor regenerates it on every import, so the regeneration carries the peer's registry state as well as this one.
5. [x] `ai-agent-contract.md` Context: one paragraph absorbs the agent-contracts page (closed key set, a constant declared once, the two
   places the contract is named); 99 lines with its head. Check: `[Write-QualityGateReport] No links issues found.`
   (`out/test-links/20261017-061144`); `[Write-QualityGateReport] No markdownlint issues found.` (`out/test-markdownlint/20261017-061235`);
   Format-FileMeta re-stamped the head, cites now `ADR-REPO-AGENTS#{4,6}`.
6. [ ] `docs/references/agent-contracts.md`: nothing links to it any more; its deletion is the user's `git rm` (ADR-AI#5). Until then the
   page duplicates the ADR's Context paragraph.
7. [x] `.claude/CLAUDE.md`: the agent-contracts link dropped; the literal `ADR-AI` and its ADR link stay. Check: `[Write-QualityGateReport]
   No links issues found.` (`out/test-links/20261017-061143`).
8. [x] `agents.yml` unchanged, `contracts: [ADR-AI]` at line 26. Check: `[Write-QualityGateReport] No agent-definitions issues found.`
   (`out/test-agent-definitions/20261017-061235`).
9. [x] `plan-adr-ai.md`: the four open steps ticked with these verdicts; the plan has no open step and is deleted in T036.

## Steps, as planned

1. Fact, no edit: `AdrCodeForm.cs` line 38 accepts `ADR-[A-Z]+(?:-[A-Z]+)*`, so a one-segment code parses. The registry composes
   `ADR-<DOMAIN>-<NAME>` by default and `external:` overrides it. D14 is therefore "keep ADR-AI"; record that in plan-adr-ai Decided. Check:
   grep `external: ADR-` in adrs.yml shows the override form in use.
2. `automation/Catzc.Base.Docs/configs/adrs.yml`, repository domain `rulesets:` (after `agent-definitions` at line 324): add
   `ai-agent-contract: { external: ADR-AI, concern: [automation] }`. Keep the one-line form the neighbours use. Check: the yaml config test
   for AdrsConfig passes; `Test-AdrRegistry` no longer names ADR-AI (background, catzc-run form).
3. `docs/adr/repository/dora-explains.md`: one entry `## The agent contract` with `[ADR-AI](ai-agent-contract.md)`, a two-sentence
   present-tense tie to DORA (small batches, fast feedback: an agent that runs no suite while working and never mutates git keeps changes
   small and reviewable) and two capability links (`working-in-small-batches`, `streamlining-change-approval`) plus the dora index link.
   Check: Test-Links clean on the file; the adr-checks dora-explains check passes.
4. Regenerate the index: `Build-AdrIndex` (background). Check: `docs/adr/index.md` lists ADR-AI under repository; Test-GeneratedFiles clean.
5. `docs/adr/repository/ai-agent-contract.md`, Context section: absorb the meaning of `docs/references/agent-contracts.md` (34 lines: what
   the contracts entry in agents.yml means, why it is named once) in present tense, no history. Check: Test-Links, Test-Markdownlint clean;
   the head's `edges.cites` still parses (Format-FileMeta).
6. `docs/references/agent-contracts.md`: delete it, or reduce it to a pointer at the ADR if anything links to it
   (`grep -rn agent-contracts.md` first; CLAUDE.md's Sub-agents section links it). Prefer re-pointing CLAUDE.md to the ADR and deleting the
   page (one living version). Check: Test-Links clean on CLAUDE.md and on docs/references.
7. `.claude/CLAUDE.md`: the session-start sentence keeps the literal `ADR-AI` and its link; reword only if step 6 changed the link target.
   Check: Test-Links clean; grep ADR-AI finds the literal.
8. `automation/Catzc.Base.Docs/configs/agents.yml`: no edit; confirm `contracts: [ADR-AI]` (line 26) and that Test-AgentDefinitions reads
   it. Check: Test-AgentDefinitions clean (background).
9. `plan-adr-ai.md`: tick the four open steps with their check results; the plan then has no open step and is deleted in T036 with one line
   in value-of-plan.md. Check: grep `- [ ]` in the plan counts zero.

## Report

As report-fixed; the gate verdict lines verbatim.
