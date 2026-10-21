# Session learnings 36699f

Started 2026-10-21T20:42:19.8972026+02:00.

- 2026-10-21 Cats: In hindsight I wish I knew this fact: Python subprocess text output on this devbox decodes in the Windows code page
  unless encoding=utf-8 is named, so a git show compare reports false differences on every non-ASCII yml.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-Config, the ADO auth header function, the importer and the bash hook now cite
  their rules, so they light on the minimaps.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: diffing one suspected loss byte-wise before trusting a bulk compare that reports
  many.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: asking for the final shape of a cross-cutting record before writing its first
  hundred entries.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a code head's cites: derives only for the file classes the adr-codes select in
  file-meta.yml names (type, function, config, hook, module/internal; test, fixture, asset for powershell); a page citing rules for any
  other class lights nothing.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a file's class is (Get-Config -Config file-kinds).Resolve(\<path>).Class, and
  Get-FileMetaFact -Path shows the cites a file derives, both without editing anything.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Slides requires a quotes: slide's body to equal the registry rule verbatim,
  and the rule pattern holds at most 70 words split on whitespace, so a spaced dash counts as a word.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the spelled file types are the languages.yml languages whose checks list
  Test-Spelling, read through LanguagesConfig.ExtensionsCheckedBy('Test-Spelling').
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the full-repository case of Test-Spelling.Tests is skipped while the repository
  globset is protected, so touching any spelled file re-runs it and surfaces every old unapproved word.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the reserved category's scope globs in terminology.yml match case-sensitively;
  _accosted_ does not cover a ConvertTo-AccostedCallText page.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: 'comman' in GitFlowConfig.cs is a deliberate prefix of pwsh's -Command switch,
  approved as a powershell term, not a typo.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: probing a file's class and derived facts with file-kinds Resolve and
  Get-FileMetaFact before writing any citation text.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: putting a whole burst (edit check, fresh import, format, gates, tests) in one out/
  script so the import runs once.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a code head's docs edge is built from the link template `[{leaf}]({path})` in
  QualityGates configs/file-meta.yml, and {path} is repository-relative, so the link breaks from the file's folder.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a head's cites include every registered code its comment page cites, so an
  unexpected cite like ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD on a QualityGates type comes from its page, not an error.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Plans fails an open step that names no check (ADR-REPO-PLANS-OPENSTEP), and a
  new plan also needs its value-of-plan.md row and plan-master.md chunk line.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: writing one out/ script for Format-Code plus Test-Plans on the exact plan files
  before the first plan edit, instead of guessing an existing script name.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: waiting for a background run's notification instead of polling its output file or
  reaching for Monitor.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a diagram is a flat pair .assets/\<name>.drawio.yml + .drawio.png named by its stem
  .assets/\<name>, and the yml may instead live in a `yml drawio` block above its image when the kit's drawio.yml carriers: names the stem.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a minimap lights only the cells its yml declares (Write-DiagramMinimapData drops
  and warns on the rest) and declaration.py minimaps reads out/minimaps/\<stem>/computed/, so every citation change ends in recompute,
  re-declare, Build-Diagrams -Stale.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Get-WorldMap reads a file's citations from its body plus its comment page, never
  its catzc head, and citation_exclude keeps .claude/{learnings,hindsight,plans}/** and docs/**/.assets/** from lighting cells.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: dot-sourcing a staged copy into a module replaces a private function but not a
  public one, whose exported command keeps the old definition; a public staged copy needs a global wrapper or a real swap.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Build-Diagrams -Stale over the tree takes about 210 s, so a following tree
  Test-Diagrams in the same call breaks the 360 s roof; run them as two calls.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: in a PowerShell -like pattern a backtick is the escape character, so a pattern with
  literal backticks never matches; use StartsWith/Contains instead.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: reading a gate's verdict with one grep for "issues|FAIL|TEST:" instead of tailing
  whole outputs.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: keeping one reusable check script per burst under out/gate/ and editing its path
  list, rather than writing a new script per check.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Update-DrsCitation and Rename-CodeName rewrite only tracked text files they can
  decode; a binary in git ls-files must be skipped, and a page moved on disk but not committed is not read.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a root move's rewrite misses relative links it cannot resolve from the citing file,
  such as a bare ](adr/...) link in docs/index.md or a test fixture's ../adr string; search for the old folder name after the move.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a file-meta kind's id names its subscriber function (drs-codes calls
  Get-DrsCodesFileMetaFact), so renaming the function without the kind breaks Format-FileMeta and Test-FileMeta for every session.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a private function of one module is invisible to another, so a move that leaves a
  caller behind in Catzc.Base.Docs needs the function public in Catzc.Base.Drs.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Move-Diagram moves with git mv, so a session that may not change git moves the yml
  and png pair on disk and re-points the links a -DryRun lists.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Glossary's G6 limits the qualifiers of terms such as domain and layer, so
  "record domain" or "this FDR layers on" fail until reworded or registered as a form.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: pwsh -File binds only the first positional argument to a [string[]] parameter
  unless it declares ValueFromRemainingArguments.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: grepping with -o and a short context window, or output_mode count, instead of
  printing whole lines of wide markdown tables.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: writing one verify script per burst and reading only its filtered tail, instead of
  re-reading full outputs.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: pwsh -File passes 'a,b' to a [string[]] parameter as ONE string, so a filter built
  from it can come back empty; Format-Code and the other whole-tree commands now refuse an empty -Path (ValidatePathGiven).
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Rename-CodeName renames a name only as a whole token, so a hyphenated id such as
  g-\<name> is skipped; its rows carry Skipped as line:token, so read them before trusting a rename.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a glossary concept's forms must be one word, and Test-Glossary G6 checks the single
  word before the head word, so the form 'record' covers 'decision-record domain'.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-ManualTestPlan matches each row by test file AND Describe-block name, so a
  row's block column changes only together with the test's Describe text.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Diagrams reports staleness as the facts StaleDiagrams and StaleMinimapCount;
  diagrams are flat .assets/\<name>.drawio.yml + .drawio.png, and Build-Diagrams -Path takes the yml.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: in the DRS an implementation-domain record (automation, repository, azure, ado,
  configuration, github) really is the ADR kind, so 'the automation ADR' stays; only the umbrella becomes 'decision record' or 'the DRS'.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a pytest that monkeypatches minimaps.REPO must cache_clear kinds, rules and
  records_root, or a temp repository leaks into later tests.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: guarding every out/ script that feeds a path list to a tree-wide command with an
  explicit empty-list throw, before the import.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: delegating a repeated one-line edit over many files to parallel catzc-worker agents
  with exact file lists, not doing it in the main session.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: the live orchestrator a worker reports to is the interactive session that sends it
  work (catzc-9c on 2026-10-21); the background "Plan orchestration agent" session does not answer worker messages.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a plan's open checkbox can lag the tree by hours, so a chunk is checked with a grep
  or file read before it is claimed; drs-system steps 1-3 were already in the tree while still open.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a scratch folder out/\<topic>/ with staged copies and burst scripts means a peer is
  mid-burst on that plan, so a worker backs off it.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: hindsight lines go stale within a day, so its-a-chore-but-i-will-do-better must
  grep each gap before planning it; 8 of its 10 steps on 2026-10-21 had already landed.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: messaging the orchestrator that sends work (ListAgents, the session that messaged
  last) before reading plan-master and every plan.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: verifying a plan's landed steps with one combined grep per plan instead of one
  probe per step.
