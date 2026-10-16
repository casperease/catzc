---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "80c23bbed3e5"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Globs/Test-GlobSetProtection.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:protectedGlobSets = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entries
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$identity = if ($Hash) {`, written with `#`.

```text
NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently
overwrite the $Hash parameter.
```
