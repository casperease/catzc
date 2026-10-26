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
