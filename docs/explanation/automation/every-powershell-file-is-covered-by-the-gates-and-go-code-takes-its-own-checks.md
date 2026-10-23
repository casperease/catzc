---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-FORMAT-EVERYFILECOVERED
      - ADR-AUTO-GO-GOCHECKS
---

# Every powershell file is covered by the gates and go code takes its own checks

This article is one rule:
[ADR-PWSH-FORMAT-EVERYFILECOVERED](../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-everyfilecovered) and
[ADR-AUTO-GO-GOCHECKS](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-gochecks) merged into one. It holds nothing beyond what
those two rules say.

Every authored PowerShell file the repository ships or runs is covered by the formatting and analysis quality gates, including the root
`importer.ps1` and authored `.psd1` config, resolved through one shared selector so no file escapes by living outside the module tree. Go
code takes the repository's checks where a check reads Go: `gofmt` through `Test-Formatting`, `go vet` before every Go test run, and the
spelling check over `*.go`.
