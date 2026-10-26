# pwsh/Base.Git/types/GitRefs.cs

Git's refs, read in-process: where a checkout's git directory is, which commit HEAD, a branch or a tag names, and the branch HEAD is on. It
answers what `git rev-parse` answers, without starting git.

## Why direct reading is safe

Refs are small text files (loose refs, `packed-refs`), so reading them directly is exact and cheap. A layout this reader cannot read
correctly, the reftable ref store or a loose annotated tag whose commit sits inside a tag object, is rejected loudly rather than read wrong
([ADR-AUTO-TRACKED](../../../../drs/automation/tracked-files-from-the-index.md)).

## The members

- `GitDirectory` is the git directory of a checkout: `<root>/.git` when it is a directory, or the target of a `gitdir: <path>` pointer file (a
  linked worktree or a submodule), resolved against the root when relative.
- `CommonDirectory` is the directory shared refs live in: the `commondir` a linked worktree's git directory names, else the git directory
  itself.
- `ResolveCommit` is the full object id a name resolves to: a full id, `HEAD`, a full ref (`refs/...`), or a short name looked up as git does
  (`refs/<name>`, `refs/tags/<name>`, `refs/heads/<name>`, `refs/remotes/<name>`, `refs/remotes/<name>/HEAD`). An annotated tag resolves to
  the commit it points at. It throws when nothing matches.

## Annotated tags

A loose tag ref can name a commit (a lightweight tag) or a tag object; the loose object's header says which. A packed object cannot be told
apart without unpacking, so it counts as annotated: loud, never wrong.
