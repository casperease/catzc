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
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Test-Diagrams over the whole tree takes about 91 s and already writes the minimap
  data of every declared diagram, so Build-Diagrams -Stale skips its own minimaps pass.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: drawio_forward.py --all takes many diagram roots in one process and ends each with
  a JSON row {"diagram", "exit"}; Build-Diagrams reads the rows, and a root with no row is failed.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: one diagram render is about 1 s inside python and an empty uv start 0.1 s, so the
  per-diagram process cost was the imports and repeated registry reads, not uv.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: minimaps.registry reads through read_registry, cached by full path with libyaml
  (`yaml.__with_libyaml__` is true in the kit venv), so a test that swaps minimaps.REPO needs no cache_clear for it.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Git Bash on this devbox has no bc, so timings belong in a pwsh Stopwatch, not shell
  arithmetic.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: print profile timings with Write-Host, since $x = & $block captures the timing line
  and the run must be repeated.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: cProfile one render before planning a speed-up; it showed the 210 s was mostly
  duplicate PowerShell work, not drawing.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Test-AgentDefinitions requires the standard catzc-drone description to name every
  specialised agent, so each new robot edits catzc-drone.md too.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a new .claude/agents file is spawnable only in a session started after it lands.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Invoke-TestFile has no -OutputFolder; it writes a stamped folder under
  out/test-file/.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: most robots restate their one capability, so 22 robots and 28 capabilities hold
  about half duplicate text.
- 2026-10-25 Cats: Token tip: read agents.yml, one robot and its capabilities before writing a robot, instead of discovering the registry
  rules from gate failures.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: plan-decide spawned as a subagent has no AskUserQuestion, so its round must be
  asked by the main session.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: open questions in plans hide in three shapes (an Open questions section, a [ ] Open
  question step, a Proposed ... Answer: yes or no line), so one grep misses two of them.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Format-Code on plan files also rewraps plan-master.md and value-of-plan.md.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the user rejects a bare yes/no ask; every option must carry its why and its outcome
  in the tree.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: running plan-decide as the main session instead of spawning it, and grepping Open
  question|Proposed|Answer: yes or no in one pass.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a test tag cites a rule code (DDR-ASPECT-ASPECTSAREDERIVED), never a bare ADR code;
  the tag gate rejects a bare one.
