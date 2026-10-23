# Session learnings f61405

Started 2026-10-23T15:33:07.4285106+02:00.

- 2026-10-23 Cats: In hindsight I wish I knew this fact: a repository-integrity Describe that needs real git belongs at L2 with a literal
  tool_git_missing self-skip, since L0 and L1 runs arm the real-process tripwire.
- 2026-10-23 Cats: Token tip: grep a run output file for the Invoke-CatzcCommand passed/failed/N of lines before reading it whole.
- 2026-10-23 Cats: Token tip: when a call says nothing ran because the run lock is busy, retry the same call once the holder line clears
  instead of changing it.
- 2026-10-23 Cats: Token tip: use the Grep tool for repository-wide searches; a bash grep -r overruns the 3 s foreground limit.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Get-CombinedTypeHash leaves each type file meta head out using the delimiters in
  Catzc.Base.Languages/configs/file-carriers.yml (carriers.bcl.block) read from the modules root it is given, so any staging folder it
  hashes must carry that file.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Resolve-ConfigEntry builds the config index once and not per modules root, giving a
  registered type with no file under that root a path-less entry (an empty raw map), and Get-Config caches by path; an empty file read
  reaches DrsConfig as null and throws its non-empty domains message.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the tier tripwire is Test-RealProcessBlocked in Catzc.Base.Execution;
  CATZC_BLOCK_REAL_PROCESS is 1 (block every launch) for a run capped below L2 and tier otherwise, and tier blocks only inside a Describe
  whose outermost tag is L0 or L1, read from Pester state ($state.CurrentBlock), so a full run catches an L0 launch too.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-TestFile -MaxLevel accepts only 3 or 4 and a CATZC_BLOCK_REAL_PROCESS set
  inside the call blocks the runner own snapshot git clone; to see the fast tiers armed run Test-Automation -MinLevel 0 -MaxLevel 1 -Modules
  \<module>.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst takes a folder that mirrors the repository, backs up the targets
  into \<folder>.backup, swaps, runs its commands under one fresh import and restores from the journal on any failure; its commands are
  arguments, one burst per call, and it needs no burst messages.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a function help lives in the ## help section of its comment page, never as
  comment-based help in the code, and a comment-page section names the trimmed code line cut at a word within 80 characters, so editing that
  line orphans its section until the page anchor is changed.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a dot-sourced staged function inside a module scriptblock vanishes with that scope;
  to shadow a module function for a proof, parse the body and set Module.NewBoundScriptBlock(body) as a global function so it still reaches
  the module private helpers.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Test-Automation protects modules that were green, so a second identical run
  executes far fewer tests (499 against 7126); only the first run of a sequence is a full tier proof.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Test-FunctionDependency flags a call to a Pester-internal command such as
  Get-CurrentBlock as unresolved, while reading the module variable through & (Get-Module Pester) { $state.CurrentBlock } passes.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a Bash call with a compound command (cd then command, two commands, a pipe) in the
  background is denied by the time safeguard hook; keep each call to one command and put multi-step work in a script under out/.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: reading only the passed:/failed:/FAIL/Expected lines of a background output file
  with one grep instead of the whole output.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: checking a staged folder against the tree with a changed-line count per file before
  a burst instead of re-reading the files.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Test-ScriptAnalyzer -Path takes a folder and walks four levels while a glob such as
  pwsh/Catzc.Base.X/**/*.ps1 analyzes one file, and Test-Spelling -Path takes globs that spell every extension cspell reads, wider than its
  default scope, so a csv fixture can fail there and nowhere else.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-TestFile -MaxLevel accepts only 3 or 4, so a tier 0 to 1 check of a module
  is Test-Automation -MinLevel 0 -MaxLevel 1 -Modules \<module>.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the Test-Terminology orphan check reads only the files of the default spelling
  scope minus ignorePaths, so a term used only in a csv fixture is an orphan.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: drawio_forward.py --all needs an absolute path when the working directory is not
  the repository root (a relative one exits 3 with no source file), and it is the command that re-renders the legend png, since
  declaration.py put needs a declaration the legend does not have.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: drawio_png.py paints only the shapes paint_shape knows (rounded rectangle, hexagon,
  ellipse, rhombus, cylinder3, crossbar, note, delay, basic.arc) and draws any other as a rectangle while draw.io shows it right; page
  bounds come from painted_box, so a clipped arc adds no margin.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a gitignored generated file such as a .cspell dictionary carries no with_body_sha,
  only a tracked generated file does (ADR-REPO-FILEMETA-FILEISNODE).
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a comment page names its code line as the trimmed line cut at the last space within
  77 characters plus three dots, so a section whose line no longer exists fails Test-Comments and is re-anchored or deleted.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst swaps a staged tree that mirrors the repository and restores it
  on failure, so a type, importer or hook-linked file lands through it, followed by Build-AgentHook when a hook project links the file.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a Pester Describe -Skip:(expression) is evaluated at discovery, so one edit skips a
  whole file when a tool is missing, in place of a guard in every It.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: batching up to five modules gates in one Invoke-CatzcCommand call and reading the
  task output with one grep for passed: and failed: lines.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: never putting a pipe on a background gate call (head -0 discarded a whole run) and
  never sleeping in the foreground.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: reading a plan or page once and editing it by exact text, since each re-read of a
  long file costs more than the edit.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-TestFile accepts -MaxLevel 3 or 4 only, so a tier cap on one module needs
  Test-Automation -MaxLevel n -Modules m.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: CATZC_BLOCK_REAL_PROCESS is armed only when a run top tier is below 2
  (Invoke-TestRun), so a real git launch in an L0 or L1 test is invisible to default and single-file runs.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Get-GitTrackedPath reads the git index in process with no launch and throws in a
  root with no .git; tests of its callers mock it with -ModuleName of the calling function module.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a Describe is the tier unit, so moving one It to L2 means a new Describe name and a
  manual-test-plan row, and a comment page Above line carries the Describe tags, so a tag change stales its page.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Test-ManualTestPlan matches an integrity Describe by file plus Describe name
  against the category table rows, and a blank line before a new row splits the table.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a PowerShell hashtable does not convert to IDictionary[string,string] in a
  constructor call, so pass a Dictionary[string,string].
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst restores every target when a test fails and keeps the staged
  copies after success, which the caller deletes.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a whole-tree tier run takes about 70 s at L0 and 33 s at L1, while L2 passes the
  340 s safeguard.
- 2026-10-23 Cats: Token tip: read a run output with one grep of the verdict lines and the wall clock after stripping colour codes into a
  scratch file, never a tail per run.
- 2026-10-23 Cats: Token tip: after a test edit run Test-Automation -MaxLevel 1 -Modules for the touched modules in one call instead of a
  call per file.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the raster painter paints a labelBackgroundColor box 2 px around an edge word, and
  in a band diagram every crossing word is a transition pill, so no band label carries the key.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: docs/drs/index.md lists records, never rule codes; Test-DrsRegistry reads a new
  DDR-VISUAL-* code from the record itself.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the diagram kit suite runs as uv run -q --no-sync --project python python -m pytest
  python/catzc_diagrams/tests; the python on PATH has no pytest.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Test-Spelling judges a file only once it is in the gate set, so a pre-existing word
  surfaces then and the fix is the file's own cspell:ignore line.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: declaration.py put on a png-carried diagram writes the png byte-identical when
  nothing changed, so git status after a put is the drift check.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: in visual-design.md a rule block lives in the registry section before "One axis,
  read left to right" and its prose section at the end; "actor" is a taken glossary term, "stick man" is not.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: an inspection note in an action article is deleted the day the engine answers it,
  never marked done.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: taking the kit suite command from the usage line at the top of
  tests/test_drawio_png.py instead of trying bare python first.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: grepping a gate's output file for issue, failed and formatted lines instead of
  tailing the whole log.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: keeping one gate script per file set in out/ and re-running it after every edit
  rather than composing new commands.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a diagram is declared in a yml drawio block above its image in a markdown article
  (168 of 182) unless carriers: in drawio.yml says file (12), so a visual comment usually edits an article block, then drawio.yml, then
  python/catzc_diagrams.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a diagram band title is its own borderless cell in the titles layer after edges, so
  an edge passes under the word; candidate slot and span row are additive keys with defaults declared once in drawio.yml.
