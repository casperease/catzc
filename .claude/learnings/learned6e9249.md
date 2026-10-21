# Session learnings 6e9249

Started 2026-10-21T20:09:00.4651213+02:00.

- 2026-10-21 Cats: Build-Diagrams -Path accepts only docs/**/.assets/\<name>/ folders; a sample under out/ renders with
  Write-DiagramMinimapData (relative -Folder) and python/catzc_diagrams/declaration.py put.
- 2026-10-21 Cats: Minimap lit cells are computed from files that cite the about.adrs codes; no sister .md gates them, so content.minimaps
  chooses the maps.
- 2026-10-21 Cats: Contracted commands output only closed contract types, so a command returning pscustomobject needs a typed result before
  it can be contracted.
- 2026-10-21 Cats: importer.sh cats passes one value per parameter, so a list argument cannot run through importer.sh.
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
- 2026-10-21 Cats: In hindsight I wish I knew this fact: docs/drs/index.md's authoring conventions are generated from
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
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-AdrUsage without -Path throws on a file staged in the index but deleted on
  disk.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-AdrUsage reads head cites and links only; about 40% of the codes a raw git grep
  finds (prose, messages, regexes, diagrams) are outside it.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: 30 files hard-code the ADR marker (list in out/xdr-rename/parser-files.txt), so a
  code-grammar change starts with those parsers.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: contracts/EXTERNAL-azure/0.1.0 is frozen and carries ADR codes, so a citation
  rename never rewrites it.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: about 1,330 code occurrences are neutral test fixtures (ADR-WIDGET and kin), not
  domains adrs.yml registers.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: a raw git grep inventory into out/ first, and Get-AdrUsage only with -Path.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: writing a pwsh script with the Write tool, never inside a heredoc in a call the
  hook may deny.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a plan missing from .claude/plans usually landed, since done plans are deleted
  directly, and out/orchestrator-\<date>.log names the session that took it.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: grepping out/orchestrator-\<date>.log for a missing plan before reporting it lost.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: AdrCitationRewriter validates every code-map row against ^ADR(-SEG)+, so a map to a
  new record kind cannot load until the rewriter reads the kinds from the registry.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: an edit to any pwsh/_/types/_.cs file is compiled by the next import of every
  session, so a multi-edit type change must be staged in out/ and swapped in with a fresh import in one script.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Links exempts string paths only in *.Tests.ps1 files until LinkEngine treats
  every file in a tests/ folder as a test, which ADR-REPO-LINK-STRINGSAREDATA already says.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: ADR-AUTO-TEST-QUALITYGATE requires a gate to throw once listing every issue, so
  findings printed once means Write-QualityGateReport prints issue lines only under -PassThru.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the domains that own their kind are cited 4,587 times in 826 files, and the frozen
  contracts/EXTERNAL-azure/0.1.0 cites only REPO rules.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: NameCase.Render splits DevOps into dev-ops and VSCode into vs-code, so every
  {kebab} rendered from a module name changed with it.
- 2026-10-21 Cats: Token tip: build one AdrCitationRewriter in the module scope and call Rewrite() per file for a tree-wide dry run, instead
  of Update-AdrCitation per file.
- 2026-10-21 Cats: Token tip: grep a gate's own exemption code before planning a fix to its findings; the gap is often in the gate.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: declaration.py dump leaves out what a row or lane expands to, including a declared
  edge between two generated cells, so a tool that changes one key writes the raw yml back, never dump of the normalised form.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: content.minimaps in diagram.drawio.yml maps each shown minimap to its lit cells
  with what lit them, and declaration.py minimaps \<folder> writes it from out/minimaps.
