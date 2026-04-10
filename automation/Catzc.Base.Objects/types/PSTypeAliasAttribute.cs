// Declares a PowerShell type-accelerator alias for the type it decorates. The type loader
// (Import-CSharpTypes) reads these after loading the combined assembly and registers each Name with
// System.Management.Automation.TypeAccelerators, so `[Name]` resolves to the type — e.g.
// [Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")] on an enum makes [Catzc.Module.Depm]::Puml work.
//
// The alias literal lives here in the C# source, so it greps straight back to the declaring types/*.cs (a
// workspace search for the alias lands on this attribute). AllowMultiple, so a type may publish more than
// one alias. BCL only; declares its module namespace (file-scoped), per the type loader.

using System;

namespace Catzc.Base.Objects;

[AttributeUsage(
    AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Enum | AttributeTargets.Interface,
    AllowMultiple = true,
    Inherited = false)]
public sealed class PSTypeAliasAttribute : Attribute
{
    // The accelerator name to register, e.g. "Catzc.Module.Depm". Namespaced with a Catzc. prefix so it never
    // reclaims another module's accelerator.
    public string Name { get; }

    public PSTypeAliasAttribute(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("a PSTypeAlias name is required");
        }
        Name = name;
    }
}
