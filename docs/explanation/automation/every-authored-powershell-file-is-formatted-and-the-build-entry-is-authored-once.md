---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-FORMAT-EVERYFILECOVERED
      - ADR-PWSH-ENGINE-BUILDENTRY
---

# Every authored powershell file is formatted and the build entry is authored once

This article is one rule:
[ADR-PWSH-FORMAT-EVERYFILECOVERED](../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-everyfilecovered) and
[ADR-PWSH-ENGINE-BUILDENTRY](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-buildentry) merged into one. It holds nothing
beyond what those two rules say.

Every authored PowerShell file the repository ships or runs is covered by the formatting and analysis quality gates, including the root
`importer.ps1` and authored `.psd1` config, resolved through one shared selector so no file escapes by living outside the module tree. The
build's entry is likewise authored once, `Import-Catzc.ps1` at `pwsh/.internal/assets/`, and copied verbatim into every build.
