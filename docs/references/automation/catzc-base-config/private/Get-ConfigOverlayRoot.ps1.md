---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md
    kind: comment-page
    body_sha: f757a2fcc06e
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Get-Config sits on the hot path, so the overlay root (Get-CatzcOverlayRoot, which derives the run mode from the
two roots) is worked out once per RepositoryRoot / CatzcModulesRoot pair and kept for the session
([ADR-PWSH-CACHE](/docs/adr/pwsh/script-scope-caching.md)). A change of either anchor — a new working root, or
a switch of run mode — is a new key, so the answer never outlives the roots it came from.
```

## comment:2

Above `if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayA...`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
