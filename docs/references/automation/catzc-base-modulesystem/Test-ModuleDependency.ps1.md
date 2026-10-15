---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Test-ModuleDependency.ps1.md
    kind: comment-page
    body_sha: "3bb8e299b3e5"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Compares the real module-to-module edges — PowerShell function calls and cross-module C# type
references — against the allow-list declared in configs/dependencies.yml (see
Get-ModuleDependencyViolations for the rules), collects every violation, and ends with
Write-QualityGateReport ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)):
the report lands in out/test-module-dependency/, and the gate throws once listing every violation (or
returns the result with -PassThru).

A structurally invalid config throws at load time (via Get-ModuleDependencyConfig) before any
conformance check runs — a malformed config is a bug to fix, not a conformance result.

Must run post-import so the actual call graph covers all loaded modules.
```
