---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md
    kind: comment-page
    body_sha: ea61ffd95741
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Tooling.Core/private/Assert-ToolVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$script:toolVersionCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:5

Above `$accepted = [System.Collections.Generic.List[string]]::new()`.

```text
Accepted prefixes: always the locked version; on a devbox (non-pipeline) also the optional devbox_version
lever from tools.yml. A pipeline enforces the locked version alone.
```
