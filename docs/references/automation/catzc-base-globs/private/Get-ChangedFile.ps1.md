---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/private/Get-ChangedFile.ps1.md
    kind: reference
    body_sha: "25cd7959f074"
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---

# automation/Catzc.Base.Globs/private/Get-ChangedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The diff sibling of Get-TrackedFile
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): `git diff --name-only` over
the range, with renames
split into a delete + an add (--no-renames) so BOTH the old and the new path count as changed — a file
moving INTO or OUT OF a globset must re-trigger it (rename correctness, the property vendor content-blind
filters miss). `core.quotepath=off` keeps non-ASCII paths literal; paths come back '/'-separated and
repo-relative, the same universe globsets match against. Unlike a tracked-file member, a changed path may
be a deletion; it is still returned, matched on its path.

A range that spans a commit absent from a shallow CI clone fails in git — a caller in a pipeline must
ensure sufficient fetch depth (fetchDepth: 0); the reference-commit resolver owns that contract.
```

## comment:2

Section `.PARAMETER Range` of the comment-based help.

```text
The git diff range: a merge-base range 'origin/main...HEAD' (a PR's net change since it diverged) or a
commit range 'HEAD^1..HEAD' (what a post-commit push added to main, first-parent of the squash commit).
```
