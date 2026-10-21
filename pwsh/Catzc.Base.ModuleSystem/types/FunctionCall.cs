/*
---
catzc:
  immutable:
    with_body_sha: be8b1c54c406
  edges:
    docs: "[FunctionCall.cs.md](docs/references/pwsh/catzc-base-modulesystem/types/FunctionCall.cs.md)"
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
