---
catzc:
  immutable:
    with_body_sha: "4f587cd19f71"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/Test-AdrRegistry.ps1.md
    folder: docs/references/automation/catzc-base-docs
    name: test-adr-registry-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PRIN-CONFIG#1
---

# automation/Catzc.Base.Docs/Test-AdrRegistry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$configured = @(`, written with `#`.

```text
The configured checks: one mode setting each, the same handling for both
([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
```
