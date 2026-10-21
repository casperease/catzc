# Hindsight 226bbf

Started 2026-10-21T05:07:31.0383252+02:00.

- 2026-10-21 Jack: If only the session had known that file-meta.yml, generated-head.yml and glossary.yml are read by every peer's next
  import: nothing in the tree says so or parks an edit during a burst (no capability line, no hook, no how-to), only the open question at
  .claude/plans/plan-session-learnings.md:42, so each robot learns it by outage.
- 2026-10-21 Jack: If only the session had opened its module article before inventing Test-AdrCodes:
  docs/references/pwsh/catzc-base-docs.md:127 lists Test-AdrRegistry, and docs/adr/repository/adr-code-language.md:156 says it runs the
  code_language check.
- 2026-10-21 Jack: If only the session had read the load sequence: docs/references/pwsh/internal/index.md:19 and
  docs/references/pwsh/catzc-base-rootconfig.md:62 declare the janitors, and Invoke-ImporterJanitors runs Build-Glossary and
  Build-RootConfig at pwsh/.internal/Catzc.Internal.Importer.psm1:381 and :405, though no line warns that a broken glossary source breaks
  every session.
- 2026-10-21 Jack: If only the session had checked the dependency graph: pwsh/Catzc.Base.ModuleSystem/configs/dependencies.yml:82-94 keeps
  Catzc.Base.Languages below Catzc.Base.QualityGates, where CommentsConfig.PageFor lives (types/CommentsConfig.cs:237), and nothing in the
  tree derives a docs edge for a generated head yet.
- 2026-10-21 Jack: If only the fixture had copied its neighbours: docs/references/pwsh/catzc-base-qualitygates/Get-FileMetaFact.ps1.md:20
  declares that a kind without its function fails the run, and Invoke-FileMetaEngine.Tests.ps1:37 already defines a script-scope
  Get-WidgetPathFileMetaFact, but no capability line points a test author at that precedent.
- 2026-10-21 Jack: If only a command had listed the callers of a type or config: .claude/CLAUDE.md demands every in-tree caller change in
  the same change (one living version), yet nothing in the tree finds them, so the grep stays a token tip.
- 2026-10-21 Jack: If only the session had read the entry script: pwsh/.internal/assets/Invoke-CatzcCommand.ps1:63 runs every quoted command
  in one bounded background call and prints N of M passed, and .claude/skills/catzc-run/SKILL.md:30 forbids an out/*.ps1 of one's own, so
  the per-step check script, its verdict grep and the batched plan check are already one call.
- 2026-10-21 Jack: If only the step had named its check: Test-Plans rejects it at pwsh/Catzc.Base.QualityGates/Test-Plans.ps1:201 under
  ADR-REPO-PLANS-OPENSTEP, declared in docs/references/pwsh/catzc-base-qualitygates/Test-Plans.ps1.md:24, waiting or not.
- 2026-10-21 Jack: If only the orchestrator had held its checks: pwsh/.internal/Catzc.Internal.Bootstrap.psm1:355 already throws when C#
  type sources change during the import, but no hold and go protocol exists in the plans-orchestrate capability, only the open question at
  .claude/plans/plan-session-learnings.md:36.
- 2026-10-21 Jack: If only the session had read Get-GitTrackedPath: docs/references/pwsh/catzc-base-files/Get-GitTrackedPath.ps1.md:14-17
  declares it answers from the index, which Test-IdiomaticNames (line 37) and Test-Links through Invoke-LinkEngine.ps1:48 both call, but the
  gate articles say only tracked, never until staged.
- 2026-10-21 Jack: If only someone had written the how-to before the rename: docs/how-to/automation/rename-a-tooling-folder.md does not
  exist, it is only an open step at .claude/plans/plan-idiomatic-names.md:102, so nothing in the tree yet says a tooling folder moves with
  its lookups in one burst.
- 2026-10-21 Jack: If only Format-Code had said what kind of change it made: pwsh/Catzc.Base.QualityGates/Format-Code.ps1:212 reports how
  many files changed, but nothing in the tree tells a re-wrap from a content change, so whether to reread stays a guess.
- 2026-10-21 Jack: If only the session had read the Invoke-PythonTest article:
  docs/references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md:23 and :45 declare ruff check before pytest and the failure it raises
  (Invoke-PythonTest.ps1:105), though not that the throw lands in the Language.Bridge.ps1:77 BeforeAll of every engine.
- 2026-10-21 Jack: If only the run had kept the message: New-TestAutomationShardScript.ps1:108 captures a file container's error and
  Write-TestRunFailures.ps1:50 prints it, but nothing in the tree reads a Describe-level BeforeAll failure such as Language.Bridge.ps1:77,
  so Get-LanguageTestOutcomes by hand remains the only lamp.
- 2026-10-21 Jack: If only the session had read the registry: pwsh/Catzc.Base.RootConfig/configs/rootconfig.yml:153-154 renders catzc.sln
  from assets/root/catzc.sln, .gitignore:71 ignores the root copy, and docs/references/pwsh/catzc-base-rootconfig.md:62 says the janitor
  renders it on every load, over any hand edit.
- 2026-10-21 Jack: If only the session had read docs/references/pwsh/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md:14-22:
  terminology.yml is the single source of the generated .cspell category lists, and glossary.yml never was.
- 2026-10-21 Jack: If only the corpus had a config: pwsh/Catzc.Base.QualityGates/private/Get-TerminologyCorpus.ps1:36-55 hard-codes its
  extensions and exclusions under a comment promising to mirror Test-Spelling, and nothing in the tree, no shared key and no gate, keeps the
  two lists in step.
- 2026-10-21 Jack: If only the session had trusted the gate: Test-ManagedGuids (pwsh/Catzc.Base.QualityGates/Test-ManagedGuids.ps1:65) fails
  every GUID not registered in guids.yml and names ConvertTo-Guid, and guids.yml:43-45 shows the sentence key.
- 2026-10-21 Jack: If only the session had read Get-NeutralCodeFinding.ps1.md:21-22: Test-SourceConventions checks neutral_codes only in L0
  blocks and skips -Tag values and block titles, with its exemptions in pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml:34.
- 2026-10-21 Jack: If only the session had run Test-ScriptAnalyzer: PSUseApprovedVerbs (analyzer-adr-map.yml:57,
  ADR-PWSH-VERBS-APPROVEDVERBS) already rejects Commit, while Save-Topic is not in the tree at all, only planned at
  .claude/plans/plan-git-topic-commands.md:56.
- 2026-10-21 Jack: If only Test-Automation had grouped its failures: Write-TestRunFailures.ps1:42-54 prints each failure with its message,
  but nothing in the tree groups the results-shard XML by message, so the throwaway script stays a token tip.
- 2026-10-21 Jack: If only CLAUDE.md had said which grep: .claude/CLAUDE.md:133 offers plain bash grep beside the Grep tool and the
  Assert-BashTimeout hook enforces the 3 s roof, yet no line warns that a recursive grep cannot finish inside it.
- 2026-10-21 Jack: If only the tip had read both instructions: .claude/CLAUDE.md:129 still prescribes multi-step work in a script under
  out/, while .claude/skills/catzc-run/SKILL.md:30 forbids an out/*.ps1 for cats commands and routes them through Invoke-CatzcCommand.ps1,
  so the tip is half right and the tree contradicts itself.
- 2026-10-21 Jack: If only the session had read the contract it is told to read first: docs/adr/repository/ai-agent-contract.md:78 already
  says the truth is the whole repository at one commit, committed files only, and :63 (ADR-REPO-AI-EDITORISFACT) makes the listen mode the
  one exception.
- 2026-10-21 Jack: If only the session had read the thesis instead of rediscovering it: docs/adr/thesis/truth-stores.md:22
  (TDR-STORES-RESPONSIBILITYDOMAIN) declares one repository per responsibility domain, and the rule, docs, code order exists only as a
  plan-step order in .claude/skills/listen-insight/SKILL.md:38, never as a ranking of truth.
- 2026-10-21 Jack: If only the session had read its own CLAUDE.md: .claude/CLAUDE.md:41 already says C:\projects\eac is read for inspiration
  only and that catzc ADRs decide, so the lesson cost a session and taught it nothing new.
- 2026-10-21 Jack: If only the module articles were whole: docs/references/pwsh/catzc-base-files.md:58 lists Copy-Directory and
  catzc-base-typessystem.md lists Build-AgentHook, but Get-FileKind, public in pwsh/Catzc.Base.Globs/Get-FileKind.ps1, is absent from the
  Division of docs/references/pwsh/catzc-base-globs.md, so the article a session should scan hides a part it needed.
- 2026-10-21 Jack: If only the session had trusted the time safeguard: .claude/CLAUDE.md:135 already gives a long call its limit in
  timeouts.yml or a command's TimeLimit, never a workaround, and the .claude/hooks/Assert-BashTimeout hook denies an unbounded Bash call
  before it starts.
- 2026-10-21 Jack: If only every lesson were this redundant: Measure-NoCollapsingAssignment
  (pwsh/.scriptanalyzer/NoCollapsingAssignment.psm1), mapped to ADR-PWSH-ERROR-STRICTCLEAN at
  pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml:49, already flags the collapse in Test-ScriptAnalyzer, as the learning itself
  admits.
- 2026-10-21 Jack: If only the session had read the pitfalls ADR: docs/adr/automation/pwsh/automatic-variable-pitfalls.md:279 already says
  the engine coerces $null to the empty string at assignment and at parameter binding.
- 2026-10-21 Jack: If only the session had read git-readonly: .claude/skills/git-readonly/SKILL.md:33 already says a file another session
  has dirty is reported, never edited, but no capability line says to re-read a shared file before relying on it, so peers are still trusted
  from stale memory.
- 2026-10-21 Jack: If only the session had read the contract: docs/adr/repository/ai-agent-contract.md:60 (ADR-REPO-AI-OUTISOUTPUT) says
  nearly word for word that a run reads back only its own stamped folder in out/ and waits through its absence.
- 2026-10-21 Jack: If only someone had written it down: .claude/CLAUDE.md:160 demands only that a gate is run before it is claimed passed,
  and nothing in the tree, no ADR rule, capability or how-to, says a new tool counts as working only after a live run, so green tests go on
  vouching for broken tools.
- 2026-10-21 Jack: If only the diagram kit had a sample path: docs/references/pwsh/catzc-base-slides/Build-Diagrams.ps1.md:29 declares that
  Build-Diagrams takes only diagram folders under docs/**/.assets/** and stops on any other path, while the private Write-DiagramMinimapData
  has only its comment page and no capability or how-to says an out/ sample needs it before put, so each sample in out/ is assembled from
  folklore.
- 2026-10-21 Jack: If only readers shared one parser: Format-MarkdownParagraph.ps1.md:17 and private/Format-LongMarkdownLines.ps1.md:16
  write list items with indented continuation lines at 140 columns and Test-Plans.ps1.md:24 reads an item with its continuation lines, but
  no public command reads a markdown list item back whole, so every reader rediscovers the wrap.
- 2026-10-21 Jack: If only the help said one object: docs/references/pwsh/catzc-base-docs/Format-MarkdownParagraph.ps1.md:40 declares
  [string[]] as the output, while the closing unary comma before $lines.ToArray() in pwsh/Catzc.Base.Docs/Format-MarkdownParagraph.ps1 sends
  the array as one pipeline object, and no line of the article warns the joiner.
- 2026-10-21 Jack: If only the pitfalls ADR knew .NET: nothing in the tree, no ADR, analyzer rule or capability, mentions System.IO.File
  ReadLines, so a lazy reader cut short by Select-Object -First keeps its file open until the next write fails.
- 2026-10-21 Jack: If only the session had read the lint config: .markdownlint.yml:118 turns MD033 on and says the placeholder notation
  lives in code spans, and Test-Markdownlint enforces it, so the backslash escape was always the second-best answer.
- 2026-10-21 Jack: If only the session had asked the config: pwsh/Catzc.Base.Docs/types/LearningsConfig.cs:14-18 declares .claude/learnings,
  the learned prefix and 5 files of 50 lines, registered at pwsh/Catzc.Base.Config/configs/configs.yml:119, and Add-SessionLearning writes
  them, so this lesson was a default reading itself aloud.
- 2026-10-21 Jack: If only the session had read one line of adrs.yml: pwsh/Catzc.Base.Docs/configs/adrs.yml:213 gives the thesis domain
  depends_on [research], and Test-AdrRegistry fails any citation outside it, so the gate taught what one grep would have.
- 2026-10-21 Jack: If only the session had read the check before the gate read it back: Get-GlossarySourceViolations, G1 of Test-Glossary,
  already fails a contrast that is not reciprocal across sources
  (docs/references/pwsh/catzc-base-docs/private/Get-GlossarySourceViolations.ps1.md:41, ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED).
- 2026-10-21 Jack: If only the steps lived in one place: the authoring conventions name adrs.yml at docs/adr/index.md:406, the glossary
  sources at :419 and dora-explains.md at :448, and .claude/skills/catzc-verify/SKILL.md:22 names Build-AdrIndex, but no how-to under
  docs/how-to/ lists the steps of adding an ADR in order, exactly as the learning complains.
- 2026-10-21 Jack: If only New-Plan finished the job: pwsh/Catzc.Base.QualityGates/New-Plan.ps1:10 writes the plan file only and leaves the
  value row and the master line to the hand, though docs/adr/repository/plans.md:59 calls plan-master.md a derived executable, and no
  command rebuilds it or guards sessions editing it at once.
- 2026-10-21 Jack: If only the session had read the glossary avoid table: docs/adr/glossary.md:60 already tells the eac normal form from the
  sibling eac repository (ADR-REPO-INSPIRE), and :1432 names the sibling an inspiration, so the double meaning was settled before it was
  learned.
- 2026-10-21 Jack: If only the session had read either entry: docs/adr/glossary.md:46 (eac normal form, TDR-NORMALFORM) and :951
  (repository normal form, ADR-AUTO-IDIOM-NORMALFORM) already contrast each other in the very words of the learning.
- 2026-10-21 Jack: If only Add-SessionLearning had looked before it wrote: pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1 appends every line
  it is given and checks no existing line, its only Contains at :113 guarding the list of files written, so a relayed lesson is logged twice
  and nothing in the tree notices.
- 2026-10-21 Jack: If only the tip had read catzc-run: .claude/skills/catzc-run/SKILL.md:17 sends a cats command through the entry script,
  never an out/*.ps1 of its own, so the script the tip anchors should not exist, yet neither importer.ps1 nor Invoke-CatzcCommand.ps1 sets a
  location, so a relative path inside a quoted command still drifts.
- 2026-10-21 Jack: If only the safeguard had said the second half: .claude/CLAUDE.md:133 and .claude/skills/catzc-run/SKILL.md:19 forbid cd
  and && in a background call, but no line in the tree says to use absolute paths in Bash, so the drifting folder is learned by failure.
- 2026-10-21 Jack: If only the session had read the capability it loads: .claude/skills/catzc-run/SKILL.md:19 already prescribes
  Invoke-TestFile with -PassThru, so the silent failure was a capability skipped, not a fact missing.
- 2026-10-21 Jack: If only the session had read the registry: pwsh/Catzc.Base.Docs/configs/capabilities.yml:140, :145, :150 and :155
  register plan-shape, plan-intake, plan-decide and plan-value, and .claude/CLAUDE.md:90 lists the plan-clear robot, so the refinement
  toolset was declared, just never called that.
