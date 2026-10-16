/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/FunctionCall.cs
    folder: types
    name: function-call
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/FunctionCall.cs.md
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
