---
catzc:
  immutable:
    with_body_sha: "09c4f4bb90bf"
    repo_status: locked
    path: docs/references/automation/catzc-base-timeouts/types/TimeLimitAttribute.cs.md
    folder: docs/references/automation/catzc-base-timeouts/types
    name: time-limit-attribute-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-ASSERT#1
---

# automation/Catzc.Base.Timeouts/types/TimeLimitAttribute.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A function's own time limit, declared beside its code on the param block:

    function Test-Widget {
        [CmdletBinding()]
        [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 1800)]
        param([int] $TimeoutSeconds = (Get-TimeoutSeconds -Command 'Test-Widget'))

Get-TimeoutSeconds -Command reads it when no config entry overrides it, so a long-running function carries its
limit with its code and config only states what was tuned
([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)). The values are
checked when the attribute is created: whole seconds above zero, the pipeline limit at least the devbox one.
```

## comment:2

Above `public string Budget`, written with `//`.

```text
The work's immutable budget GUID (managed in guids.yml); while timeout-exemptions.yml exempts it, the
exemption's ceiling wins. Empty when the function has no budget.
```
