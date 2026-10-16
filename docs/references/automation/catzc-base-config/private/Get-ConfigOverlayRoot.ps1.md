---
catzc:
  immutable:
    with_body_sha: beba738f27a0
    repo_status: locked
    path: docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md
    folder: docs/references/automation/catzc-base-config/private
    name: get-config-overlay-root-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if...`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
