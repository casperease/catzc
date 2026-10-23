---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-PWD-ROOTTHROUGHACCESSOR
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# The working root is read through get repositoryroot and the build is immutable

This article is one rule:
[ADR-PWSH-PWD-ROOTTHROUGHACCESSOR](../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-rootthroughaccessor) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A module function file reads the working root through `Get-RepositoryRoot`, never `$env:RepositoryRoot`; a function whose job is the
variable itself, such as `Test-InIsolation`, which swaps it for a sandbox and restores it, carries a justified suppression. The build those
functions ship in is immutable and content-addressed, the same commit yielding a byte-identical build on any machine.
