---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/New-Importer.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "020d591aa738"
---

# automation/Catzc.Base.ModuleSystem/tests/New-Importer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {` (occurrence 2), written with `#`.

```text
The committed importer.ps1 is generated from the Invoke-Importer overlay. These guard the two ways it can
drift: its parameter set must equal the overlay's (signature = parameter set, no tagging), and its whole
content below its generated-file head must equal New-Importer's output. To fix a failure, run Build-RootConfig and commit importer.ps1.
```

## comment:2

Above `function script:Get-ParamSignature {`, written with `#`.

```text
The '<name> [<type-as-written>]' list of a param block — the script's own (FunctionName $null) or a
named function's within a module file. AST parse, so the overlay need not be loaded.
```
