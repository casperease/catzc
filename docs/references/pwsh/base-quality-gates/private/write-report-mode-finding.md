# pwsh/Base.QualityGates/private/Write-ReportModeFinding.ps1

Prints the findings of a source check in report mode: every finding, then its count, and never a failure. It is the one way a gate shows a
check whose config sets `mode: report`.

## help

### synopsis

Prints the findings of a source check in report mode: every finding, then its count, and never a failure.

### description

The one way a gate shows a check whose config sets mode: report (Catzc.Base.QualityGates.SourceCheck,
[PDR-CONFIG-EXCEPTIONISCONFIGENTRY](../../../../drs/principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)): the
check's findings are its work list, printed with the check's name so a reader can tell them from the gate's issues, and they are never
passed to Write-QualityGateReport as issues. Nothing is printed when the check found nothing.

### parameter `Check`

The check's name as its config spells it ('string_citations', 'engine_set').

### parameter `Finding`

The check's findings, one '`<file>:<line>…`' line each.

### example 1

```powershell
Write-ReportModeFinding -Check engine_set -Finding $engineSetFindings
```
