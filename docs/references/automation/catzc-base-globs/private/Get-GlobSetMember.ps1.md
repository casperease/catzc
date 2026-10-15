---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/private/Get-GlobSetMember.ps1.md
    kind: reference
    body_sha: "3ef796704255"
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---

# automation/Catzc.Base.Globs/private/Get-GlobSetMember.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one definition of "what is IN the package"
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): the matching universe
(`git ls-files`)
intersected with the set's final membership (GlobSet.Matches, last-match-wins), ordinal-sorted. Every
consumer of the member list routes through here — the durable content SHA (Get-GlobSetHash), the public
Get-GlobSetFile — so the scoped list can never drift between the hash and the public file list. A member
may be missing on disk (an unstaged deletion); it is still a member.
```

## comment:2

Section `.PARAMETER TrackedFile` of the comment-based help.

```text
The tracked-file universe (Get-TrackedFile), fetched once by a caller resolving many sets and passed in.
Omitted, it is fetched for this call.
```
