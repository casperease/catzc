---
catzc:
  immutable:
    with_body_sha: c1e0f8f84b93
    path: docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md
    folder: docs/references/automation/catzc-base-docs/private
    name: get-cats-rule-enforcers-ps1
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

# automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$cached =...`, written with `#`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$isCommand = { param($node) $node -is...`, written with `#`.

```text
Test enforcers — the `-Tag` citations of Describe/Context/It, read by AST so a citation-shaped fixture
string is never mistaken for a real tag.
```
