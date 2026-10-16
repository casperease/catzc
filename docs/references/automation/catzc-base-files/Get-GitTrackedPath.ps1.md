---
catzc:
  immutable:
    with_body_sha: a926a158f7d0
    path: docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md
    folder: docs/references/automation/catzc-base-files
    name: get-git-tracked-path-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CACHE#9
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Files/Get-GitTrackedPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
