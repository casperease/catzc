/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/FunctionCall.cs
    kind: csharp-type
    module: Catzc.Base.ModuleSystem
    adrs: []
---
*/

// A call with no static name, such as a call through a script block variable, never becomes a FunctionCall.
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/FunctionCall.cs.md#comment1)

using System;

namespace Catzc.Base.ModuleSystem;

public sealed class FunctionCall
{
    public string Name { get; }
    public int Line { get; }

    public FunctionCall(string name, int line)
    {
        if (string.IsNullOrEmpty(name)) { throw new ArgumentException("FunctionCall.Name is required"); }
        Name = name;
        Line = line;
    }

    public override string ToString() => Name + ":" + Line;
}
