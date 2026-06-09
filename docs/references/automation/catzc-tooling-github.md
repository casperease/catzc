# Catzc.Tooling.Github

Erases a token — a leaked secret, or a name being scrubbed — from a GitHub repository's entire history and its remote object store, then
proves it is gone. The module exists because an ordinary force-push erases nothing: the old commits become unreachable but stay stored on
the server until GitHub garbage-collects them, so a fetch of a known old SHA keeps resolving. Deleting and recreating the repository is the
only way to destroy those remote objects. It owns that whole workflow — rewrite the local history token-free, assert the irreversible step
is safe, purge and republish on GitHub, and verify the result across every surface a token can hide in (file content, file paths, and commit
messages). It is not a general git or `gh` wrapper; its one job is provable, complete secret erasure, and it drives every external command
through the process boundary in [Catzc.Base.Execution](catzc-base-execution.md).

## Domains

| Domain   | Area      | Name                                                               |
| -------- | --------- | ------------------------------------------------------------------ |
| domain:1 | purge     | [Remote purge and publish](#domain1--remote-purge-and-publish)     |
| domain:2 | rewrite   | [Local history rewrite](#domain2--local-history-rewrite)           |
| domain:3 | preflight | [Purge preflight](#domain3--purge-preflight)                       |
| domain:4 | verify    | [Token-absence verification](#domain4--token-absence-verification) |

### domain:1 — Remote purge and publish

Making a clean local history the remote's sole history and destroying the old object store with it. Two entry points cover the two starting
points: hard-purging a repository that already exists — delete it, recreate it (optionally under a new name), push, and re-scan — and
publishing a clean tree to a brand-new repository that must not already exist. Both are safe by default: they run the preflight and return a
plan, mutating nothing until armed with an explicit confirm-repo value equal to the target. After pushing, each independently mirror-clones
the new remote and re-scans it, so the proof runs against what the server actually stored rather than the local tree.

### domain:2 — Local history rewrite

Producing a local history that no longer contains the token, by one of two routes. The preferred route rebuilds the history from the current
(already-clean) working tree as a fresh, backdated, single-author orphan history: because every synthetic commit is authored from a tree
that no longer holds the token, it appears in no blob, path, or message, so there is nothing left to scrub and no residual objects. The
fallback route scrubs the token in place with git-filter-repo, rewriting blob content and commit messages — second-choice because it leaves
the old commits as unreachable objects until GitHub garbage-collects and cannot reach a token that lives in a file _path_. Both routes are
destructive to local history and expect a `git bundle create --all` backup to exist first.

### domain:3 — Purge preflight

Asserting, up front and fail-fast, every precondition the irreversible remote step depends on, so the destructive path never runs against a
repository it cannot safely purge. The checks: `gh` is installed and authenticated; the token carries the `delete_repo` scope; the caller
owns the repository and it is not itself a fork; it has no forks of its own (a fork keeps the old objects alive elsewhere); the local origin
points at the repository about to be deleted; and a backup bundle exists and passes `git bundle verify`. It mutates nothing — it throws a
specific, actionable error for whichever check fails first.

### domain:4 — Token-absence verification

The read-only primitive behind every purge: proving a token is absent across all three surfaces it can survive in — file content (blobs),
file paths, and commit messages — over a ref's whole reachable history, not just the working tree. It returns a structured result naming any
residual hits so a caller can act on path-name residue a content scrub could not reach. Run it on the local ref before pushing and again on
a fresh `git clone --mirror` of the remote to prove what actually landed; never run it against a ref whose upstream still tracks un-purged
history, which would false-alarm.

## What the module does

The four domains form a single pipeline with the verification primitive threaded through both ends of it. A rewrite produces a token-free
local history; the preflight gates the irreversible move; the purge makes that history the remote's only history and destroys the old
objects with the repository that held them; and verification runs before the push against the local ref and again after it against a mirror
clone, so no step is trusted without independent proof from the server. The rewrite offers two routes because completeness and convenience
trade off: rebuilding from a clean tree leaves nothing to scrub and no residual objects but discards the original commit shape, while an
in-place filter-repo scrub preserves it at the cost of unreachable leftovers and a blind spot on file paths.

Safe-by-default is the through-line across the mutating surfaces. Every destructive entry point runs a dry run and returns a plan unless
explicitly armed with a confirmation value matching its target, and the remote purge keeps the local clone and the verified backup bundle
intact throughout, so any failure after deletion is recoverable from the exact commands it prints. The module holds no state and no config
of its own: it is a thin, ordered set of operations over `git`, `gh`, and git-filter-repo, each invoked through
[Catzc.Base.Execution](catzc-base-execution.md), returning structured results rather than writing to the console.

## Division

The module's public functions, sorted into the domains above.

| Domain                                | Function                  |
| ------------------------------------- | ------------------------- |
| domain:1 — Remote purge and publish   | `Reset-GitHubRepository`  |
|                                       | `Publish-CleanHistory`    |
| domain:2 — Local history rewrite      | `New-SyntheticHistory`    |
|                                       | `Remove-TokenFromHistory` |
| domain:3 — Purge preflight            | `Assert-GitHubPurgeReady` |
| domain:4 — Token-absence verification | `Test-GitHistoryClean`    |
