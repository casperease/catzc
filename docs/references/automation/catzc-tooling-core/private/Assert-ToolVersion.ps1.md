---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Assert-ToolVersion.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e252bfb86f50
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Tooling.Core/private/Assert-ToolVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:toolVersionCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$accepted = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Accepted prefixes: always the locked version; on a devbox (non-pipeline) also the optional devbox_version
lever from tools.yml. A pipeline enforces the locked version alone.
```
