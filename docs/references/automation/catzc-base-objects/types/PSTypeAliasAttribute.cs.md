---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/types/PSTypeAliasAttribute.cs.md
    kind: reference
    body_sha: "37d6060ab127"
    adrs: []
---

# automation/Catzc.Base.Objects/types/PSTypeAliasAttribute.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Declares a PowerShell type-accelerator alias for the type it decorates. The type loader
(Import-CSharpTypes) reads these after loading the combined assembly and registers each Name with
System.Management.Automation.TypeAccelerators, so `[Name]` resolves to the type — e.g.
[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")] on an enum makes [Catzc.Module.Depm]::Puml work.

The alias literal lives here in the C# source, so it greps straight back to the declaring types/*.cs (a
workspace search for the alias lands on this attribute). AllowMultiple, so a type may publish more than
one alias. BCL only; declares its module namespace (file-scoped), per the type loader.
```

## comment:2

Above `public string Name { get; }`.

```text
The accelerator name to register, e.g. "Catzc.Module.Depm". Namespaced with a Catzc. prefix so it never
reclaims another module's accelerator.
```
