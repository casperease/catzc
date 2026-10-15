---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/tests/types/GitHistoryScan.Tests.ps1.md
    kind: test-asset
    body_sha: "4511ab32356a"
---

# automation/Catzc.Base.Git/tests/types/GitHistoryScan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function script:New-ObjectId {`.

```text
Builds a `git cat-file --batch` stream by hand. Object ids are made up (any 40 hex digits): the scan
indexes the stream by id and never re-hashes content.
```

## comment:2

Above `$ids = @{}`.

```text
A two-commit history:
  commit 1 (root): widget.txt (clean), gadget/ (a tree holding notes.txt with the token)
  commit 2: adds the token to its message, a binary blob holding the token, a vendored copy of the token
  blob, and a path named after the token.
```
