---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: feature
  targets: [docs/references/pwsh, pwsh]
---

# Comment insights: one terse line back at each place a long comment left

The comment pages keep every long comment verbatim, one `## comment:N` section each, naming the code line it sat above (`Export-Comments`;
`Build-CommentView` shows them in place). The code is left with nothing there. The user wants a terse, precise one-line insight at that
place: on a declaration or first code line, one line that says something useful about it; on a parameter, a small tidbit. Never prose.

## Decided (the user, 2026-10-25)

- `Export-Comments` and the comments step of `Format-Code` stay as they are. A distilled insight is one line, below the export threshold
  (`min_lines: 2` in `comments.yml`), so it is never scraped again.
- The one-liner is the insight; the page's sections are later folded into a reference article (plan-comment-articles.md).
- A parameter gets its tidbit on the parameter; a section about the whole function gets its line on the declaration or first code line.
- An insight line never sits directly on another comment line: two adjacent lines reach the export threshold and `Format-Code` moves both to
  the page (catzc-fa, 2026-10-25).
- A line is not compulsory: a section that only summarises what a test file covers leaves no line, since a list of cases is no clue.

## Open steps

- [ ] The last leftovers: every other module has its lines. Left are the Base.QualityGates FileMeta files in catzc-68's staging
      (`Format-FileMeta`, `file-meta.yml`, `Get-FileMetaScope`, `Get-ImprintStepFile`, `Get-RelativeEdgesFileMetaFact`,
      `Invoke-FileMetaEngine`, `FileMetaConfig.cs` and their tests), once that staging lands, and 10 sections in Base.Docs and Base.CodeMeta
      (`Get-CommentPage`, `comment-pages.yml`, `CommentPageMap.cs`, `Get-Glossary`, `agents.yml`, `readme.yml`, `Test-Glossary.Tests` and
      three more) found by the 2026-10-26 audit. Check: a page section whose code line has no one-line comment above it is left only where
      the rules allow it, `Test-Comments -Path pwsh` reports 0, and the touched files' tests pass one file at a time.
