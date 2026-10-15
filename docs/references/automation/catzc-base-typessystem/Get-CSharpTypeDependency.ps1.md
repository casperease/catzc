---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
    kind: comment-page
    body_sha: "43cb30895775"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `foreach ($cs in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') |...`.

```text
[System.IO] (sorted) instead of Get-ChildItem/Get-Content — ~20ms-per-call cmdlet overhead the raw
.NET enumeration + read avoid
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:6

Above `$code = [System.IO.File]::ReadAllText($cs)`.

```text
Strip block comments, line comments, then double- and single-quoted literals, so only real code
tokens are scanned. A heuristic, but reliable here: references are FQN with no 'using' aliasing.
```

## comment:7

Above `$code = [regex]::Replace($code,...`.

```text
Drop the file's own file-scoped namespace declaration ("namespace <module>;"). It names THIS file's
own module, never a cross-module reference, and its token would otherwise mis-map to a shorter
known-module prefix: 'namespace Catzc.Azure.Templates;' has no 'Catzc.Azure.Templates.' continuation,
so it would resolve to the parent module Catzc.Azure and fabricate a false Templates -> Azure edge.
```
