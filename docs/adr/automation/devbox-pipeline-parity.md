---
catzc:
  derived:
    path: docs/adr/automation/devbox-pipeline-parity.md
    kind: adr
    body_sha: "6b5b0f557acf"
    defines:
      - ADR-AUTO-PARITY#1
      - ADR-AUTO-PARITY#2
      - ADR-AUTO-PARITY#3
      - ADR-AUTO-PARITY#4
    links:
      - docs/adr/automation/test-automation.md
      - docs/adr/flow/durable-sha-globs.md
      - docs/adr/flow/pipeline-detection.md
      - docs/adr/principles/one-living-version.md
      - docs/adr/principles/reduce-variability.md
---

# ADR: Devbox and pipeline parity — one CLI, two environments, one seam

## Rules: ADR-AUTO-PARITY

### Rule ADR-AUTO-PARITY:1

The `automation` track **is a CLI**, and every command runs unchanged in two environments: **DEVBOX** — the developer's machine, where you
_shoot_ (iterate fast; it just has to work) — and **PIPELINE** — CI/CD, where you _verify and deliver_ (deterministic and fast, through a
few manual approvals to live users). Same code, same commands, same behaviour in both: there is no pipeline-only automation and no
devbox-only automation.

- [One CLI, two environments](#one-cli-two-environments)

### Rule ADR-AUTO-PARITY:2

Both environments are **checked equally**: `Test-Automation` and its L0–L3 tiers run on the devbox AND in the pipeline, and must agree. A
test that needs a pipeline to pass, or cannot run in one, is mis-tiered (`ADR-AUTO-TEST`), never a licence to fork behaviour.

- [Checked equally](#checked-equally)

### Rule ADR-AUTO-PARITY:3

The **one seam** between the two is `Test-IsRunningInPipeline`. A command branches on the seam solely where the environments _genuinely_
differ — where output goes (`Get-OutputRoot`), skipping the devbox auto-commit in CI — and never to change _what a command does_.

- [The one seam](#the-one-seam)

### Rule ADR-AUTO-PARITY:4

The two environments **connect only via the EAC** — the version-controlled globsets and their generated trigger projections. Nothing else
crosses between devbox and pipeline: no shared runtime state, only the committed source.

- [One channel](#one-channel)

## Context

The value of the automation track is that it collapses the distance between "works on my machine" and "works in CI": one CLI, run the same
everywhere, so a problem is caught at the furthest-left point it can be. That only holds if parity is a rule, not an accident — the moment a
command needs a pipeline to work, or behaves differently there, shift-left breaks and the pipeline becomes the first place failures appear.
The single seam (`Test-IsRunningInPipeline`) keeps the _one_ legitimate difference in one auditable place; the version-controlled globsets
(`ADR-FLOW-CD-GLOBS`) are the only channel between the two, so everything else stays identical.

## Decision

Treat the track as a single CLI with two environments and no third mode. Write every command to run on a bare devbox; let CI run the
identical command; confine the environment difference to the one seam behind `Test-IsRunningInPipeline`; and let devbox and pipeline
communicate only through the version-controlled globsets. The gates run in both and must agree — that agreement, recomputed on every push,
is the proof of parity.

### One CLI, two environments

What you run locally is exactly what CI runs: the same importer entry and the same tool installers, no separate CI scripts, and no CI-only
branches. This is the first design rule for the track, and every other automation rule assumes it. A command that works only in one
environment is not a command of the CLI; it is a fork of it, and the fork is where the environments start to disagree.

### Checked equally

Shift-left means a failure surfaces on the devbox _first_ — not that the pipeline is the only place the code runs. The tiers of
[test-automation](test-automation.md) run in both environments by default, less only the tiers a run's location cannot run, so "it passed on
my machine" and "it passed in CI" are the same statement. A test that can only pass in one of them is telling you its tier is wrong, not
that the environments may differ.

### The one seam

The CI orchestrator (Azure DevOps / GitHub) already knows it is CI, so the CLI only asks that one question
([pipeline-detection](../flow/pipeline-detection.md)). The differences it governs are small and already owned: where output goes
(`Get-OutputRoot`), and skipping the devbox auto-commit in CI. Concurrent test runs are not one of them: a run that finds the working folder
busy runs in a snapshot of it, the same way in both environments (`ADR-AUTO-TEST`). Branching on the seam to change _what a command does_ is
a parity violation, because it creates the pipeline-only behaviour the first rule forbids.

### One channel

The devbox _shoots_: it edits the source and its projected triggers, and commits them. The pipeline _verifies_: it reflects the same
globsets against git at the merged commit, decides whether it proceeds, then delivers. Nothing else crosses between the two — no shared
runtime state, only the committed source — so "did this change" and "what ships" are the same fact on both sides, by construction.

## Consequences

- **Shift-left is real.** A failure shows up on the devbox first, because the devbox runs exactly what CI runs.
- **The seam is enumerable.** Every environment difference is one `Test-IsRunningInPipeline` call, so "where do devbox and pipeline
  diverge?" has a finite, small answer.
- **One channel.** Devbox and pipeline share nothing but the committed source and the triggers projected from it — no hidden coupling, no
  CI-only state.

## Related

- [pipeline-detection](../flow/pipeline-detection.md) — the one seam detector (`ADR-FLOW-CD-DETECT`)
- [durable-sha-globs](../flow/durable-sha-globs.md) — the globsets, the only channel between devbox and pipeline (`ADR-FLOW-CD-GLOBS`)
- [test-automation](test-automation.md) — the L0–L3 test tiers that run identically in both environments (`ADR-AUTO-TEST`)
- [reduce-variability](../principles/reduce-variability.md), [one-living-version](../principles/one-living-version.md) — the principles this
  specialises to two environments
