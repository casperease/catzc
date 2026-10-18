# pwsh/Catzc.Base.Files/Get-GitTrackedPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the subset of the given repository paths that git tracks.

### description

The one place catzc answers `git ls-files -- <paths>` ([ADR-AUTO-TRACKED](../../../adr/automation/tracked-files-from-the-index.md)): every
tracked file at or under the given paths, as a repo-relative, '/'-separated path ('.' is the whole repository). A path git does not track
(new, ignored, or absent) contributes nothing, so "is this file under version control?" is a membership test on the result. A tracked file
deleted from the working tree is still listed — it is still in the index.

No git process runs: plain `git ls-files` is exactly the index's entry list, so the index file (Get-GitIndexPath) is read in-process
(`[Catzc.Base.Git.GitIndex]`). The parsed index is cached per index path, keyed on the SHA-256 of its bytes — the key is recomputed from the
file on every call, so a `git add`/commit/checkout mid-session re-keys it and the answer always matches the index on disk.

### parameter `Path`

The literal repository-relative, '/'-separated paths (files or folders) to look up; '.' for all.

### parameter `ExecutableOnly`

Return only the tracked files stored executable (git mode 100755) — the bit bash needs to run a script directly. Read from the same index,
in the same order and form.

### outputs

`[string]`

### example 1

```powershell
Get-GitTrackedPath 'pwsh/Catzc.Base.Docs/configs/glossary.yml'
```

### example 2

```powershell
Get-GitTrackedPath 'pwsh/Catzc.Base.Docs/configs', 'docs/adr'
```

### example 3

```powershell
Get-GitTrackedPath '.'
```

### example 4

```powershell
Get-GitTrackedPath 'pwsh' -ExecutableOnly   # the tracked files under pwsh/ stored as 100755
```

## comment:1

Above `$script:gitIndexCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$content = [System.IO.File]::ReadAllBytes($indexPath)`, written with `#`.

```text
The key is the index's content, not the session: the index changes mid-session (a commit, a `git add`),
so a cached listing is reused only while the bytes on disk are identical
([ADR-AUTO-CACHE#9](/docs/adr/automation/caching.md#rule-adr-auto-cache9)).
```
