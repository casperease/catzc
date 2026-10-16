---
catzc:
  immutable:
    with_body_sha: "269fbf877d06"
    repo_status: locked
    path: docs/references/automation/catzc-base-config/private/Get-ConfigRegistry.ps1.md
    folder: docs/references/automation/catzc-base-config/private
    name: get-config-registry-ps1
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

# automation/Catzc.Base.Config/private/Get-ConfigRegistry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$cached =...`, written with `#`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
