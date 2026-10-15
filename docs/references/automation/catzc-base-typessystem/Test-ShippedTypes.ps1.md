---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Test-ShippedTypes.ps1.md
    kind: reference
    body_sha: f600c9574fd7
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the shipped
C# types: each <module>/types/<Name>.cs under the loaded code root (Get-CatzcModulesRoot — the source tree or a built
package) declares the type <module>.<Name>, so after import that full name must resolve. A file that compiles to a
differently named type, or a module whose types never loaded, is an issue. So is a concrete class that still
renders as its full name in pwsh ("$x", [string]$x): it must override ToString(), normally by delegating to
Catzc.Base.Objects.ConsoleText (Test-ConsoleReadyType). The formatting of the files (file-scoped namespaces) is
Test-Formatting's.
```
