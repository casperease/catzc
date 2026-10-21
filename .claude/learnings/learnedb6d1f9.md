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
