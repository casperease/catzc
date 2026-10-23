---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BASH-SHELLSCRIPTSCHECKED
      - ADR-AUTO-GO-GOCHECKS
---

# Shell scripts and go code each take their languages checks

This article is one rule:
[ADR-AUTO-BASH-SHELLSCRIPTSCHECKED](../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-shellscriptschecked) and
[ADR-AUTO-GO-GOCHECKS](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-gochecks) merged into one. It holds nothing beyond what
those two rules say.

Every shell script the repository tracks, the `.bats` tests, `importer.sh`, every `*.sh` and every `*.zsh`, takes the shell-script checks of
the `Test-ShellScripts` quality gate: LF line endings and the executable bit for a script with a shebang, then an analysis. Go code takes
the repository's checks where a check reads Go: `gofmt` through `Test-Formatting`, `go vet` before every Go test run, and the spelling check
over `*.go`.
