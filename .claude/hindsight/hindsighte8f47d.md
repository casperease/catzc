# Hindsight e8f47d

Started 2026-10-22T04:59:45.8045278+02:00.

- 2026-10-22 Jack: If only the session had read the options type: pwsh/Catzc.Base.Docs/types/GlossaryOptions.cs:34-37 declares the
  DefaultExclude every glossary source carries, plans, hindsight and learnings included, and :48 appends a source own excludes after it, so
  a glossary.yml adds and never removes, by declaration.
- 2026-10-22 Jack: If only the measurement had read the plan: .claude/plans/plan-debt-test-speed.md:13 already records
  Invoke-TestFile.Tests.ps1 at 55.1 s and 43.4 s and keeps it as it is, its cost the snapshot path it proves, and
  pwsh/Catzc.Base.Timeouts/configs/timeouts.yml:12 prices a full snapshot run, so the no-fix verdict was on file before the stopwatch.
- 2026-10-22 Jack: If only Jack had read past his own complaint: docs/references/pwsh/catzc-base-quality-gates/Invoke-TestFile.ps1.md:37-39
  now says a failed priming import stops the run with its exit code and last ten lines, keeps the output in out/test-snapshot-priming/ and
  writes no run.json, so the earlier line of this log saying no line tells how priming fails is stale.
- 2026-10-22 Jack: If only the article agreed with the engine: docs/references/pwsh/catzc-base-quality-gates/Export-Comments.ps1.md:23 still
  scopes the export to tracked files outside tests/ and private/Get-CommentScope.ps1.md:17 excludes tests by default, yet test pages such as
  tests/Export-Comments.Tests.ps1.md exist, so a page written for a new test file is learned against its own documentation.
- 2026-10-22 Jack: If only a worker knew whose head it moves: pwsh/Catzc.Base.QualityGates/configs/file-meta.yml:34-37 derives the test edge
  of a function or type from its test file existing, so a new test changes its code file head by declaration, but no capability and no
  catzc-worker line says that re-imprint is a file to ask its owner for.
- 2026-10-22 Jack: If only the session had read the entry script head: pwsh/.internal/assets/Invoke-CatzcCommand.ps1:25-26 takes the
  Local\catzc-run lock before the import, so a waiting run holds no import, and :58 waits -LockSeconds 120, so the order that spares the
  memory is declared where every run starts.
- 2026-10-22 Jack: If only the queue had read the same head: pwsh/.internal/assets/Invoke-CatzcCommand.ps1:28-29 makes a waiting run wait as
  long as a burst lasts and then up to -LockSeconds more, so run lock busy after 120 s behind a burst is stale and asking the burst owner
  first buys nothing the lock does not already give.
