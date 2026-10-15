---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/Test-GitHistoryClean.ps1.md
    kind: comment-page
    body_sha: b5ad3e1c55b8
    adrs: []
---

# automation/Catzc.Tooling.Github/Test-GitHistoryClean.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The reusable verification primitive behind every purge: to prove a secret is
gone, it is not enough to scan the working tree — the token can survive in an
old blob, a renamed path, or a commit message. This scans the whole history
reachable from a ref for all three and returns a structured result.

The scan is one pass (Catzc.Base.Git.GitHistoryScan): git streams its objects
once (`git cat-file --batch-all-objects --batch`), and every commit message,
every path and every distinct file content the ref reaches is read exactly
once — never once per revision that contains it.

Scan the local ref (default HEAD) that is pushed; the purge functions then
prove from the remote's advertised refs that it holds that same commit,
so the scan covers what actually landed. Never scan
a ref whose upstream tracking still points at un-purged history (e.g. an
un-updated origin/*) — a stale tracking ref false-alarms.

Read-only: it never mutates the repository.
```

## comment:2

Section `.PARAMETER Token` of the comment-based help.

```text
The token to hunt for (e.g. a secret, or a project name being erased).
Matched as a literal substring, ignoring ASCII case, across every surface.
A binary file (a NUL byte in its first 8000 bytes) is skipped, as
`git grep -I` skips it.
```

## comment:3

Section `.PARAMETER Ref` of the comment-based help.

```text
The ref whose reachable history is scanned. Defaults to HEAD. Pass a branch
name, a SHA, or --all to sweep every ref (only meaningful in a clone with no
stale tracking ref to false-alarm).
```

## comment:4

Section `.PARAMETER ExcludePath` of the comment-based help.

```text
Repo-relative path prefixes to ignore on every surface — vendored,
third-party trees that legitimately contain the token. Defaults to the
vendor directory. A file content is ignored only when every path it
appears under is excluded.
```
