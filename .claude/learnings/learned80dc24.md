# Session learnings 80dc24

Started 2026-10-26T21:44:43.8483768+01:00.

- 2026-10-26 Cats: Token tip: Next time, save tokens by: reading a long gate output with one grep for its Invoke-CatzcCommand and finding
  lines, never a full Read.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the diagram kit runs from its editable build copy, so any edited or new
  python/diagrams/*.py needs uv sync --reinstall-package catzc-diagrams before a render or test sees it.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the PNG raster paints only a bare rhombus style token and only the circle-and-line
  SVG subset that paint_svg reads; shape=rhombus paints a square.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the contract checker refuses oneOf and $defs, and a $comment holding a colon or a
  semicolon.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Build-Diagrams refuses an orphan diagram (E_ORPHAN), so a new diagram needs its
  embedding article in the same change.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Get-BuildClosureViolation is internal to Catzc.Internal.Builder and is called
  inside that module after Import-InternalModule Builder.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: ci-pwsh references invoke-automation 37 times, so a reader of template references
  must dedupe them.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: reading the raster's shape handlers before writing a style a PNG must paint.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: running Test-ScriptAnalyzer on new .ps1 files in the first check, not after a peer
  reports a warning.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a capability name must be \<domain>-\<job> with at least one hyphen
  (CapabilityEntry NameRe), so single-word skill names such as orchestrate or listen fail the type.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Test-AgentDefinitions.Tests.ps1 asserts the real tree is clean, CLAUDE.md
  Sub-agents list included, so any burst that runs it waits on the CLAUDE.md edit.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst -Stage hashes the live file, so a registry staged into a burst
  is edited only in its staged copy until the burst lands.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: an agent or skill lives in two registries plus a file; a moved key such as persona
  needs AgentEntry, CapabilityEntry and both ymls in one burst.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: running Test-AgentDefinitions once per batch of registry rows and filtering out the
  expected CLAUDE.md lines with one grep.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: checking a new skill name against CapabilityEntry NameRe before writing the folder.
- 2026-10-26 Cats: Agents are four model drones (drone-haiku, -sonnet, -opus, -fable); every job is a skill in capabilities.yml whose
  model_floor picks the drone, and a capability name must be \<domain>-\<job>.
- 2026-10-26 Cats: A gate run that waits on the run lock can fall between two staged bursts and read a half-swapped tree; re-run after the
  last burst ends before trusting a red verdict.
- 2026-10-26 Cats: Token tip: brief one fresh idle session with the whole final pass instead of relaying step by step.
