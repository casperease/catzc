# pwsh/Base.Git/types/GitIndex.cs

The tracked paths of a git index file (`.git/index`), read in-process: what `git ls-files` prints, without launching git.

## Why the bytes are enough

Plain `git ls-files` is exactly the index's entry list, so the index bytes fully determine the answer: `ContentHash` keys a cache on those
bytes, and equal bytes can never yield a stale listing. The reader reads index versions 2 to 4 (v4 prefix-compressed paths included) of a
SHA-1 repository; a split index (the `link` extension) or a sparse index (directory entries) is rejected loudly rather than read wrong
([ADR-AUTO-TRACKED](../../../../drs/automation/tracked-files-from-the-index.md)).

## The members

- `Paths` are the tracked paths, repo-relative and `/`-separated, in index (byte-sorted) order; an unmerged path, which the index holds once
  per conflict stage, is listed once.
- `ExecutablePaths` are the tracked paths stored executable (git mode 100755), in the same order and form as `Paths`: what `git ls-files -s`
  lists with mode 100755.
- `Under` gives the tracked paths at or under the given literal, repo-relative paths (`.` is the whole repository): the
  `git ls-files -- <paths>` answer, in index order, each path once.

## The trailer

The trailer is the SHA-1 of everything before it, or all zeros when git skips it (`index.skipHash`). A mismatch is a corrupt file or a
SHA-256 repository, whose 32-byte object ids this reader does not parse.
