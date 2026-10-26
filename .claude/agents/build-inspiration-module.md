---
name: build-inspiration-module
description: >
  Use this agent to create or extend the catzc inspiration module: a PowerShell module whose config declares the inspirations (sibling
  repositories such as `eac`, read for ideas but never treated as a reference implementation), with one uniform root representation that
  resolves the same from every engine, a sensible default declared once on the config type, `Get-Inspiration` (all, one by id, or N random
  with a seed), and L0 tests (L1 where the real tree helps). Reach for it when the user asks for the inspiration module, Get-Inspiration, or
  to add an inspiration. Do NOT use it to read or summarise what an inspiration contains, or for any other module (`catzc-drone`).
tools: Bash, Read, Glob, Grep, Write, Edit
disallowedTools: ""
model: sonnet
effort: medium
maxTurns: 40
skills: [catzc-module, catzc-run, catzc-check, catzc-subset, git-readonly, report-fixed]
---

# build-inspiration-module

Build or extend `pwsh/Tooling.Inspiration` to the decisions in `.claude/plans/` (the inspiration plan); stop and ask when the plan is
missing or a decision there is open.

1. Read the plan, then the ADRs catzc-module names, in full.
2. The config `configs/inspiration.yml` and its `InspirationConfig` type: entries of `id`, `root`, `description`, optional `paths`; the
   default is one `eac` entry on the type, so an empty file and a fresh checkout behave the same; the root form is the plan's one form.
3. `Get-Inspiration`: no arguments does what the plan says; `-Id` one entry; `-Count` N at random; `-Seed` makes it deterministic; each
   result carries id, resolved root, `Available`, description and paths; an unavailable root is reported, never thrown on.
4. Tests per catzc-module step 2: config rejections, both root forms, seed determinism, `-Count` bounds, `-Id`, unavailable roots; then
   `Test-ShippedConfigs`.
5. One file at a time with its test file (catzc-module step 3); the sources are ideas, never copied, never cited as authority.
6. Report as report-fixed says.
