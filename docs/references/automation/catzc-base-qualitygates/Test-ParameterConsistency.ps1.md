---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ParameterConsistency.ps1.md
    kind: reference
    body_sha: "8b368bcf9622"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A caller learns a parameter once — `-Path` takes paths, `-TimeoutSeconds` takes whole seconds — so the same name
carries the same type in every public function ([ADR-PWSH-PARAM](/docs/adr/pwsh/parameter-design.md),
[ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). Reads every tracked public function
file (automation/<Module>/<Name>.ps1) and reports each parameter name whose declarations disagree on their element
type (Get-ParameterTypeConflict: [string] and [string[]] agree; untyped, [object] and [psobject] never conflict).

A name that genuinely means different things in different functions is listed in parameter-consistency.yml (`exempt`)
with the reason; an exempt name is not reported, and an exempt name that no longer conflicts is reported, so the list
holds only what is real. Ends with Write-QualityGateReport: the report lands in out/test-parameter-consistency/, and
the gate throws once listing every issue (or returns the result with -PassThru). Needs the source tree
(Assert-SourceTree).
```
