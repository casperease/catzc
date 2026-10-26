# pwsh/Base.Objects/types/PSTypeAliasAttribute.cs

The attribute that declares a PowerShell type-accelerator alias for the type it decorates. The type loader (`Import-CSharpTypes`) reads
these after loading the combined assembly and registers each `Name` with `System.Management.Automation.TypeAccelerators`, so `[Name]`
resolves to the type. For example, `[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]` on an enum makes `[Catzc.Module.Depm]::Puml`
work.

## Where the alias lives

The alias literal lives in the C# source, so it greps straight back to the declaring `types/*.cs`: a workspace search for the alias lands on
this attribute. `AllowMultiple` lets a type publish more than one alias. The attribute is BCL only and declares its module namespace,
file-scoped, per the type loader.

## Name

The accelerator name to register, such as `Catzc.Module.Depm`. It is namespaced with a `Catzc.` prefix so it never reclaims another module's
accelerator.
