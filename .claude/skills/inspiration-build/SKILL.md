---
name: inspiration-build
description: >
  Create or extend the inspiration module (pwsh/Tooling.Inspiration): its config, one root form, a default declared once, Get-Inspiration
  and its tests, to the inspiration plan's decisions; input is the plan and the change asked.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
paths: pwsh/Tooling.Inspiration/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [pwsh]
---

# inspiration-build

Build or extend `pwsh/Tooling.Inspiration` to the decisions in `.claude/plans/` (the inspiration plan); a missing plan or an open decision
there goes back to the coordinator.

1. Read the plan, then load catzc-module and read the ADRs it names, in full.
2. The config `configs/inspiration.yml` and its `InspirationConfig` type: entries of `id`, `root`, `description`, optional `paths`; the
   default is one `eac` entry on the type, so an empty file and a fresh checkout behave the same; the root form is the plan's one form.
3. `Get-Inspiration`: no arguments does what the plan says; `-Id` one entry; `-Count` N at random; `-Seed` makes it deterministic; each
   result carries id, resolved root, `Available`, description and paths; an unavailable root is reported, never thrown on.
4. Tests per catzc-module step 2: config rejections, both root forms, seed determinism, `-Count` bounds, `-Id`, unavailable roots; then
   `Test-ShippedConfigs`.
5. One file at a time with its test file (catzc-module step 3); the sources are ideas, never copied, never cited as authority.
