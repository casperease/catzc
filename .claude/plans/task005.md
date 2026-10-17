---
task:
  id: "005"
  status: open
  plans: [plan-adr-ai]
  value: high
  blocked_on: nothing (D14 is answered by a read; see step 1)
  targets:
    [
      automation/Catzc.Base.Docs/configs/adrs.yml,
      docs/adr/index.md,
      docs/adr/repository/dora-explains.md,
      docs/adr/repository/ai-agent-contract.md,
      docs/references/agent-contracts.md,
      .claude/CLAUDE.md,
    ]
---

# task005: register ADR-AI

The ADR exists (docs/adr/repository/ai-agent-contract.md, 13 rules, head declares ADR-AI#{1-13}) and agents.yml names it once as
`contracts: [ADR-AI]`. It is not in adrs.yml, so Test-AdrRegistry reports it and the index does not list it. One file per step, verified
before the next; the index is generated, never edited by hand.

## Steps

1. Fact, no edit: `AdrCodeForm.cs` line 38 accepts `ADR-[A-Z]+(?:-[A-Z]+)*`, so a one-segment code parses. The registry composes
   `ADR-<DOMAIN>-<NAME>` by default and `external:` overrides it. D14 is therefore "keep ADR-AI"; record that in plan-adr-ai Decided.
   Check: grep `external: ADR-` in adrs.yml shows the override form in use.
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
6. `docs/references/agent-contracts.md`: delete it, or reduce it to a pointer at the ADR if anything links to it (`grep -rn agent-contracts.md`
   first; CLAUDE.md's Sub-agents section links it). Prefer re-pointing CLAUDE.md to the ADR and deleting the page (one living version).
   Check: Test-Links clean on CLAUDE.md and on docs/references.
7. `.claude/CLAUDE.md`: the session-start sentence keeps the literal `ADR-AI` and its link; reword only if step 6 changed the link target.
   Check: Test-Links clean; grep ADR-AI finds the literal.
8. `automation/Catzc.Base.Docs/configs/agents.yml`: no edit; confirm `contracts: [ADR-AI]` (line 26) and that Test-AgentDefinitions reads
   it. Check: Test-AgentDefinitions clean (background).
9. `plan-adr-ai.md`: tick the four open steps with their check results; the plan then has no open step and is deleted in T036 with one line
   in value-of-plan.md. Check: grep `- [ ]` in the plan counts zero.

## Report

As report-fixed; the gate verdict lines verbatim.
