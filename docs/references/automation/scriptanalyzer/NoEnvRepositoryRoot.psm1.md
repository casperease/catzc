---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoEnvRepositoryRoot.psm1.md
    kind: comment-page
    body_sha: "1adb1cfa4bca"
    adrs:
      - ADR-AUTO-NOPWD#6
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/NoEnvRepositoryRoot.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
$env:RepositoryRoot is the importer's hand-off of the working-tree anchor; Get-RepositoryRoot is its one reader, so
where the root comes from can change in one place. This rule flags every read of $env:RepositoryRoot in a module
function file: a .ps1 file directly under automation/<Module>/ (public) or automation/<Module>/private/ (private).
An assignment to it is not a read and is not flagged. Exempt by path, as for Measure-NoScriptRootAnchor:
- tests/, assets/ and any other subfolder of a module;
- dot-prefixed folders under automation/ (.internal, .scriptanalyzer, .vendor);
- files outside automation/;
- Get-RepositoryRoot.ps1 itself, the accessor.
A function whose job is the variable itself carries a SuppressMessageAttribute with its justification.

See ADR: [ADR-AUTO-NOPWD#6](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd6).
```

## comment:2

Above `$isVariable = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
