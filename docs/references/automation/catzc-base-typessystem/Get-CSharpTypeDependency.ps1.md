---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Get-CSharpTypeDependency.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0a6d03d0ce3c"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.TypesSystem/Get-CSharpTypeDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($cs in ([System.IO.Directory]::EnumerateFiles($typesDir, '*.cs') |...`, written with `#`.

```text
[System.IO] (sorted) instead of Get-ChildItem/Get-Content — ~20ms-per-call cmdlet overhead the raw
.NET enumeration + read avoid
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)).
```

## comment:2

Above `$code = [System.IO.File]::ReadAllText($cs)`, written with `#`.

```text
Strip block comments, line comments, then double- and single-quoted literals, so only real code
tokens are scanned. A heuristic, but reliable here: references are FQN with no 'using' aliasing.
```

## comment:3

Above `$code = [regex]::Replace($code,...`, written with `#`.

```text
Drop the file's own file-scoped namespace declaration ("namespace <module>;"). It names THIS file's
own module, never a cross-module reference, and its token would otherwise mis-map to a shorter
known-module prefix: 'namespace Catzc.Azure.Templates;' has no 'Catzc.Azure.Templates.' continuation,
so it would resolve to the parent module Catzc.Azure and fabricate a false Templates -> Azure edge.
```
