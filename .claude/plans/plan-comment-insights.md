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
- The page section stays: the one-liner is the insight, the page keeps the whole comment.
- A parameter gets its tidbit on the parameter; a section about the whole function gets its line on the declaration or first code line.

## Open steps

- [ ] `pwsh/Catzc.Base.Folders` (the pilot): for each `## comment:N` section on its pages under `docs/references/pwsh/catzc-base-folders/`,
      one line written at the code line the section names, distilled from it, terse and precise. The user reviews the pilot before the
      rollout. Check: `Test-Comments -Path pwsh/Catzc.Base.Folders` reports no long comment and no orphan section, and the module's tests
      pass one file at a time.
- [ ] `pwsh/Catzc.Base.QualityGates/configs/glossary.yml`: the term **algorithmical insight**, bolded in
      ADR-REPO-COMMENTS-CLUESNOTNARRATION, with its defining rule, after catzc-44's link-directions terms land in the same file. Check:
      `Test-Glossary` names no finding for the term, then `Build-Glossary` leaves no diff.
- [ ] The rollout after the user's review: one module per step, in the master's order. Check: per module, `Test-Comments -Path` on it
      reports no long comment and no orphan section, and its tests pass one file at a time.
