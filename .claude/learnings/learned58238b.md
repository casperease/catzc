# Session learnings 58238b

Started 2026-10-25T19:43:41.2738963+01:00.

- 2026-10-25 Cats: Token tip: Next time, save tokens by: grepping only the two status lines of a background output (PASS/FAIL, issues)
  instead of tailing its whole log.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: an edit to any shared C# type recompiles every sessions import, so one compile
  error there breaks all sessions until fixed.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: an if expression whose branch yields @() returns $null, and .Count on it throws
  under strict mode.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a function returning , $array is counted as one item by a callers @().
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a Pester mock keeps the mocked commands typed parameters, so a pscustomobject
  cannot bind to a typed -Config.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: .ForEach on a .NET List binds List\<T>.ForEach(Action), not the PowerShell method.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a comment-page anchor is the trimmed code line, cut at the last space before
  character 77 plus ... when over 80.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: two adjacent comment lines reach the export threshold, so Export-Comments moves
  both to the page.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Invoke-TestFile workers compile a fresh tree, so a peers broken type fails a test
  while the import looks clean.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Get-ModuleGlobSet gives the go, bash and python root holders no tests set at all.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a new functions comment page needs a hand-written ## help section before
  Format-Code passes.
- 2026-10-25 Cats: Token tip: run all of one modules checks in a single Invoke-CatzcCommand call, not one call per check.
- 2026-10-25 Cats: Token tip: read a background run with one grep for its Invoke-CatzcCommand and Write-QualityGateReport lines, never the
  whole output.
- 2026-10-25 Cats: Token tip: list a modules comment sections with one awk over its pages instead of opening each page.
- 2026-10-25 Cats: A generated-file writer renders through Write-FileIfChanged, so an unchanged render never touches its output and an
  mtime-based due rule stays due forever; only a stored input stamp can tell a writer it is current.
- 2026-10-25 Cats: Two consecutive comment lines are a run the exporter takes, so an insight line placed directly on another comment line is
  exported to the page by the next Format-Code.
- 2026-10-25 Cats: Invoke-StagedBurst copies staged files in but cannot delete, so a move whose old copy must vanish in the same swap (a
  config or type that may exist only once) needs a delete list beside the journal.
- 2026-10-25 Cats: Get-Config fails on a config name that exists in two modules, so a leftover or emptied copy of a moved yml breaks every
  import.
- 2026-10-25 Cats: Test-Glossary skips a quoted or code-span mention, so a page whose point is an avoided form names it in quotes and never
  deletes it.
- 2026-10-25 Cats: The repository already has a verbs switch on a glossary concept, so an inflection like gated is allowed by verbs: true
  and never by a new form.
- 2026-10-25 Cats: A comment page anchor is the trimmed code line, cut at the last space before 77 characters plus ... when longer than 80,
  with (occurrence n) for a repeated line; a re-anchor recomputes it exactly.
- 2026-10-25 Cats: Module edges in dependencies.yml must stay acyclic, and QualityGates already depends on RootConfig, so a shared mechanism
  both use lives in a lower module (here Catzc.Base.GeneratedFiles).
- 2026-10-25 Cats: Token tip: probe every module with one script (find_anchors.py, list_site_lines.py in out/finalizer-diag) instead of
  reading each page and code site by hand.
- 2026-10-25 Cats: Token tip: batch one module's Format-Code, Test-Comments and test files into one Invoke-CatzcCommand call, and re-run
  only a crashed test alone.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a C# type edit that adds a call and its method must land in one Edit; another
  session imports between two Edits and the whole repository fails to compile.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the contracts system already declared a manifest-glob addressing mode
  (ADR-REPO-CONTRACT-CONFIGUREDADDRESSING) before anything needed it; read the ADR before designing an extension.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: folder names that tooling reads are declared as track configuration (variants.yml
  tracks, module-types.yml, languages.yml layout), and some code still spells them as literals.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: out/ is the output track; every default scope stays out of it through git-tracked
  scopes, the folder-walk exclude and the markdown-scope exclude, and Test-PlaceRows was the one default pointing in.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Pester treats \<name> in an It title as a template variable, and a hashtable key
  with a hyphen needs quotes, or the test file fails before its tests run.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Test-Comments anchors a comment section to its code line, cut at about 80
  characters on a word boundary followed by ..., so editing an anchored line orphans its section.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: batching an icon tweak, its render and its install into one background script per
  round instead of re-reading the gate output each time.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: settling a definition (conventional, semantic) with the user in one question before
  rewriting a decision record, not across five rounds of edits.
