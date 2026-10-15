---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md
    kind: reference
    body_sha: d3165057bf65
    adrs:
      - ADR-AUTO-CACHE#9
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Files/Get-GitTrackedPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place catzc answers `git ls-files -- <paths>`
([ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)): every tracked file at or under the given paths, as a
repo-relative, '/'-separated path ('.' is the whole repository). A path git does not track (new, ignored,
or absent) contributes nothing, so "is this file under version control?" is a membership test on the
result. A tracked file deleted from the working tree is still listed — it is still in the index.

No git process runs: plain `git ls-files` is exactly the index's entry list, so the index file
(Get-GitIndexPath) is read in-process ([Catzc.Base.Git.GitIndex]). The parsed index is cached per index
path, keyed on the SHA-256 of its bytes — the key is recomputed from the file on every call, so a
`git add`/commit/checkout mid-session re-keys it and the answer always matches the index on disk.
```

## comment:2

Section `.PARAMETER ExecutableOnly` of the comment-based help.

```text
Return only the tracked files stored executable (git mode 100755) — the bit bash needs to run a script
directly. Read from the same index, in the same order and form.
```

## comment:3

Above `$script:gitIndexCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:4

Above `$content = [System.IO.File]::ReadAllBytes($indexPath)`.

```text
The key is the index's content, not the session: the index changes mid-session (a commit, a `git add`),
so a cached listing is reused only while the bytes on disk are identical
([ADR-AUTO-CACHE#9](/docs/adr/automation/caching.md#rule-adr-auto-cache9)).
```
