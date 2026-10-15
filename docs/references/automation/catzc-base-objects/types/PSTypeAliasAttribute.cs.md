---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/types/PSTypeAliasAttribute.cs.md
    kind: comment-page
    body_sha: "79cd3e151b0e"
---

# automation/Catzc.Base.Objects/types/PSTypeAliasAttribute.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

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

Above `public string Name { get; }`, written with `//`.

```text
The accelerator name to register, e.g. "Catzc.Module.Depm". Namespaced with a Catzc. prefix so it never
reclaims another module's accelerator.
```
