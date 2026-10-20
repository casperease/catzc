# ADR: Tracked files are read from the git index, in-process, through one seam

## Rules: ADR-AUTO-TRACKED

### Rule ADR-AUTO-TRACKED-ONESEAM

One seam answers "which files does git track": `Get-GitTrackedPath`. No other code launches `git ls-files` to list tracked files or to test
whether a path is tracked. A domain function that names a tracked universe of its own (`Get-TrackedFile`, the globset matching universe;
`Get-GuidScanFiles`, the managed-GUID scan) delegates to the seam and adds only its own filtering.

- [One question, one answer](#one-question-one-answer)

### Rule ADR-AUTO-TRACKED-INPROCESSINDEX

The seam reads the git index file in-process (the native type `Catzc.Base.Files.GitIndex`) and launches no process. Code that scopes itself
by tracked files is therefore pure file reading, which a logic test at L0 or L1 may run (ADR-AUTO-TEST-PROCESSTRIPWIRE).

- [Plain git ls-files is the index](#plain-git-ls-files-is-the-index)
- [Why not launch git](#why-not-launch-git)

### Rule ADR-AUTO-TRACKED-SAMEASLSFILES

The answer is exactly what plain `git ls-files` prints: every index entry, repo-relative and `/`-separated, in index order, with non-ASCII
paths literal. A file deleted from the working tree but still in the index is listed; so are skip-worktree and intent-to-add entries. An
unmerged path, which the index holds once per conflict stage, is listed once.

- [Plain git ls-files is the index](#plain-git-ls-files-is-the-index)

### Rule ADR-AUTO-TRACKED-LITERALRELATIVEPATHS

Paths passed to the seam are literal and repository-relative: a path selects itself and everything under it, `.` selects the whole
repository, and a sibling that only shares a name prefix is never selected. A rooted path, or one that climbs out of the repository, throws.
There are no wildcards.

- [One question, one answer](#one-question-one-answer)

### Rule ADR-AUTO-TRACKED-UNREADABLEINDEXREFUSED

An index the reader cannot read correctly is refused with an error that names the remedy, never answered with a partial list: a split index,
a sparse index, an index version outside 2–4, and a checksum mismatch (a corrupt file, or a repository using the SHA-256 object format).

- [Refuse rather than guess](#refuse-rather-than-guess)

### Rule ADR-AUTO-TRACKED-CACHEDBYINDEXHASH

The parsed index is cached under the SHA-256 of the index file's bytes, recomputed on every call (ADR-AUTO-CACHE-SESSIONCHANGEDGITSTATE).
The key is computed by the seam, not taken from the checksum git writes at the end of the file, because git writes that checksum as zeros
under `index.skipHash`.

- [Following the index](#following-the-index)

### Rule ADR-AUTO-TRACKED-READERTESTEDONBUILTBYTES

The reader is tested at L0 against index bytes the test builds itself, covering every shape it reads and every shape it refuses; one L2 test
pins it to real `git ls-files` on the repository's own index, for the whole repository and for a pathspec.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-TRACKED-OTHERQUESTIONSTOGIT

Questions the index cannot answer stay with real git: which untracked files are not ignored (`git ls-files --others --exclude-standard`),
whether a path is ignored (`git check-ignore`), and what `.gitattributes` says about a path (`git check-attr`, `git ls-files --eol`). They
are real process launches, so a test that runs one is L2.

- [What the index cannot answer](#what-the-index-cannot-answer)

### Rule ADR-AUTO-TRACKED-INPROCESSREFS

Git's refs are read in-process too, through the native type `Catzc.Base.Git.GitRefs`: a checkout's git directory (following a `gitdir:`
pointer and a linked worktree's `commondir`), the index path, the commit `HEAD`, a branch or a tag names, and the branch `HEAD` is on. No
code launches `git rev-parse` for those. A revision expression (`HEAD~3`, `--all`) stays with git. A ref store the reader cannot read
correctly, a reftable or a loose annotated tag, is refused by name (ADR-AUTO-TRACKED-UNREADABLEINDEXREFUSED).

- [Small formats in-process, objects through one pass](#small-formats-in-process-objects-through-one-pass)

### Rule ADR-AUTO-TRACKED-ONEPASSHISTORYSCAN

A scan over a history reads every object once, from one `git cat-file --batch-all-objects --batch` stream, through the native type
`Catzc.Base.Git.GitHistoryScan`. It never reads an object once per revision that contains it, as `git grep <revisions>` or a per-commit loop
does. The stream is git's own decompression: catzc carries no reader of git's compressed object store.

- [Small formats in-process, objects through one pass](#small-formats-in-process-objects-through-one-pass)

### Rule ADR-AUTO-TRACKED-WRITESTHROUGHCLI

Git is written through the git CLI (`clone`, `push`, `commit`, `remote set-url`) via `Invoke-Executable`, inside its time limit
(ADR-AUTO-FAILFAST-BOUNDEVERYWAIT). Reading in-process never extends to writing a repository.

- [Small formats in-process, objects through one pass](#small-formats-in-process-objects-through-one-pass)

## Context

Many parts of the platform set the scope of their work by the files git tracks: the globsets select from them, the managed-GUID scan reads
them ([managed-guids](managed-guids.md)), the Markdown title and link quality gates check them, and the glossary checks read their prose.
"Tracked" is the repository as committed and staged — not build residue, not a scratch file — and that is the set every one of these checks
means.

### One question, one answer

When each caller asks git on its own, each one also quotes paths, splits output, drops blank lines, and decides how a folder path matches,
and small differences between those copies become different answers to the same question. One seam gives one answer and one place to test
it; the domain functions that need a named universe wrap the seam and keep only what is genuinely theirs (an exclusion list, a file-type
filter). Literal paths keep the seam's contract small: the callers pass folders and files they already know, and a pattern language would
only add a second way to say the same thing.

### Plain git ls-files is the index

`git ls-files` with no options prints the entries of the index file, `.git/index` (or the index of a linked worktree, found through the
`gitdir:` pointer in its `.git` file). The index is a documented binary format: a `DIRC` header, one entry per path in byte-sorted order,
optional extensions, and a trailing checksum. Reading it directly gives the same list git prints, because it is the same data.

### Why not launch git

Launching git costs a process start on every call, and the tracked set is asked for many times in one run. A real process is also exactly
what a logic test may not do: the L0/L1 tripwire (ADR-AUTO-TEST-PROCESSTRIPWIRE) blocks it, so a gate that scopes itself through a launched
`git ls-files` must be mocked at the git call or run at L2, even when all it does is read files. Reading the index in-process removes both
costs: the call is a file read, and the gates that use it run as ordinary L1 integrity tests on the real repository.

### Following the index

`The answer follows the index on disk`

The tracked set changes while a session runs: a commit, a `git add`, or a parallel session's commit rewrites the index. So the seam cannot
keep a listing for the session's lifetime, which is the default for filesystem-derived information
([caching](caching.md#rule-adr-auto-cache-importerinvalidates)). It hashes the index file on every call — cheap next to parsing it — and
parses again only when the hash differs. Equal bytes give an equal answer, so the cached listing can never be stale
(ADR-AUTO-CACHE-SESSIONCHANGEDGITSTATE).

### Refuse rather than guess

Some index shapes do not hold the full list in the file: a split index keeps most entries in a shared file, and a sparse index replaces a
directory's entries with one directory entry. A repository using the SHA-256 object format stores longer object ids, so a SHA-1 reading of
its entries lands on the wrong bytes. Answering from any of these would silently drop or invent files, and every gate built on the answer
would check the wrong set. The reader verifies the checksum and refuses these shapes with the command that turns them off.

### What the index cannot answer

The index records what is tracked and nothing about files outside it. Whether an untracked file is ignored depends on `.gitignore` files,
`.git/info/exclude`, and global excludes; what a path's attributes are depends on `.gitattributes` files at every level. Re-implementing
those rules would be a second, drifting copy of git, so those questions stay with git itself — and a test that asks them is an L2 test.

### Small formats in-process, objects through one pass

The index is not the only small, documented git format. Refs are text files: `HEAD`, a loose ref per branch, and `packed-refs`. Reading them
costs a file read where `git rev-parse` costs a process start, about 40 ms each, and a test that reads them stays a logic test.

The object store is different. Objects are zlib-compressed and packed as delta chains behind an index, and a reader for that would be a
large second copy of git. It would also be slower to get right than git, which already decompresses every object in a stream. What makes a
history scan slow is reading the same object again for every revision that holds it, not the decompression. Measured on this repository (684
commits, 9,122 distinct file contents), `git grep` over every revision took about 8.1 s, while one `cat-file` pass over every object took
0.64 s. The scan built on that pass, searching each distinct content once, takes about 1.7 s end to end. So the scan takes git's one stream
and does the indexing, walking and searching itself.

Writing is never in-process. A clone, a push or a commit changes state that git owns, and a second writer would be a second copy of git's
consistency rules.

## Decision

`Get-GitTrackedPath` is the one place that answers which files git tracks. It reads the git index in-process, returns exactly what plain
`git ls-files` prints for literal repository-relative paths, caches the parsed index under the hash of the index file's bytes, and refuses
index shapes it cannot read correctly. Questions about untracked, ignored, or attributed files stay with git.

### How this is enforced

- **`Get-GitTrackedPath`** (`Catzc.Base.Files`) — the seam; `Get-GitIndexPath` (private) locates the index of the checkout through
  `GitRefs`.
- **`GitIndex`** (`Catzc.Base.Git/types/GitIndex.cs`) — the reader: index versions 2–4, the checksum check, the refusals, and the
  literal-path selection.
- **`GitIndex.Tests.ps1`** — L0 tests on built index bytes for every read and refused shape.
- **`GitRefs`** (`Catzc.Base.Git/types/GitRefs.cs`) — refs, the git directory and the index path, with L0 tests on a hand-built git
  directory and L2 parity tests against `git rev-parse`.
- **`GitHistoryScan`** (`Catzc.Base.Git/types/GitHistoryScan.cs`) — the one-pass history scan behind `Test-GitHistoryClean`, with L0 tests
  on a hand-built object stream and L2 tests on a real history.
- **`Get-GitTrackedPath.Tests.ps1`** — L0 tests for the seam and its content-keyed cache, and the one L2 test against real `git ls-files`.
- **The L0/L1 tripwire** (ADR-AUTO-TEST-PROCESSTRIPWIRE) — a stray `git ls-files` launched from a logic test fails the run.
- **Code review** — a new `git ls-files` call for tracked membership is rejected in favour of the seam.

## Consequences

- Every gate that scopes itself by tracked files sees the same list, and that list is what `git ls-files` prints for the index on disk at
  the moment of the call.
- Reading the tracked set costs a file read and a hash; on a repository of about 1,600 files that is around a millisecond once the index is
  parsed.
- Gates that only read tracked files run as L1 integrity tests instead of L2.
- A repository with a split or sparse index, or in the SHA-256 object format, gets a clear error from every tracked-file quality gate until
  the feature is turned off; supporting one of them is a change to the reader and its tests.
- Untracked, ignored, and attribute questions keep their git process and their L2 tests.
- Resolving a ref costs a file read, and a full token scan of the history costs one git process instead of one per batch of revisions.
