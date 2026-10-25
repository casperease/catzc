---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: feature
  targets: [docs/references, docs/drs/repository/comments-in-docs.md, pwsh]
---

# Comment articles: every comment page becomes a small reference article on its source file

1,789 pages under `docs/references/` still open with the exporter's fresh-page line, most holding verbatim `## comment:N` sections. The user
wants each pruned into a small article that explains what its code or config does, the gold traced back to the source file as a one-line
comment, and the page ready for the next `Export-Comments` run.

## Decided (the user, 2026-10-25)

- A page becomes an article: the `# <path>` title, a lead saying what the file is and does, then short `##` sections (keys, validation,
  behaviour, why it is shaped so). Every `## comment:N` section is folded into that prose and deleted, its context line with it.
- `## help` is the author's and stays word for word (ADR-REPO-COMMENTS-PAGEISAUTHORED).
- Gold, an insight the source does not already carry at that place, goes back into the source as one line: below `min_lines: 2`, never
  adjacent to another comment line (plan-comment-insights.md). Narration, history and to-dos are dropped, not moved.
- Future-proof by construction: `Page.Parse` keeps all text before the first `## comment:N` heading, so the next export appends new sections
  below the article and touches nothing else. A page left with no sections and no prose is not left empty: it gets at least the lead.
- Links in article prose are relative (`../../../drs/...`); the repository-rooted links copied from comments fail `Test-Links`.
- Pilot done and gated in `docs/references/pwsh/catzc-base-vendor/` (vendor.yml, VendorConfig.cs, Install-VendorModule.ps1): it is the
  pattern to copy.

## Open steps

- [ ] `docs/drs/repository/comments-in-docs.md`: ADR-REPO-COMMENTS-MOVELOSESNOTHING says the move is verbatim, and
      ADR-REPO-COMMENTS-PAGEISAUTHORED lets the author edit; add to PAGEISAUTHORED that the author folds sections into the page's article
      prose and deletes them, the source's one-line insight staying in place, and that the view then shows only the sections still on the
      page. Check: `Test-Links` and `Test-Spelling` on the file, and `Test-Comments` over the vendor pilot still reports no issues.
- [ ] Rollout, one module per step, in the master's order, after plan-comment-insights.md's TypesSystem, RootConfig and Slides steps land
      (their peers are writing source lines there): delegated to `catzc-drone`, at most 8 modules in flight, each brief naming its module's
      page folder and source folder as the files it owns and the vendor pilot as the pattern. Per page: write the article, keep `## help`,
      add a source line only for gold, then check each module. Check: `Format-Code -Language markdown -Path <page folder>`, then
      `Test-Markdownlint`, `Test-Spelling` and `Test-Links` on the pages report 0 issues, `Test-Comments -Path <source folder>` reports 0
      issues, `Export-Comments -Path <source folder> -DryRun` moves nothing, and the tests of every changed source file pass after a fresh
      import.
- [ ] The non-module trees last: `docs/references/python/`, `pwsh/.internal`, `scriptanalyzer`, `claude-hooks`. Check: as per module.
- [ ] Close-out, then this plan is deleted. Check: `grep -rl "The comments of the file that outgrew one line" docs/references` returns
      nothing, and a full `Test-Comments` reports 0 issues.
