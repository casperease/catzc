---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Test-GlobSetAffected.ps1.md
    kind: comment-page
    body_sha: e316ca48cff7
    adrs:
      - ADR-FLOW-CD-GLOBS#1
      - ADR-REPO-PROTGLOB#5
    links: []
---

# automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The boolean a deployable unit's pipeline stage checks to stop early ("nothing for us; return") when its
own area of control is untouched by the change. It reflects the context's diff (Get-GlobSetChangeRange,
then Get-ChangedGlobSet) and reports whether the named set is among those touched. Because the range is
resolved from real refs at run time
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)), this check is immune to the
squash-merge and
concurrent-merge staleness a committed marker hash suffers.

Fail-open ([ADR-REPO-PROTGLOB#5](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob5)): when the
reference commit cannot be resolved or the diff cannot be computed —
a shallow clone that cannot reach the base, an unresolved PR target ref, a first commit with no parent —
this returns $true, proceed. A redundant run is safe; a wrong skip is an un-deployed change. It returns
$false ONLY when it has positively confirmed, over a resolvable range, that the set is untouched. An
undeclared name is a programming error, not a runtime ambiguity, so it throws (fail-fast,
[ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md))
rather than silently reporting "not affected" and skipping.
```
