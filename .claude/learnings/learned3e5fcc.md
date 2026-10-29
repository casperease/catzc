# Session learnings 3e5fcc

Started 2026-10-27T09:07:37.7185717+01:00.

- 2026-10-27 Cats: In hindsight I wish I knew this fact: the widget/gadget test fixtures carry Catzc. and CATZC_ on purpose, because the
  code under test filters on those prefixes.
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Test-Glossary (96) and Test-Terminology (3) already fail on main for reasons
  unrelated to catzc naming.
- 2026-10-27 Cats: Token tip: Next time, save tokens by: grouping the hits by token form and checking against disk names in one script,
  before planning any edits.
- 2026-10-27 Cats: Token tip: Next time, save tokens by: reading three hits of a category in context before accepting a heuristic category
  as a fix list.
- 2026-10-27 Cats: In hindsight I wish I knew this fact: a DRS reviewer agent covers about 80k tokens of records per pass, so a 300k-word
  domain needs a slice of under 10 records per agent
- 2026-10-27 Cats: In hindsight I wish I knew this fact: the DRS biggest bloat is tier misplacement — flow/ carries ADO and pwsh mechanics,
  automation/ names cmdlets in rule text — which Test-DrsEngineNeutrality does not catch in flow/, design/ or thesis/
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Test-Plans requires a ## Open steps section of checkbox steps, each naming its
  check; numbered ## sections fail ADR-REPO-PLANS-ONESHAPE
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Format-Code on markdown turns a bare FDR-DETECT-* glob into an emphasis underscore,
  so plan text names rule families without a trailing star
- 2026-10-27 Cats: In hindsight I wish I knew this fact: several DRS records still contradicted each other (generated-head keys, plan
  location, prod approval, landing-zone policy count) and no gate cross-checks rule pairs
- 2026-10-27 Cats: Token tip: brief DRS review agents with a fixed file list of under 10 records instead of a whole domain, so no agent
  stops mid-slice and needs a resume
- 2026-10-27 Cats: Token tip: write a plan in the plans shape (## Open steps, checkbox plus Check) from the start instead of reshaping it
  after Test-Plans fails
- 2026-10-27 Cats: In hindsight I wish I knew this fact: a record's domain may cite only the domains drs.yml lists under its depends_on
  (design: external, principles, process; pwsh: no repository or configuration), so a merge or move must be checked against that list before
  a rule collapses into another domain
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Update-DrsCitation rewrites code files too, and importer-path .ps1 files and
  types/*.cs sources it touches must be held out of the live run and landed by Invoke-StagedBurst
- 2026-10-27 Cats: In hindsight I wish I knew this fact: Invoke-CatzcCommand holds the Local catzc-run lock until its lease ends even after
  its task is stopped, so a stopped run blocks the next one
- 2026-10-27 Cats: In hindsight I wish I knew this fact: the user commits mid-burst, so a gate script must take changed files from recent
  commits, not from git diff of the working tree
- 2026-10-27 Cats: In hindsight I wish I knew this fact: a drone briefed with a whole domain stops at its 50-turn limit; under ten records
  or one merge group per drone finishes
- 2026-10-27 Cats: Token tip: run content-only drones that write rule-map rows, then one combined Update-DrsCitation, pre-filtered with git
  grep to the files that name a retired code
- 2026-10-27 Cats: Token tip: brief drones with the domain dependency list and the importer-path hold rule up front instead of correcting
  them mid-run
- 2026-10-28 Cats: In hindsight I wish I knew this fact: the only catzc-named files outside namespace modules and command names are
  contracts/catzc/, the .claude/skills/catzc-* skills, the two analyzer entry rules, cats.bats and a-day-in-cats/.
- 2026-10-28 Cats: In hindsight I wish I knew this fact: CatzcRules.psm1 and CatzcSpelling.psm1 are entry-rule wrappers; their names are
  read by PSScriptAnalyzerSettings.psd1 and three Base.QualityGates readers.
- 2026-10-28 Cats: In hindsight I wish I knew this fact: the markdown link gate is Test-Links; Test-MarkdownLinks does not exist and
  Test-Plans rejects it as a check.
- 2026-10-28 Cats: Token tip: Next time, save tokens by: listing named paths with one git ls-files | grep -io segment count instead of
  several probes.
- 2026-10-28 Cats: The generated fact lives in six configs: generated-files.yml, every module configs/generated.yml, rootconfig.yml,
  readme.yml, comment-pages.yml and the variants members generated/committed flags; Get-GeneratedTarget merges four of them.
- 2026-10-28 Cats: PNG is 100 of 130 MB tracked; the image chain (drawio.yml or a yml drawio article block, then .drawio.png, slide picture
  .png, .slide.png) is written by Build-Diagrams and python/diagrams/slide_png.py, mostly unregistered as writers.
- 2026-10-28 Cats: filters.yml already has a generated view resolved by Get-RepositoryFilter, so roll-off needs no new entity.
- 2026-10-28 Cats: file-carriers.yml marks png, svg and xml carrier none, so no image can carry a generated head today.
- 2026-10-28 Cats: A generated head is a one-way note to people: no tool decides anything from it.
- 2026-10-28 Cats: Token tip: answer what is generated from Get-GeneratedTarget and file-carriers.yml before sweeping git ls-files.
- 2026-10-29 Cats: In hindsight I wish I knew this fact: slot configs hold no resource names today; every name is derived from options.yml
  names: by Resolve-BicepDerivedNames
- 2026-10-29 Cats: In hindsight I wish I knew this fact: storage and vm names fuse components without separators, so a name can only be
  matched against candidate renders, not parsed
- 2026-10-29 Cats: In hindsight I wish I knew this fact: discovery/configuration/nsub.yml hard-codes resource-group and key-vault names
  inside a key vault reference id, unchecked by any gate
- 2026-10-29 Cats: In hindsight I wish I knew this fact: ado_naming also orders service-connection names, so it is the one naming order
- 2026-10-29 Cats: In hindsight I wish I knew this fact: Test-Plans wants a ## Open steps section, a check on each step line itself, and
  only commands a module exports
- 2026-10-29 Cats: Token tip: read Get-BicepTemplates and Read-BicepTemplateOptions first for any options.yml change
- 2026-10-29 Cats: Token tip: copy an existing plan head and Open steps shape before writing a new plan
- 2026-10-29 Cats: In hindsight I wish I knew this fact: the diagram kit is a strict editable install that hard links each python/diagrams
  file into build/**editable**, so an edit that replaces a file runs the stale copy until Install-PythonWorkspace -ReinstallPackage
  catzc-diagrams; Invoke-PythonTest now refuses a stale link.
- 2026-10-29 Cats: In hindsight I wish I knew this fact: Build-Diagrams finds an article that embeds a png only among git-tracked files, so
  a diagram moved on disk without git mv is an E_ORPHAN; Move-Diagram (git mv) is the way to rename.
- 2026-10-29 Cats: In hindsight I wish I knew this fact: Build-Diagrams and Test-Diagrams take diagram paths, never a folder; pass a list
  through (Get-Content \<file>).
- 2026-10-29 Cats: In hindsight I wish I knew this fact: in a minimap place row, x.+N is N places and a.(root)|b|c is three, per
  ADR-AUTO-IDIOM-PLACENORMALFORM; reviewers misread the counter otherwise.
- 2026-10-29 Cats: In hindsight I wish I knew this fact: Test-Plans resolves every command named inside a check through Get-Command, so a
  private function or a deleted name in a check is a finding.
- 2026-10-29 Cats: Token tip: Next time, save tokens by: briefing haiku reviewers with the place-row notation up front, so a 181-png round
  returns no false counter findings.
- 2026-10-29 Cats: Token tip: Next time, save tokens by: telling every drone to report after about 40 turns, since drones at the 50-turn
  limit stop with no report and need a resume.
