---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitIndex.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "350e468ab517"
---

# automation/Catzc.Base.Git/types/GitIndex.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The tracked paths of a git index file (.git/index), read in-process: what `git ls-files` prints, without
launching git. Plain `git ls-files` is exactly the index's entry list, so the index bytes fully determine
the answer — ContentHash keys a cache on those bytes, and equal bytes can never yield a stale listing.
Reads index versions 2-4 (v4 prefix-compressed paths included) of a SHA-1 repository; a split index
(the 'link' extension) or a sparse index (directory entries) is rejected loudly rather than read wrong
([ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)).
```

## comment:2

Above `public string[] Paths { get; }`, written with `//`.

```text
The tracked paths, repo-relative and '/'-separated, in index (byte-sorted) order; an unmerged path,
which the index holds once per conflict stage, is listed once.
```

## comment:3

Above `public string[] ExecutablePaths { get; }`, written with `//`.

```text
The tracked paths stored executable (git mode 100755), in the same order and form as Paths — what
`git ls-files -s` lists with mode 100755.
```

## comment:4

Above `public string[] Under(IEnumerable<string> pathspecs) => Select(Paths,...`, written with `//`.

```text
The tracked paths at or under the given literal, repo-relative paths ('.' is the whole repository) —
the `git ls-files -- <paths>` answer, in index order, each path once.
```

## comment:5

Above `var bodyLength = content.Length - HashLength;`, written with `//`.

```text
The trailer is the SHA-1 of everything before it — all zeros when git skips it (index.skipHash). A
mismatch is a corrupt file or a SHA-256 repository, whose 32-byte object ids this reader does not parse.
```
