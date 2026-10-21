# Session learnings 6e9249

Started 2026-10-21T20:09:00.4651213+02:00.

- 2026-10-21 Cats: Build-Diagrams -Path accepts only docs/**/.assets/\<name>/ folders; a sample under out/ renders with
  Write-DiagramMinimapData (relative -Folder) and python/catzc_diagrams/declaration.py put.
- 2026-10-21 Cats: Minimap lit cells are computed from files that cite the about.adrs codes; no sister .md gates them, so content.minimaps
  chooses the maps.
- 2026-10-21 Cats: Contracted commands output only closed contract types, so a command returning pscustomobject needs a typed result before
  it can be contracted.
- 2026-10-21 Cats: importer.sh cats passes one value per parameter, so a list argument cannot run under bash or zsh.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: parse-checking a YAML or ps1 edit on the import path standalone before any import
  reads it, instead of finding out through a broken import.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: reading a gate parameter set (Test-SourceConventions has no -Path, Invoke-TestFile
  -MaxLevel takes 3 or 4) before calling it.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Invoke-PythonTest takes a pascal module plus -Folder for a kit's own tests
  (Invoke-PythonTest Catzc.Base.Slides -Folder python/catzc_diagrams/tests).
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a minimap call's cost was Get-WorldMap built twice per call (inside
  Get-WorldMapHighlight too), not the C# step; measure the split before choosing a memo or a compiled type.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-FileMetaFact now returns only with_body_sha, so place facts (track, module,
  language) come from Get-MinimapFact by placement, never from heads.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: docs/adr/index.md's authoring conventions are generated from
  pwsh/Catzc.Base.Docs/configs/adr-index.yml; edit that source, never the page.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: conventional-folders allows a diagram folder only its yml, png and
  diagram.drawio.verify.md; minimap reasons go in the verify record's ## Minimap reasons section.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a contrast in a glossary source is declared once, on either term; Build-Glossary
  shows it on both and Test-Glossary flags a pair declared twice.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Invoke-TestFile falls back to a snapshot when another session holds the test-run
  lock, and that snapshot's priming fails silently; retry when the lock is free.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-GeneratedFiles takes no -Path; it runs every registered writer.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: running every cats check through pwsh/.internal/assets/Invoke-CatzcCommand.ps1
  instead of writing out/*.ps1 wrappers.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: listing a gate's findings once with sort -u, since quality-gate reports print every
  finding twice.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: drawio_png.py treats any non-hex colour as its default, so a model must be painted
  (declaration.paint) before render; it now fails loudly, and a legend-role folder renders from glyphs.xml through Build-Diagrams.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-FileMetaFact returns only with_body_sha now, so file placement facts (track,
  module, language) come from Get-Track, Get-PathModule and languages.yml, which Get-MinimapFact uses.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Format-Code moves a comment longer than one line out of code and configs to the
  docs/references comment page, so a new multi-line yml comment lands there, not inline.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Diagrams -Path refuses a folder without a diagram.drawio.yml, so the glyph
  library (role legend) is checked by comparing its carried model, not by the gate.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a skill's line roof counts only non-indented body lines and front-matter keys, so a
  clause merged as a wrapped continuation adds no counted line.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: running one Invoke-CatzcCommand call with every gate as a quoted argument instead
  of a script per check.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: checking a re-render against the before snapshot of the old code before blaming the
  new change.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: most gaps in a hindsight log close within the same day, so each line is re-checked
  against the tree before it is planned.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-CodeCaller in Catzc.Base.Files lists every tracked file that names a type or
  config.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: New-Plan writes its -Summary verbatim into the value-of-plan row and the master
  line, so the summary must name only what the plan will hold.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Format-Code reports per language how many files changed in content and how many
  only in wrapping.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Invoke-CatzcCommand.ps1 pushes to the repository root, so a relative path in a
  quoted command resolves from the root.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a bash loop running wc once per file across .claude exceeds the 3 s foreground roof
  on Windows.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: grepping the tree for each command a hindsight line names before New-Plan, not
  after.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: reading a background task output only after its notification, once.
