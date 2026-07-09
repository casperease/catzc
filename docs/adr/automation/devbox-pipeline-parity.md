# ADR: Devbox / pipeline parity — the automation track is a CLI that runs everywhere

## Rules: ADR-AUTO-PARITY

### Rule ADR-AUTO-PARITY:1

The `automation` track **is a CLI**, and every command runs unchanged in two environments: **DEVBOX** — the developer's machine, where you
_shoot_ (iterate fast; it just has to work) — and **PIPELINE** — CI/CD, where you _verify and deliver_ (deterministic and fast, through a
few manual approvals to live users). Same code, same commands, same behaviour in both. There is no pipeline-only automation and no
devbox-only automation: what you run locally is exactly what CI runs. This is the #1 design rule for the track — every other automation rule
assumes it.

### Rule ADR-AUTO-PARITY:2

Both environments are **equally gated**: `Test-Automation` and its L0–L3 suites run on the devbox AND in the pipeline, and must agree.
Shift-left means a failure surfaces on the devbox _first_ — not that the pipeline is the only place the code runs. A test that needs a
pipeline to pass, or cannot run in one, is mis-tiered (`ADR-AUTO-TEST`), never a licence to fork behaviour.

### Rule ADR-AUTO-PARITY:3

The **one seam** between the two is `Test-IsRunningInPipeline` (`ADR-FLOW-CD-DETECT`) — the CI orchestrator (Azure DevOps / GitHub) already
knows it is CI, so the CLI only asks that one question. A command branches on the seam solely where the environments _genuinely_ differ, and
those differences are small and already owned: where output goes (`Get-OutputRoot`), syncing concurrent runs (`Wait-Mutex`), skipping the
dev-box auto-commit in CI. Never branch on the seam to change _what a command does_ — that is a parity violation.

### Rule ADR-AUTO-PARITY:4

The two environments **connect only via the EAC** — the version-controlled globsets and their generated trigger projections
(`ADR-FLOW-CD-GLOBS`). The devbox shoots: it edits the source and its projected triggers, and commits them. The pipeline verifies: it
reflects the same globsets against git at the merged commit and gates, then delivers. Nothing else crosses between devbox and pipeline — no
shared runtime state, only the committed source. So "did this change" and "what ships" are the same fact on both sides, by construction.

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

## Consequences

- **Shift-left is real.** A failure shows up on the devbox first, because the devbox runs exactly what CI runs.
- **The seam is enumerable.** Every environment difference is one `Test-IsRunningInPipeline` call, so "where do devbox and pipeline
  diverge?" has a finite, small answer.
- **One channel.** Devbox and pipeline share nothing but the committed markers — no hidden coupling, no CI-only state.

## Related

- [pipeline-detection](../flow/pipeline-detection.md) — the one seam detector (`ADR-FLOW-CD-DETECT`)
- [durable-sha-globs](../flow/durable-sha-globs.md) — the globsets, the only channel between devbox and pipeline (`ADR-FLOW-CD-GLOBS`)
- [test-automation](test-automation.md) — the L0–L3 gates that run identically in both environments (`ADR-AUTO-TEST`)
- [reduce-variability](../principles/reduce-variability.md), [one-living-version](../principles/one-living-version.md) — the principles this
  specialises to two environments

## Dora explains

DORA's research links continuous integration to faster deployment frequency and lower change failure rate. Devbox/pipeline parity ensures
the same code path runs locally and in CI, eliminating "works on my machine" failures and accelerating feedback loops.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — parity ensures CI gates run early and faithfully.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — identical commands in both environments enable reliable,
  fast promotion.
- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — the CLI runs unchanged across devbox and CI
  environments.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
