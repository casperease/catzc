# Session learnings b6d1f9

Started 2026-10-21T04:34:42.3401959+02:00.

- 2026-10-21 Cats: In hindsight I wish I knew this fact: a config like file-meta.yml or generated-head.yml is live for every session; while
  a peer runs a burst, park an edit to it in out/ and put the old file back.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the quality gate for ADR codes is Test-AdrRegistry; there is no Test-AdrCodes.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the importer runs Build-RootConfig and Build-Glossary as janitors, so a writer or
  glossary.yml change shows up in, or breaks, every session's next import.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Format-GeneratedFileHead sits in Catzc.Base.Languages, below the comment-page
  lookup (CommentsConfig.PageFor in Catzc.Base.QualityGates), so a generated head cannot derive its docs edge yet.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a test fixture that names a meta-kind processor needs that function to exist; a
  test-only processor defined in module scope and removed in AfterAll keeps the fixture independent of the shipped kinds.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: grep the callers and the tests that assert a shape before changing a type or
  config, so every caller lands in one pass.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: reuse one check script per step in out/ and filter its output with a single grep
  for verdict lines.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Plans rejects any open step that names no check, a waiting or
  decided-but-unrun step included.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: every Test-Plans or Format-Code run imports the tree, so an orchestrator check
  collides with a peer's C# edit (C# type sources changed during the import) or burst.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: shared configs (glossary.yml, file-meta.yml, generated-head.yml) are read by every
  session's next import, so one invalid edit breaks every import at once.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-IdiomaticNames and Test-Links read the git index, so a move on disk still
  shows the old path until the user stages it.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a rename of a folder the tooling names (test folders, python modules) must land
  with its lookups and validators in one burst, or Invoke-TestFile or the importer breaks for every session.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: pwsh/.internal/assets/Invoke-CatzcCommand.ps1 runs several quoted commands in one
  bounded background call and reports N of M passed.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: batching the plan edits of a round and running one Invoke-CatzcCommand check for
  them.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: skipping the reread of a plan that Format-Code only re-wrapped.
- 2026-10-21 Cats: Invoke-PythonTest runs ruff check before pytest, so one lint error fails every Python case of that test folder in every
  engine through the Language.Bridge.ps1 BeforeAll.
- 2026-10-21 Cats: The Pester results XML does not carry a failed BeforeAll message; calling Get-LanguageTestOutcomes in the module scope
  shows it.
- 2026-10-21 Cats: The root catzc.sln is gitignored and rendered by Build-RootConfig from pwsh/Catzc.Base.RootConfig/assets/root/catzc.sln,
  which has a BOM and no head; a hand edit of the root is lost on the next render.
- 2026-10-21 Cats: cspell vocabulary comes from terminology.yml through Build-TerminologyDictionary into .cspell/\<category>.txt, not from
  the glossary.yml sources.
- 2026-10-21 Cats: Test-Terminology counts a term as used only in the file types Get-TerminologyCorpus reads, which mirror the Test-Spelling
  path list; the two lists are kept in step by hand.
- 2026-10-21 Cats: Catzc-owned GUIDs are minted with ConvertTo-Guid '\<sentence>' and registered in guids.yml with that sentence.
- 2026-10-21 Cats: The neutral-code check flags a real ADR code only in an L0 test string outside -Tag values and block titles.
- 2026-10-21 Cats: Commit is not an approved PowerShell verb; the git topic commands use Save-Topic for commit semantics.
- 2026-10-21 Cats: Token tip: group a failed run by message from out/test-automation/\<run>/results-shard-*.xml in one script before reading
  any test file.
- 2026-10-21 Cats: Token tip: search the tree with the Grep tool, not recursive grep in Bash, which overruns the 3 s foreground limit.
- 2026-10-21 Cats: Token tip: write multi-step pwsh work to out/\<name>.ps1 with Write and run it as one timeout-prefixed background call.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-ShippedConfigs fails every key a shipped config sets away from its type
  default unless configs.yml carries a differs reason for that key.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a second rolling log is one more LearningsConfig instance in configs.yml
  (hindsight.yml: folder, prefix, title) written through Add-SessionLearning -Log hindsight, never hand-written files.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the robot and capability roofs count logical lines, so a wrapped continuation
  counts with the line it continues and an 8-step body of 24 physical lines passes the roof of 20.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a robot that checks 26 learnings at three probes each spends over 80 tool calls, so
  a 40-turn roof ends before its first write; it appends in batches of ten and carries maxTurns 120.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Format-Code now strips the derived catzc head from robots, capabilities, slide
  pages and docs/index.md under the minimal-heads policy, so a whole-tree run rewrites every file still carrying one while a -Path run
  touches only its files.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the .claude/plans edits of a robot pass Test-Plans only when every open step names
  its check, including a step that waits on a peer-dirty file.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: giving a log-reading robot its probe cap and batch append in its body before the
  first run, not after a 90k-token dry run that wrote nothing.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: running Format-Code with -Path on the files touched inside a robot, never -Language
  markdown, so a check never rewrites 68 files the session must then diff.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: ValidatePattern matches case-insensitively unless it carries Options = None, so a
  pattern that starts with [A-Z] accepts a lowercase word until the option is set.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a robot that keeps a log carries persona in its agents.yml entry (Jack, Susan from
  HR) and signs through Add-SessionLearning -Author, so a line reads - \<date> \<Author>: \<sentence>; a main session signs Cats.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: landing an optional registry key with its type test case and its registry doc page
  in the same pass, so the gate run that follows is the only one.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: pwsh/.internal/Catzc.Internal.Loader.psm1 exports an explicit list at its end, so a
  new loader function is invisible until named in that Export-ModuleMember line.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the host detectors Test-IsRunningInPipeline and Test-IsRunningInVSCode live in the
  loader because the C# types pre-pass in Catzc.Internal.Bootstrap runs before any module is loaded.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the stale-types branch of Import-CSharpTypes decides in order pipeline (throw), VS
  Code terminal (one yellow line naming the loaded and source hashes, never a throw), other devbox (a missing type throws, a changed one
  warns).
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Measure-NoRawPipelineDetection maps each host variable to its one reader (TF_BUILD
  and GITHUB_ACTIONS to Test-IsRunningInPipeline, TERM_PROGRAM to Test-IsRunningInVSCode) and exempts test files.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a comment page section names the code line it sat above, so changing that line
  fails Test-Comments on the page until the "Above" line is re-pointed.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Sync-FileMeta on a new .ps1 derives its whole head, test and docs edges included,
  and the module psd1 regenerates at the next import without a hand edit.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1 clears TERM_PROGRAM in its
  BeforeEach, because a run from a VS Code terminal would otherwise turn every devbox case into a VS Code case.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a module README is generated by Build-Readme from its
  docs/references/pwsh/\<module>.md page, so a new public function is listed in that page's Division table, never in the README.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: checking an internal psm1's Export-ModuleMember line before the first test run of a
  function added to it.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: running the test files and the heads-and-gates script in one background run after
  the last edit, not two.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Test-Plans -Path resolves a relative path against the process folder, not the
  repository root, so a call passes an absolute path until plan-agent-friction step 2 lands.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: plan-master.md can omit a plan entirely, and Test-Plans does not catch it until
  plan-agent-friction step 1 makes the master line a checked part of a plan.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: most plan drift is a master pointer line or value-row state that still lists steps
  already pruned from the plan, so comparing them with the open steps finds it fastest.
