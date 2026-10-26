using System;

namespace Catzc.Base.ModuleSystem;

// One statically named command call in a function body: the name as written and the line it starts on.
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
