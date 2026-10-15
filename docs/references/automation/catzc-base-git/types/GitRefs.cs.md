---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/types/GitRefs.cs.md
    kind: comment-page
    body_sha: "9fd69b54ce57"
---

# automation/Catzc.Base.Git/types/GitRefs.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Git's refs, read in-process: where a checkout's git directory is, which commit HEAD, a branch or a tag names, and
the branch HEAD is on — what `git rev-parse` answers, without starting git. Refs are small text files (loose refs,
`packed-refs`), so reading them directly is exact and cheap. A layout this reader cannot read correctly — the
reftable ref store, or a loose annotated tag, whose commit sits inside a tag object — is rejected loudly rather
than read wrong ([ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)).
```

## comment:2

Above `public static string GitDirectory(string checkoutRoot)`.

```text
The git directory of a checkout: `<root>/.git` when it is a directory, or the target of a `gitdir: <path>`
pointer file (a linked worktree or a submodule), resolved against the root when relative.
```

## comment:3

Above `public static string CommonDirectory(string gitDirectory)`.

```text
The directory shared refs live in: the `commondir` a linked worktree's git directory names, else the git
directory itself.
```

## comment:4

Above `public static string ResolveCommit(string gitDirectory, string name)`.

```text
The full object id a name resolves to: a full id, HEAD, a full ref (`refs/...`), or a short name looked up as
git does — refs/<name>, refs/tags/<name>, refs/heads/<name>, refs/remotes/<name>, refs/remotes/<name>/HEAD.
An annotated tag resolves to the commit it points at. Throws when nothing matches.
```

## comment:5

Above `private static bool IsAnnotatedTagObject(string gitDirectory, string id)`.

```text
A loose tag ref can name a commit (a lightweight tag) or a tag object; the loose object's header says which. A
packed object cannot be told apart without unpacking, so it counts as annotated (loud, never wrong).
```
