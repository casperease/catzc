/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/types/FunctionCall.cs.md"
  warning: "Generated Header"
---
*/

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
