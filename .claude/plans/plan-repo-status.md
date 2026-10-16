---
plan:
  status: open
  value: medium
  reviewed: 2026-10-17
  targets:
    [
      automation/Catzc.Base.Files/Get-RepoStatus.ps1,
      automation/Catzc.Base.QualityGates/private/Get-RepoStatusFileMetaFact.ps1,
      automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1,
      docs/adr/repository/file-meta.md,
    ]
catzc:
  immutable:
    with_body_sha: "99ccc1a48522"
    repo_status: clean
    path: ".claude/plans/plan-repo-status.md"
    folder: plans
    name: plan-repo-status
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-REPO-FILEMETA#{7,13}
---

# repo_status: what a file says of its place in git

Every meta block and generated head holds `repo_status` in `immutable`: `locked` for a generated file (edit its source), `clean` for an
authored one. The states only git knows are computed by `Get-RepoStatus` and never stored, since writing them would change them
(ADR-REPO-FILEMETA#13). The key is stamped on the tracked files, so what remains is the follow-up below.

## Open steps

1. **Combine the two halves.** `Get-RepoStatus` returns only the git state (`unset`, `edited`, `staged`, `ready`, `committed`,
   `pushed`). Decide whether it also reads the stored `locked` so a generated file reports `locked`; the answer needs the head readers,
   which sit in a module above `Catzc.Base.Files`, so it may belong to a command in that layer instead of this one.
2. **Pin `comment-page` to the shipped registry.** `Get-RepoStatusFileMetaFact.Tests.ps1` mocks `Get-FileKind`; add an L1 check that every
   class in the `locked_classes` setting of the shipped `file-meta.yml` is a class the file-kinds registry declares.
3. **Real-git test.** `Get-RepoStatus` is covered by mocks only. Add an L2 test against a repository in `TestDrive`, as
   `Get-GitChangedPath` has, covering `edited`, `staged`, `committed` (a local upstream) and `pushed`.
4. **ADR-REPO-FILEMETA#7 and the glossary.** Rule 7 lists the head's facts and does not name `repo_status`; add it with `locked`. Add the
   terms to the glossary sources only if a rule bolds them.

## Open questions

- **Key spelling.** The key is `repo_status` (snake case like `catzc_bundle`), not the `repo-status` first asked for. Confirm.
- **Position.** The key follows `with_body_sha`, and opens a code head, which has no hash. Putting it above the hash would change
  ADR-REPO-FILEMETA#7 and #13 and the Markdown block formatter. Confirm.
- **`ready`.** Treated as tracked, unchanged and no upstream to compare with. Confirm that reading.
