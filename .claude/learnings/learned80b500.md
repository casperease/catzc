# Session learnings 80b500

Started 2026-10-21T02:21:00.2535622+02:00.

- 2026-10-21 Cats: The markdown formatter rewraps any list line past 140 columns, so code that reads its own markdown back treats indented
  continuation lines as part of the item.
- 2026-10-21 Cats: Format-MarkdownParagraph returns its lines as one array object; pipe it through ForEach-Object before joining.
- 2026-10-21 Cats: `[System.IO.File]::ReadLines($f) | Select-Object -First 1` leaves the file open; read the whole file before writing to
  it.
- 2026-10-21 Cats: markdownlint (MD033) reads a `<word>` outside code spans as inline HTML; escape it as `\<`.
- 2026-10-21 Cats: Session learnings live in .claude/learnings/ as learned\<sha>.md files ordered by their Started line; Add-SessionLearning
  writes them, 5 files of 50.
- 2026-10-21 Cats: A thesis ADR may cite only research and thesis rules (adrs.yml depends_on), and Test-AdrRegistry fails any other
  citation, so later-domain ideas appear there as plain words.
- 2026-10-21 Cats: Test-Glossary (G1) requires a contrast written on both terms, in each owning module's glossary.yml, even across modules.
- 2026-10-21 Cats: Test-Links reports a link to an existing but uncommitted file as an error, so a new ADR always shows one finding until it
  is committed.
- 2026-10-21 Cats: Adding an ADR touches the page, the adrs.yml ruleset and domain description, Build-AdrIndex, glossary.yml with
  Build-Glossary, the domain's dora-explains.md, and Format-Code; no how-to lists these.
- 2026-10-21 Cats: A background Bash call takes one command after its timeout prefix, and the entry script
  pwsh/.internal/assets/Invoke-CatzcCommand.ps1 runs several quality gates in that one call, so no script file is needed.
- 2026-10-21 Cats: plan-master.md and value-of-plan.md are edited by several sessions at once; a new plan adds one master line and one value
  row without touching other lines.
- 2026-10-21 Cats: "eac" names both everything as code (PDR-EAC, the eac normal form) and the sibling repository C:\projects\eac.
- 2026-10-21 Cats: "repository normal form" (ADR-AUTO-IDIOM) is a name's spelling, while "eac normal form" (TDR-NORMALFORM) is the
  verifiable shape of a whole piece of code.
- 2026-10-21 Cats: Token tip: read docs/references/pwsh/index.md and file-kinds.yml before designing a feature; most parts already exist,
  and a design round on a part that exists is the costliest waste.
- 2026-10-21 Cats: Token tip: run every check of a round in one out/ script with one fresh import, not one background call per gate or test
  file.
- 2026-10-21 Cats: Token tip: read a failed test's cause straight from its results XML (grep the \<failure> message), not by listing
  artifacts first.
- 2026-10-21 Cats: Each session appends its own learnings and token tips with Add-SessionLearning; lines relayed through another session get
  logged twice.
- 2026-10-21 Cats: Token tip: start every out/ script with Set-Location (Get-RepositoryRoot) after the import, since the shell's working
  folder drifts between calls and a relative path then fails.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: no plan-refinement skill exists; plan-shape, plan-decide and plan-clear together
  are the refinement toolset.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Plans -Path resolves a relative path against the process directory, not the
  repository root, so a script passes it absolute.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Plans passes numbered open steps that carry no [ ] checkbox, while the closing
  sweep counts only - [ ] lines.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: .claude/CLAUDE.md advises pwsh -Command ". ./importer.ps1; \<cmd>" while catzc-run
  forbids ; in a background call.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the fact-checker robot already runs on haiku; only its stale model_reason in
  agents.yml remains.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: 267 .cs files carry language: csharp in their head, so the csharp row rename costs
  about 290 files until minimal-heads drops the key.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: at most 20 subagents run at once; a 41-agent fan-out needs a second wave.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: putting a fan-out brief in one file and giving each agent a one-line prompt that
  names it.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: using absolute paths in Bash, since a cd persists and later relative cat calls
  fail.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: an ADR in one domain may cite only the domains in its adrs.yml depends_on, and
  Get-AdrCitationGraphViolations counts bare codes too, so design and repository ADRs name the thesis by its glossary term, never an TDR
  code.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: an unquoted YAML flow-map value with a comma (glossary.yml avoid: { say: a, b })
  parses as an extra key, and the importer's Build-Glossary janitor then fails every session's import.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Invoke-TestFile reports a failing test without throwing, so a runner sees the
  failure only through -PassThru and its Result.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the contract schema checker accepts only type, required, properties,
  additionalProperties, enum, items and const; minLength, format and minItems are refused.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Pester -BeLike treats [..] as a wildcard class, so a YAML flow list like [widgets]
  in an expected string needs an ordinal StartsWith instead.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Build-Diagrams and Test-Diagrams accept only folders under docs/, so a sample in
  out/diagrams/dark-sample/ is put by declaration.py and stays ungated until it moves.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the diagram kit has no read or junction edge kinds and its thick-edge legend is
  fixed to "to a named set", so thesis drawings borrow flow edges.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Format-Code on a whole module folder also writes missing heads into tracked files
  beside the ones you changed.
- 2026-10-21 Cats: Token tip: run every gate through pwsh/.internal/assets/Invoke-CatzcCommand.ps1 with several quoted commands in one
  background call instead of one out/*.ps1 per gate.
- 2026-10-21 Cats: Token tip: before citing a rule code in an ADR, check the owning domain's depends_on in adrs.yml, which costs one grep
  and saves a failed quality gate and a round trip.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the importer runs Build-RootConfig, which runs New-PythonProject and
  New-GoWorkspace, so changing a test-folder validator breaks every session's import unless the folder rename lands in the same pass.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Invoke-TestFile calls Get-LanguageTestFolders on every run, so a test-folder rename
  must land together with the folder-to-module mapping.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a module's test folder name is rendered in one place, LanguagesConfig.TestFolderOf
  (the module's words in the language's first folder case); Get-LanguageTestFolders, Invoke-PythonTest/GoTest/BashTest and Get-ModuleGlobSet
  call it.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: python/uv.lock is gitignored and pins workspace member paths, so after a member
  folder moves it must be deleted before uv sync passes.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-IdiomaticNames and Test-Links read the git index, so a moved path is judged
  under its new name only after the user stages the move.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the comment-page and readme {kebab} mapping is ToLowerInvariant().Replace('.',
  '-'), so a snake module folder such as catzc_diagrams gets docs/references/python/catzc_diagrams pages.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Pester's Should -Throw takes a -like pattern, so [ ] in an expected message is a
  character class; match brackets with ?.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the PowerShell parser keeps a scope qualifier in FunctionDefinitionAst.Name
  (script:New-Widget), so a name check strips it first.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: pwsh -File passes a comma list as one string, so a script taking several paths
  splits its argument itself.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: grepping every caller of a naming convention (e.g. ToLowerInvariant().Replace('.',
  '-')) before planning a rename, instead of finding them through red runs.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: preparing a multi-file rename as copies under out/ with apply and rollback scripts
  from the start, applied in one burst.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a meta kind with no select runs on every carrier's state, and only the Markdown
  state carried BodyHash, so a select-less body-sha threw in every session's Format-Code.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-Config caches a config for the importer session, so a config edit reaches
  another session only on its next fresh import, together with any code on disk.
