---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PWD-ROOTTHROUGHACCESSOR
      - ADR-PWSH-ENV-BOOTSTRAPANCHORS
---

# The working root is read through one accessor and the bootstrap anchors are set once

This article is one rule:
[ADR-PWSH-PWD-ROOTTHROUGHACCESSOR](../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-rootthroughaccessor) and
[ADR-PWSH-ENV-BOOTSTRAPANCHORS](../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-bootstrapanchors) merged into
one. It holds nothing beyond what those two rules say.

A module function file reads the working root through `Get-RepositoryRoot`, never `$env:RepositoryRoot`; a function whose job is the
variable itself, such as `Test-InIsolation`, carries a justified suppression. The bootstrap anchors are `$env:RepositoryRoot` (the working
root) and `$env:CatzcModulesRoot` (the code root), and the importer entry sets them once, `importer.ps1` in source mode and the build's
`Import-Catzc.ps1` in build mode.
