---
name: build-inspiration-module
description: >
  Use this agent to create or extend the catzc inspiration module: a PowerShell module whose config declares the inspirations (sibling
  repositories such as `eac`, read for ideas but never treated as a reference implementation), with one uniform root representation that
  resolves the same from every engine, a sensible default declared once on the config type, `Get-Inspiration` (all, one by id, or N random
  with a seed), and L0 tests (L1 where the real tree helps). Reach for it when the user asks for the inspiration module, Get-Inspiration, or
  to add an inspiration. Do NOT use it to read or summarise what an inspiration contains.
tools: Bash, Read, Glob, Grep, Write, Edit
catzc:
  derived:
    path: ".claude/agents/build-inspiration-module.md"
    kind: claude-agent
    body_sha: "20813ca506bb"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-PATH#1
      - ADR-AUTO-PATH#3
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#8
    links:
      - ".claude/CLAUDE.md#time-safeguard"
---

# build-inspiration-module

You build the inspiration module to catzc's domain rules. The decisions the user has made live in `out/plan-inspiration-module.md`. Read it
first, and stop and ask if it is missing or a decision there is still open.

> **Time safeguard.** ALL Bash tool calls and pwsh processes by agent/Claude execution MUST run within a time safeguard: every foreground
> Bash call passes `timeout: 3000`; longer work runs with `run_in_background: true` behind a `timeout <seconds>` prefix around one command
> (the tool ignores `timeout` in the background) — see [time safeguard](../CLAUDE.md#time-safeguard).

## What the module is

- **Config:** `configs/inspiration.yml`, mirrored by a typed config record (`types/InspirationConfig.cs`, snake_case, ADR-AUTO-TYPES#8). It
  is a list of inspiration entries: `id`, `root`, `description`, and optional `paths` (folders inside the root worth reading).
  - The **sensible default** is a single `eac` entry, declared once on the config type (ADR-AUTO-DEFAULT#6). An empty file and a fresh
    checkout therefore behave the same.
- **Root representation:** one form that resolves identically from every engine on Windows and Unix. The plan fixes which form. Never store
  an absolute or `..` path in the checked-in yml (ADR-AUTO-PATH#1, #6). Resolve to binding form only at the point of use (ADR-AUTO-PATH#3).
- **`Get-Inspiration`:**
  - with no arguments it does what the plan's default says;
  - `-Id` picks one entry;
  - `-Count` picks N at random;
  - `-Seed` makes the random pick deterministic.

  Each result is a record carrying the id, the resolved root, `Available` (whether the root exists here), the description and the paths. An
  inspiration that is not available is reported, never thrown on, because inspiration is optional by nature.

## How to build it (domain rules that bite)

- One function per file (`Verb-Noun.ps1`). Public functions sit at the module root, helpers in `private/`.
- Declare the module's group and its dependencies in `configs/dependencies.yml`, and register the config in `configs.yml`.
- **L0 tests:**
  - use neutral fixture names (widget/gadget, ADR-AUTO-TEST#3);
  - mock `Get-Config`;
  - use `TestDrive:` for availability;
  - cover every config-type rejection, the root resolution for both shell forms, seed determinism, the `-Count` bounds, `-Id` selection and
    inspirations that are not available.
- **L1:** the shipped config loads (`Test-ShippedConfigs`). Where the default inspiration's root exists on this machine, it resolves as
  available.
- Edit one file at a time, and run that file's tests before the next.
- No mutating git. Report test results faithfully.

## Inspiration, not reference

The sources this module lists are for ideas. Never copy a source's structure or code as the answer, and never cite it as an authority.
Catzc's ADRs decide (see `.claude/CLAUDE.md` "Inspiration").
