# Session learnings b6d1f9

Started 2026-10-21T04:34:42.3401959+02:00.

- 2026-10-21: In hindsight I wish I knew this fact: a config like file-meta.yml or generated-head.yml is live for every session; while a
  peer runs a burst, park an edit to it in out/ and put the old file back.
- 2026-10-21: In hindsight I wish I knew this fact: the quality gate for ADR codes is Test-AdrRegistry; there is no Test-AdrCodes.
- 2026-10-21: In hindsight I wish I knew this fact: the importer runs Build-RootConfig and Build-Glossary as janitors, so a writer or
  glossary.yml change shows up in, or breaks, every session's next import.
- 2026-10-21: In hindsight I wish I knew this fact: Format-GeneratedFileHead sits in Catzc.Base.Languages, below the comment-page lookup
  (CommentsConfig.PageFor in Catzc.Base.QualityGates), so a generated head cannot derive its docs edge yet.
- 2026-10-21: In hindsight I wish I knew this fact: a test fixture that names a meta-kind processor needs that function to exist; a
  test-only processor defined in module scope and removed in AfterAll keeps the fixture independent of the shipped kinds.
- 2026-10-21: Token tip: Next time, save tokens by: grep the callers and the tests that assert a shape before changing a type or config, so
  every caller lands in one pass.
- 2026-10-21: Token tip: Next time, save tokens by: reuse one check script per step in out/ and filter its output with a single grep for
  verdict lines.
- 2026-10-21: In hindsight I wish I knew this fact: Test-Plans rejects any open step that names no check, a waiting or decided-but-unrun
  step included.
- 2026-10-21: In hindsight I wish I knew this fact: every Test-Plans or Format-Code run imports the tree, so an orchestrator check collides
  with a peer's C# edit (C# type sources changed during the import) or burst.
- 2026-10-21: In hindsight I wish I knew this fact: shared configs (glossary.yml, file-meta.yml, generated-head.yml) are read by every
  session's next import, so one invalid edit breaks every import at once.
- 2026-10-21: In hindsight I wish I knew this fact: Test-IdiomaticNames and Test-Links read the git index, so a move on disk still shows the
  old path until the user stages it.
- 2026-10-21: In hindsight I wish I knew this fact: a rename of a folder the tooling names (test folders, python modules) must land with its
  lookups and validators in one burst, or Invoke-TestFile or the importer breaks for every session.
- 2026-10-21: In hindsight I wish I knew this fact: pwsh/.internal/assets/Invoke-CatzcCommand.ps1 runs several quoted commands in one
  bounded background call and reports N of M passed.
- 2026-10-21: Token tip: Next time, save tokens by: batching the plan edits of a round and running one Invoke-CatzcCommand check for them.
- 2026-10-21: Token tip: Next time, save tokens by: skipping the reread of a plan that Format-Code only re-wrapped.
- 2026-10-21: Invoke-PythonTest runs ruff check before pytest, so one lint error fails every Python case of that test folder in every engine
  through the Language.Bridge.ps1 BeforeAll.
- 2026-10-21: The Pester results XML does not carry a failed BeforeAll message; calling Get-LanguageTestOutcomes in the module scope shows
  it.
- 2026-10-21: The root catzc.sln is gitignored and rendered by Build-RootConfig from pwsh/Catzc.Base.RootConfig/assets/root/catzc.sln, which
  has a BOM and no head; a hand edit of the root is lost on the next render.
- 2026-10-21: cspell vocabulary comes from terminology.yml through Build-TerminologyDictionary into .cspell/\<category>.txt, not from the
  glossary.yml sources.
- 2026-10-21: Test-Terminology counts a term as used only in the file types Get-TerminologyCorpus reads, which mirror the Test-Spelling path
  list; the two lists are kept in step by hand.
- 2026-10-21: Catzc-owned GUIDs are minted with ConvertTo-Guid '\<sentence>' and registered in guids.yml with that sentence.
- 2026-10-21: The neutral-code check flags a real ADR code only in an L0 test string outside -Tag values and block titles.
- 2026-10-21: Commit is not an approved PowerShell verb; the git topic commands use Save-Topic for commit semantics.
- 2026-10-21: Token tip: group a failed run by message from out/test-automation/\<run>/results-shard-*.xml in one script before reading any
  test file.
- 2026-10-21: Token tip: search the tree with the Grep tool, not recursive grep in Bash, which overruns the 3 s foreground limit.
- 2026-10-21: Token tip: write multi-step pwsh work to out/\<name>.ps1 with Write and run it as one timeout-prefixed background call.
