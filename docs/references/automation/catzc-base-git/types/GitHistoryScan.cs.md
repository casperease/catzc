---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitHistoryScan.cs.md
    kind: comment-page
    body_sha: "1c41a7f8825d"
    adrs: []
    links: []
---

# automation/Catzc.Base.Git/types/GitHistoryScan.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A token hunt over a git history in one pass: every commit message, every path and every distinct file content
reachable from a set of root objects, each read exactly once. The input is the byte stream of
`git cat-file --batch-all-objects --batch --unordered` — git's own C code decompresses the objects; this type
indexes them, walks what the roots reach, and searches. Scanning each distinct blob once (rather than once per
revision that contains it, as `git grep <revs>` does) is what makes the scan fast
([ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)).

Matching mirrors the CLI scan it replaces: the token is a literal, matched ignoring ASCII case (other characters
match exactly); a blob with a NUL byte in its first 8000 bytes is binary and skipped, as `git grep -I` skips it;
a blob or path whose every path lies under an excluded prefix is ignored.
```

## comment:2

Above `public string[] Blobs { get; }`.

```text
Content hits, one per matching line of each distinct blob: `<blob>:<path>:<line>`, where path is the
blob's first non-excluded path in ordinal order.
```
