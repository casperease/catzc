# ADR: Devbox / pipeline parity — the automation track is a CLI that runs everywhere

## Rules: ADR-PARITY

### Rule ADR-PARITY:1

The `automation` track **is a CLI**. Every command runs, unchanged, in two environments: **DEVBOX** — the developer's machine, the
furthest-left point in shift-left — and **PIPELINE** — CI/CD, to the right of the devbox and reaching, through a few manual approvals, all
the way to live users. Same code, same commands, same behaviour in both. There is no pipeline-only automation and no devbox-only automation:
what you run locally is exactly what CI runs. This is the #1 design rule for the track — every other automation rule assumes it.

### Rule ADR-PARITY:2

Both environments are first-class and **equally tested**. The gates (`Test-Automation` and its L0–L3 suites) run on the devbox AND in the
pipeline and must pass identically. Shift-left means a failure surfaces on the devbox *before* the pipeline — not that the pipeline is the
only place the code runs. A test that assumes one environment (needs a pipeline to pass, or cannot run in one) is mis-tiered (`ADR-TEST`),
never a licence to fork behaviour.

### Rule ADR-PARITY:3

The only place the two environments may differ is a genuine **seam**, and every seam has one sanctioned detector: `Test-IsRunningInPipeline`
for the pipeline seam (`ADR-PIPEDET`), `Get-TimeBinding` for the time seam (`ADR-TIMEBIND`), the output-root resolver for where artifacts
land. A command branches on a seam only where the environments *genuinely* differ (an agent-set variable, no interactive auth, output goes
elsewhere) — never to change its logic. A branch on `Test-IsRunningInPipeline` that alters what the command *does* is a parity violation.

### Rule ADR-PARITY:4

Time bindings (`ADR-TIMEBIND`) are wired at the **command, not the environment**: a build command enters build-time whether it runs on the
devbox or in CI, so `build-time` reports identically in both. Wiring build-time (or any binding) at a pipeline call site — so it only reports
in CI — is a parity violation; wrap the command's own work, so the devbox invocation and the CI invocation are the same run.

## Context

The value of the automation track is that it collapses the distance between "works on my machine" and "works in CI": one CLI, run the same
everywhere, so a problem is caught at the furthest-left point it can be. That only holds if parity is a rule, not an accident — the moment a
command needs a pipeline to work, or behaves differently there, shift-left breaks and the pipeline becomes the first place failures appear.
The seams (`Test-IsRunningInPipeline`, `Get-TimeBinding`, output roots) exist precisely to keep the *one* legitimate environment difference
in one auditable place, so everything else stays identical.

## Decision

Treat the automation track as a single CLI with two runtimes and no third mode. Write every command to run on a bare devbox; let CI run the
identical command; and confine the environment difference to a named seam behind a single detector. Wire cross-cutting bindings (build-time,
test-time) into the commands themselves so they hold in both runtimes. The gates run in both and must agree — that agreement is the proof of
parity, checked on every push (the pipeline recomputes what the devbox committed).

## Consequences

- **Shift-left is real.** A failure shows up on the devbox first, because the devbox runs exactly what CI runs.
- **Seams are enumerable.** Every environment difference is one detector call, so "where do devbox and pipeline diverge?" has a finite answer.
- **No CI-only bugs.** A command that can't run on a devbox can't ship — parity is a gate, not a hope.

## Related

- [pipeline-detection](../pipelines/pipeline-detection.md) — the one detector for the pipeline seam (`ADR-PIPEDET`)
- [time-bindings](../automation/time-bindings.md) — build/runtime/test-time, wired at the command for parity (`ADR-TIMEBIND`)
- [test-automation](../automation/test-automation.md) — the L0–L3 gates that run identically in both environments (`ADR-TEST`)
- [reduce-variability](reduce-variability.md), [one-living-version](one-living-version.md) — the principles this specialises to two runtimes
